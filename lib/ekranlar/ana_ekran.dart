import 'package:flutter/material.dart';
import 'dersler_ekrani.dart';
import 'odevler_ekrani.dart';
import 'pomodoro_ekrani.dart';
import 'kronometre_ekrani.dart';

class AnaEkran extends StatefulWidget{
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int _seciliSayfaIndeksi = 0;

  final List<Widget>_sayfalar = [
    const DerslerEkrani(),
    const OdevlerEkrani(),
    const PomodoroEkrani(),
    const KronometreEkrani(),
  ];

  void _sayfaDegistir(int indeks) {
    setState(() {
      _seciliSayfaIndeksi = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliSayfaIndeksi],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliSayfaIndeksi,
        onTap: _sayfaDegistir,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Dersler'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Ödevler'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Pomodoro'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_later), label: 'Kronometre'),
        ],
      ),
    );
  }
}