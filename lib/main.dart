import 'package:flutter/material.dart';
import 'ekranlar/ana_ekran.dart';

void main() {
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
          seedColor: const Color.fromARGB(255, 3, 35, 108), // Ana rengimiz Turkuaz/Nane Yeşili
          brightness: Brightness.light,)
      ),
      home: const AnaEkran(),
    );
  }
}