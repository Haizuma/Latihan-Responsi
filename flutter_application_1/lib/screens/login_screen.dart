import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk menangani input teks
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Global key untuk validasi form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variabel untuk mengatur visibilitas password
  bool _isPasswordVisible = false;

  // Fungsi untuk melakukan login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Memvalidasi form sebelum login
      final prefs = await SharedPreferences
          .getInstance(); // Mengambil instance SharedPreferences
      final savedUsername =
          prefs.getString('username'); // Mengambil username yang disimpan
      final savedPassword =
          prefs.getString('password'); // Mengambil password yang disimpan

      // Memeriksa apakah username dan password sesuai dengan yang disimpan
      if (_usernameController.text == savedUsername &&
          _passwordController.text == savedPassword) {
        Navigator.pushReplacement(
          // Jika cocok, pindah ke HomeScreen
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Nama pengguna atau kata sandi salah')), // Menampilkan pesan error jika login gagal
        );
      }
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
          'Masuk',
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
            SizedBox(height: 30),
            // Icon untuk menunjukkan aplikasi terkait berita
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue.shade700,
              child: Icon(
                Icons.article,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            // Form login
            Form(
              key: _formKey,
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
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Tombol untuk melakukan login
                  ElevatedButton(
                    onPressed:
                        _login, // Menjalankan fungsi login saat tombol ditekan
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
                      'Masuk',
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
            SizedBox(height: 20),
            // Tautan untuk menuju halaman pendaftaran
            Text(
              'Belum memiliki akun?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  // Mengarahkan pengguna ke halaman register
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Daftar di sini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
