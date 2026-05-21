import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../veritabani/veritabani_yardimcisi.dart';

class PomodoroEkrani extends StatefulWidget {
  const PomodoroEkrani({super.key});

  @override
  State<PomodoroEkrani> createState() => _PomodoroEkraniState();
}

class _PomodoroEkraniState extends State<PomodoroEkrani> {
  static const int _calismaSuresi = 1 * 60;
  static const int _molaSuresi = 10 * 60; // 10 Dakika Mola
  
  int _kalanSaniye = _calismaSuresi;
  Timer? _zamanlayici;
  bool _calisiyorMu = false;
  bool _molaMi = false;
  
  final AudioPlayer _sesOynatici = AudioPlayer();

  void _baslatDurdur() {
    if (_calisiyorMu) {
      _zamanlayici?.cancel();
      setState(() => _calisiyorMu = false);
    } else {
      setState(() => _calisiyorMu = true);
      _zamanlayici = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_kalanSaniye > 0) {
          setState(() => _kalanSaniye--);
        } else {
          _sureBitti();
        }
      });
    }
  }

  void _sureBitti() async {
    _zamanlayici?.cancel();
    setState(() => _calisiyorMu = false);
    
    // SES ÇALMA TESTİ VE HATA YAKALAMA
    try {
      debugPrint("Ses çalma komutu gönderiliyor...");
      await _sesOynatici.setVolume(1.0); // Sesi zorla %100 yap
      await _sesOynatici.play(AssetSource('sesler/alarm.mp3'));
      debugPrint("Ses çalma komutu başarıyla çalıştı!");
    } catch (e) {
      debugPrint("SES ÇALINAMADI HATA: $e");
      
      // Ses hatasını göstermeden önceki güvenlik kontrolü
      if (!mounted) return; 
      
      // Hatayı ekranda kırmızı bir uyarı olarak göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ses Hatası: $e', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    if (!_molaMi) {
      await VeritabaniYardimcisi.instance.istatistikEkle('Pomodoro', 25);
      
      // Veritabanı kaydından sonra dialog açmadan önceki güvenlik kontrolü
      if (!mounted) return; 
      
      _alarmDialogGoster("Çalışma Bitti!", "Şimdi 10 dakikalık mola başlıyor.", true);
    } else {
      
      // Try-catch içindeki await'lerden sonra dialog açmadan önceki güvenlik kontrolü
      if (!mounted) return;
      
      _alarmDialogGoster("Mola Bitti!", "Yeniden odaklanma vakti.", false);
    }
  }

  void _alarmDialogGoster(String baslik, String icerik, bool siradakiMolaMi) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(baslik, style: TextStyle(color: siradakiMolaMi ? Colors.green : Colors.indigo)),
        content: Text(icerik),
        actions: [
          ElevatedButton(
            onPressed: () {
              _sesOynatici.stop(); // Alarmi sustur
              Navigator.pop(ctx); // Dialogu kapat
              setState(() {
                _molaMi = siradakiMolaMi; // Mola modunu değiştir
                _kalanSaniye = _molaMi ? _molaSuresi : _calismaSuresi; // Süreyi ayarla
              });
              _baslatDurdur(); // Süreyi OTOMATİK başlat
            },
            child: const Text("Alarmi Kapat & Başlat"),
          )
        ],
      ),
    );
  }

  void _sifirla() {
    _zamanlayici?.cancel();
    _sesOynatici.stop();
    setState(() {
      _calisiyorMu = false;
      _molaMi = false;
      _kalanSaniye = _calismaSuresi;
    });
  }

  @override
  void dispose() {
    _zamanlayici?.cancel();
    _sesOynatici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int dakika = _kalanSaniye ~/ 60;
    int saniye = _kalanSaniye % 60;

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mola Görünürlüğünü Artıran Başlık Kutusu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _molaMi ? Colors.green.shade100 : Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                _molaMi ? "10 Dk Mola Zamanı ☕" : "25 Dk Odaklanma Zamanı 🎯",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _molaMi ? Colors.green.shade800 : Colors.indigo.shade800),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '${dakika.toString().padLeft(2, '0')}:${saniye.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _baslatDurdur,
                  icon: Icon(_calisiyorMu ? Icons.pause : Icons.play_arrow),
                  label: Text(_calisiyorMu ? 'Duraklat' : 'Başlat'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  onPressed: _sifirla,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Sıfırla'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}