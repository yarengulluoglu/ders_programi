import 'dart:async';
import 'package:flutter/material.dart';
import '../veritabani/veritabani_yardimcisi.dart';

class KronometreEkrani extends StatefulWidget {
  const KronometreEkrani({super.key});

  @override
  State<KronometreEkrani> createState() => _KronometreEkraniState();
}

class _KronometreEkraniState extends State<KronometreEkrani> {
  final Stopwatch _kronometre = Stopwatch();
  Timer? _zamanlayici;

  void _baslatDurdur() async {
    if (_kronometre.isRunning) {
      _kronometre.stop();
      _zamanlayici?.cancel();
      
      // Durdurulduğunda eğer 1 dakikadan fazla sürdüyse veritabanına kaydet
      int gecenDakika = _kronometre.elapsed.inMinutes;
      if (gecenDakika > 0) {
        await VeritabaniYardimcisi.instance.istatistikEkle('Serbest Çalışma (Kronometre)', gecenDakika);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$gecenDakika dakikalık çalışma kaydedildi.')),
        );
      }
      setState(() {});
    } else {
      _kronometre.start();
      _zamanlayici = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        setState(() {}); 
      });
    }
  }

  void _sifirla() {
    setState(() {
      _kronometre.stop();
      _kronometre.reset();
      _zamanlayici?.cancel();
    });
  }

  @override
  void dispose() {
    _zamanlayici?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sure = _kronometre.elapsed;
    String formatliSure = '${sure.inMinutes.toString().padLeft(2, '0')}:'
        '${(sure.inSeconds % 60).toString().padLeft(2, '0')}.'
        '${(sure.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Kronometre')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatliSure,
              style: const TextStyle(fontSize: 60, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _baslatDurdur,
                  child: Text(_kronometre.isRunning ? 'Durdur' : 'Başlat'),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _sifirla,
                  child: const Text('Sıfırla'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}