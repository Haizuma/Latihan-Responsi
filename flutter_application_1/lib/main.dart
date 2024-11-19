import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Responsi Haizuma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Menentukan warna utama aplikasi
        scaffoldBackgroundColor:
            Colors.blueGrey.shade50, // Mengatur warna latar belakang aplikasi
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32,
              fontWeight:
                  FontWeight.bold), // Gaya untuk teks besar (misalnya judul)
          bodyLarge: TextStyle(
              fontSize: 16, color: Colors.grey), // Gaya untuk teks biasa
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Membuat AppBar transparan
          elevation: 0, // Menghapus bayangan pada AppBar
          iconTheme: IconThemeData(
              color: Colors.blue.shade900), // Mengatur warna ikon di AppBar
        ),
      ),
      home: LoginScreen(),
    );
  }
}
