import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart'; // Alarm paketini projemize dahil ediyoruz
import 'ekranlar/ana_ekran.dart';

void main() async {
  // Eklentilerin (plugins) runApp'ten önce başlatılabilmesi için bu satır şarttır
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uygulama başlarken arka plandaki alarm servisini hazırlıyoruz
  await Alarm.init();

  runApp(const AkilliOgrenciApp());
}

class AkilliOgrenciApp extends StatelessWidget {
  const AkilliOgrenciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akıllı Öğrenci Asistanı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 35, 108), // Ana rengimiz
          brightness: Brightness.light,
        )
      ),
      home: const AnaEkran(),
    );
  }
}