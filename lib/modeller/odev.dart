import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Odev {
  final String id;
  final String baslik;
  final String dersIsmi;
  bool tamamlandiMi;

  Odev({String? id, required this.baslik, required this.dersIsmi, this.tamamlandiMi = false}) 
      : id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'baslik': baslik, 'dersIsmi': dersIsmi, 'tamamlandiMi': tamamlandiMi ? 1 : 0};
  }

  factory Odev.fromMap(Map<String, dynamic> map) {
    return Odev(id: map['id'], baslik: map['baslik'], dersIsmi: map['dersIsmi'], tamamlandiMi: map['tamamlandiMi'] == 1);
  }
}