import 'package:flutter/material.dart';
import '../modeller/ders.dart';
import 'yeni_ders_ekrani.dart';
import '../veritabani/veritabani_yardimcisi.dart';

class DerslerEkrani extends StatefulWidget {
  const DerslerEkrani({super.key});

  @override
  State<DerslerEkrani> createState() => _DerslerEkraniState();
}

class _DerslerEkraniState extends State<DerslerEkrani> {
  List<Ders> _kayitliDersler = [];

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    final dersler = await VeritabaniYardimcisi.instance.tumDersleriGetir();
    setState(() { _kayitliDersler = dersler; });
  }

  void _yeniDersEkle(Ders yeniDers) async {
    await VeritabaniYardimcisi.instance.dersEkle(yeniDers);
    _verileriYukle();
  }

  // YENİ: Dersi silme metodu
  void _dersSil(String id) async {
    await VeritabaniYardimcisi.instance.dersSil(id);
    _verileriYukle(); // Listeyi yenile
  }

  void _dersEklemeEkraniniAc() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => YeniDersEkrani(dersEkle: _yeniDersEkle)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ders Programım'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: _kayitliDersler.isEmpty
          ? const Center(child: Text('Ders Yok.'))
          : ListView.builder(
              itemCount: _kayitliDersler.length,
              itemBuilder: (ctx, indeks) {
                final ders = _kayitliDersler[indeks];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.book)),
                    title: Text(ders.isim, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${ders.gun} - Saat: ${ders.baslangicSaati} | Hazırlık: ${ders.hazirlikSuresi}dk'),
                    // Çöp Kutusu İkonu Eklendi
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _dersSil(ders.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _dersEklemeEkraniniAc, child: const Icon(Icons.add)),
    );
  }
}