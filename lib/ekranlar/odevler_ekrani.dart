import 'package:flutter/material.dart';
import '../modeller/odev.dart';
import '../veritabani/veritabani_yardimcisi.dart';

class OdevlerEkrani extends StatefulWidget {
  const OdevlerEkrani({super.key});

  @override
  State<OdevlerEkrani> createState() => _OdevlerEkraniState();
}

class _OdevlerEkraniState extends State<OdevlerEkrani> {
  List<Odev> _odevler = [];
  final _baslikController = TextEditingController();
  final _dersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ekran açıldığında veritabanındaki kayıtlı ödevleri getirir
    _verileriYukle();
  }

  // Veritabanından listeyi çekip arayüzü güncelleyen fonksiyon
  Future<void> _verileriYukle() async {
    final veriler = await VeritabaniYardimcisi.instance.tumOdevleriGetir();
    setState(() {
      _odevler = veriler;
    });
  }

  // Yeni ödevi veritabanına ekleyen fonksiyon
  void _odevEkle() async {
    if (_baslikController.text.trim().isEmpty || _dersController.text.trim().isEmpty) return;
    
    final yeniOdev = Odev(
      baslik: _baslikController.text.trim(), 
      dersIsmi: _dersController.text.trim()
    );
    
    // Veritabanına kaydet
    await VeritabaniYardimcisi.instance.odevEkle(yeniOdev);
    
    // Text alanlarını temizle
    _baslikController.clear();
    _dersController.clear();
    
    // Listeyi güncelle
    _verileriYukle();
    
    // State'in kendi mounted özelliğini kontrol ediyoruz
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _odevEkleDialogAc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 16, left: 16, right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _baslikController, decoration: const InputDecoration(labelText: 'Ödev Başlığı')),
            TextField(controller: _dersController, decoration: const InputDecoration(labelText: 'İlgili Ders')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _odevEkle, child: const Text('Ekle')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ödev Takibi')),
      body: _odevler.isEmpty 
          ? const Center(child: Text('Henüz eklenmiş bir ödev yok.'))
          : ListView.builder(
        itemCount: _odevler.length,
        itemBuilder: (ctx, index) {
          final odev = _odevler[index];
          return CheckboxListTile(
            title: Text(odev.baslik, style: TextStyle(decoration: odev.tamamlandiMi ? TextDecoration.lineThrough : null)),
            subtitle: Text(odev.dersIsmi),
            value: odev.tamamlandiMi,
            // Checkbox işaretlendiğinde/kaldırıldığında veritabanını güncelleyen kısım
            onChanged: (deger) async {
              odev.tamamlandiMi = deger ?? false;
              await VeritabaniYardimcisi.instance.odevGuncelle(odev);
              _verileriYukle(); 
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _odevEkleDialogAc,
        child: const Icon(Icons.add),
      ),
    );
  }
}