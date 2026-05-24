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
          ? const Center(child: Text('Ders Yok. Sağ alttan ekleyebilirsiniz.'))
          : SingleChildScrollView( // Ekrana sığmazsa aşağı kaydırma
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( // Ekrana sığmazsa sağa kaydırma
                scrollDirection: Axis.horizontal,
                child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
                  columns: const [
                    DataColumn(label: Text('Ders', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Gün', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Saat', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Sil', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: _kayitliDersler.map((ders) {
                    return DataRow(cells: [
                      DataCell(Text(ders.isim)),
                      DataCell(Text(ders.gun)),
                      DataCell(Text(ders.baslangicSaati)),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _dersSil(ders.id),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(onPressed: _dersEklemeEkraniniAc, child: const Icon(Icons.add)),
    );
  }
}