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

  void _dersSil(String id) async {
    await VeritabaniYardimcisi.instance.dersSil(id);
    _verileriYukle();
  }

  void _dersEklemeEkraniniAc() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => YeniDersEkrani(dersEkle: _yeniDersEkle)),
    );
    _verileriYukle(); 
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
                
                final tarihBolenleri = ders.gun.split('-');
                String gosterilecekTarih = ders.gun;
                if (tarihBolenleri.length == 3) {
                  gosterilecekTarih = "${tarihBolenleri[2]}/${tarihBolenleri[1]}/${tarihBolenleri[0]}";
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.book)),
                    title: Text(ders.isim, style: const TextStyle(fontWeight: FontWeight.bold)),
                    
                    // İŞTE BURASI: \n kullanarak tarih ve saati alt alta aldık
                    subtitle: Text('Tarih: $gosterilecekTarih\nSaat: ${ders.baslangicSaati}'),
                    
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
