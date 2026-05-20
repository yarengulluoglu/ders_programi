import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modeller/ders.dart';
import '../modeller/odev.dart';

class VeritabaniYardimcisi {
  static final VeritabaniYardimcisi instance = VeritabaniYardimcisi._init();
  static Database? _veritabani;

  VeritabaniYardimcisi._init();

  Future<Database> get veritabani async {
    if (_veritabani != null) return _veritabani!;
    _veritabani = await _veritabaniOlustur('akilli_ogrenci.db');
    return _veritabani!;
  }

  Future<Database> _veritabaniOlustur(String dosyaYolu) async {
    final dbYolu = await getDatabasesPath();
    final yol = join(dbYolu, dosyaYolu);
    return await openDatabase(yol, version: 1, onCreate: _tablolariOlustur);
  }

  Future _tablolariOlustur(Database db, int versiyon) async {
    // gun sütunu eklendi
    await db.execute('''
      CREATE TABLE dersler (id TEXT PRIMARY KEY, isim TEXT, gun TEXT, baslangicSaati TEXT, hazirlikSuresi INTEGER)
    ''');
    await db.execute('''
      CREATE TABLE odevler (id TEXT PRIMARY KEY, baslik TEXT, dersIsmi TEXT, tamamlandiMi INTEGER)
    ''');
    await db.execute('''
      CREATE TABLE istatistikler (id INTEGER PRIMARY KEY AUTOINCREMENT, tur TEXT, sureDakika INTEGER, tarih TEXT)
    ''');
  }

  // Ders İşlemleri
  Future<void> dersEkle(Ders ders) async {
    final db = await instance.veritabani;
    await db.insert('dersler', ders.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ders>> tumDersleriGetir() async {
    final db = await instance.veritabani;
    final sonuc = await db.query('dersler');
    return sonuc.map((json) => Ders.fromMap(json)).toList();
  }

  // YENİ: Ders Silme Fonksiyonu
  Future<void> dersSil(String id) async {
    final db = await instance.veritabani;
    await db.delete('dersler', where: 'id = ?', whereArgs: [id]);
  }

  // Ödev İşlemleri
  Future<void> odevEkle(Odev odev) async {
    final db = await instance.veritabani;
    await db.insert('odevler', odev.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> odevGuncelle(Odev odev) async {
    final db = await instance.veritabani;
    await db.update('odevler', odev.toMap(), where: 'id = ?', whereArgs: [odev.id]);
  }

  Future<List<Odev>> tumOdevleriGetir() async {
    final db = await instance.veritabani;
    final sonuc = await db.query('odevler');
    return sonuc.map((json) => Odev.fromMap(json)).toList();
  }

  // YENİ: Ödev Silme Fonksiyonu
  Future<void> odevSil(String id) async {
    final db = await instance.veritabani;
    await db.delete('odevler', where: 'id = ?', whereArgs: [id]);
  }

  // İstatistik
  Future<void> istatistikEkle(String tur, int sureDakika) async {
    final db = await instance.veritabani;
    await db.insert('istatistikler', {
      'tur': tur,
      'sureDakika': sureDakika,
      'tarih': DateTime.now().toIso8601String(),
    });
  }
}