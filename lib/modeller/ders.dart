import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Ders {
  final String id;
  final String isim;
  final String gun; // Gün değişkeni eklendi
  final String baslangicSaati;
  final int hazirlikSuresi;

  Ders({String? id, required this.isim, required this.gun, required this.baslangicSaati, required this.hazirlikSuresi}) 
      : id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'isim': isim, 'gun': gun, 'baslangicSaati': baslangicSaati, 'hazirlikSuresi': hazirlikSuresi};
  }

  factory Ders.fromMap(Map<String, dynamic> map) {
    return Ders(id: map['id'], isim: map['isim'], gun: map['gun'], baslangicSaati: map['baslangicSaati'], hazirlikSuresi: map['hazirlikSuresi']);
  }
}