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
  
  DateTime _secilenTarih = DateTime.now();

  void _tarihSec() async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: _secilenTarih,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
    );

    if (secilen != null) {
      setState(() {
        _secilenTarih = secilen;
      });
    }
  }

  void _kaydet() {
    if (_isimController.text.trim().isEmpty || 
        _saatController.text.trim().isEmpty) {
      return; 
    }

    String tarihFormatli = "${_secilenTarih.year}-${_secilenTarih.month.toString().padLeft(2, '0')}-${_secilenTarih.day.toString().padLeft(2, '0')}";

    widget.dersEkle(
      Ders(
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        isim: _isimController.text,
        gun: tarihFormatli, 
        baslangicSaati: _saatController.text,
        hazirlikSuresi: 0, // Veritabanı hata vermesin diye sessizce 0 gönderiyoruz
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
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Ders Tarihi: ${_secilenTarih.day}/${_secilenTarih.month}/${_secilenTarih.year}', style: const TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.calendar_month, color: Colors.blue),
              onTap: _tarihSec,
            ),
            const Divider(),
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