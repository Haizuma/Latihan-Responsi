import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk menangani input teks
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Global key untuk validasi form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variabel untuk mengatur visibilitas password
  bool _isPasswordVisible = false;

  // Fungsi untuk melakukan registrasi
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Memvalidasi form sebelum registrasi
      final prefs = await SharedPreferences
          .getInstance(); // Mengambil instance SharedPreferences
      await prefs.setString(
          'username', _usernameController.text); // Menyimpan username
      await prefs.setString(
          'password', _passwordController.text); // Menyimpan password

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Registrasi berhasil!')), // Menampilkan pesan sukses
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50, // Mengatur warna background
      appBar: AppBar(
        elevation: 0, // Menghilangkan shadow di appbar
        backgroundColor: Colors.transparent, // Membuat appbar transparan
        title: Text(
          'Daftar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        centerTitle: true, // Membuat judul berada di tengah
        iconTheme: IconThemeData(
            color: Colors.blue.shade900), // Mengatur warna icon di appbar
      ),
      body: SingleChildScrollView(
        // Membungkus body dengan SingleChildScrollView agar bisa scroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Membuat konten berada di tengah
          children: [
            Form(
              key:
                  _formKey, // Menghubungkan form dengan global key untuk validasi
              child: Column(
                children: [
                  // Field untuk memasukkan nama pengguna
                  TextFormField(
                    controller:
                        _usernameController, // Menghubungkan controller untuk username
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
                      prefixIcon: Icon(Icons.person,
                          color: Colors
                              .blue.shade700), // Ikon untuk field username
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Membuat border melengkung
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pengguna tidak boleh kosong'; // Validasi jika username kosong
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Field untuk memasukkan kata sandi
                  TextFormField(
                    controller:
                        _passwordController, // Menghubungkan controller untuk password
                    obscureText:
                        !_isPasswordVisible, // Mengatur apakah password disembunyikan
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      prefixIcon: Icon(Icons.lock,
                          color: Colors
                              .blue.shade700), // Ikon untuk field password
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons
                                  .visibility_off, // Mengganti ikon untuk melihat atau menyembunyikan password
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Mengubah status visibilitas password
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Membuat border melengkung
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong'; // Validasi jika password kosong
                      } else if (value.length < 6) {
                        return 'Kata sandi harus minimal 6 karakter'; // Validasi panjang password minimal 6 karakter
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Tombol untuk melakukan registrasi
                  ElevatedButton(
                    onPressed:
                        _register, // Menjalankan fungsi registrasi saat tombol ditekan
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade700, // Mengatur warna tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12), // Mengatur padding tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16), // Membuat tombol melengkung
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
