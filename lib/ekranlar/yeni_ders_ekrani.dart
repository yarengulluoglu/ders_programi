import 'package:flutter/material.dart';
import '../modeller/ders.dart';

class YeniDersEkrani extends StatefulWidget {
  final void Function(Ders ders) dersEkle;

  const YeniDersEkrani({super.key, required this.dersEkle});

  @override
  State<YeniDersEkrani> createState() => _YeniDersEkraniState();
}

class _YeniDersEkraniState extends State<YeniDersEkrani> {
  final _isimController = TextEditingController();
  final _saatController = TextEditingController();
  
  String _secilenGun = 'Pazartesi';
  final List<String> _gunler = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

  void _kaydet() {
    if (_isimController.text.trim().isEmpty || 
        _saatController.text.trim().isEmpty) {
      return; 
    }

    widget.dersEkle(
      Ders(
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        isim: _isimController.text,
        gun: _secilenGun, // Artık tarih değil, seçilen günü gönderiyoruz
        baslangicSaati: _saatController.text,
        hazirlikSuresi: 0, 
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Ders Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _isimController, decoration: const InputDecoration(labelText: 'Ders İsmi')),
            const SizedBox(height: 16),
            
            // Gün seçici (Dropdown)
            DropdownButtonFormField<String>(
            initialValue: _secilenGun,
              decoration: const InputDecoration(labelText: 'Ders Günü'),
              items: _gunler.map((gun) {
                return DropdownMenuItem(value: gun, child: Text(gun));
              }).toList(),
              onChanged: (yeniDeger) {
                setState(() { _secilenGun = yeniDeger!; });
              },
            ),
            const SizedBox(height: 16),
            
            TextField(controller: _saatController, decoration: const InputDecoration(labelText: 'Başlama Saati (Örn: 09:30)')),
            const SizedBox(height: 32),
            
            ElevatedButton.icon(onPressed: _kaydet, icon: const Icon(Icons.save), label: const Text('Kaydet'))
          ],
        ),
      ),
    );
  }
}