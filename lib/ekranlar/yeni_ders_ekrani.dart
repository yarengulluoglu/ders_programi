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
  final _hazirlikController = TextEditingController();
  
  // Gün seçimi için değişken
  String _secilenGun = 'Pazartesi';
  final List<String> _gunler = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

  void _kaydet() {
    if (_isimController.text.trim().isEmpty || 
        _saatController.text.trim().isEmpty || 
        _hazirlikController.text.trim().isEmpty) {
      return; // Basit doğrulama
    }

    final girilenHazirlik = int.tryParse(_hazirlikController.text);
    if (girilenHazirlik == null || girilenHazirlik <= 0) return;

    widget.dersEkle(
      Ders(
        isim: _isimController.text,
        gun: _secilenGun, // Gün eklendi
        baslangicSaati: _saatController.text,
        hazirlikSuresi: girilenHazirlik,
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
            
            // Gün seçici (Dropdown) eklendi
            DropdownButtonFormField<String>(
              value: _secilenGun,
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
            const SizedBox(height: 16),
            TextField(controller: _hazirlikController, decoration: const InputDecoration(labelText: 'Hazırlık/Yol (Dakika)'), keyboardType: TextInputType.number),
            const SizedBox(height: 32),
            ElevatedButton.icon(onPressed: _kaydet, icon: const Icon(Icons.save), label: const Text('Kaydet'))
          ],
        ),
      ),
    );
  }
}