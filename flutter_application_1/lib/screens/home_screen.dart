import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = ''; // Variabel untuk menyimpan username pengguna

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Memanggil fungsi untuk memuat username saat halaman pertama kali dimuat
  }

  // Fungsi untuk memuat username dari SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences
        .getInstance(); // Mengambil instance SharedPreferences
    setState(() {
      _username = prefs.getString('username') ??
          ''; // Mengambil username yang disimpan, jika tidak ada, set ke string kosong
    });
  }

  // Fungsi untuk logout dan mengarahkan pengguna kembali ke LoginScreen
  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50, // Mengatur warna background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Mengatur tinggi app bar
        child: AppBar(
          elevation: 0, // Menghilangkan shadow di app bar
          backgroundColor: Colors.transparent, // Membuat app bar transparan
          title: Text(
            'Hai, $_username', // Menampilkan username pengguna di judul
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.blue.shade900,
            ),
          ),
          centerTitle: true, // Membuat judul berada di tengah
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0), // Padding untuk body
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Menyusun child secara vertikal
          children: [
            SizedBox(height: 16),
            Text(
              "Jelajahi Kategori", // Judul untuk kategori menu
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                // Menampilkan list kategori dengan scrollable
                children: [
                  _buildMenuCard(
                    context,
                    title: 'News',
                    description:
                        'Ikuti berita terbaru tentang eksplorasi luar angkasa!',
                    icon: Icons.newspaper_outlined, // Ikon untuk kategori News
                    menuType:
                        'articles', // Tipe menu yang digunakan untuk navigasi
                    gradientColors: [
                      Colors.blue.shade400,
                      Colors.blue.shade700,
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    title: 'Blog',
                    description:
                        'Baca blog mendalam tentang misi luar angkasa.',
                    icon: Icons.book_outlined,
                    menuType: 'blogs',
                    gradientColors: [
                      Colors.purple.shade400,
                      Colors.purple.shade700,
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    title: 'Report',
                    description:
                        'Akses laporan lengkap dari misi luar angkasa.',
                    icon: Icons.report_outlined,
                    menuType: 'reports',
                    gradientColors: [
                      Colors.teal.shade400,
                      Colors.teal.shade700,
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Tombol Logout
            Center(
              child: ElevatedButton.icon(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12), // Padding tombol
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), // Membuat tombol melengkung
                  ),
                  backgroundColor: Colors.red.shade600, // Warna tombol logout
                  elevation: 8, // Efek bayangan tombol
                ),
                icon: Icon(Icons.logout, color: Colors.white), // Ikon logout
                label: Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat card menu
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String menuType, // Jenis menu untuk menentukan rute
    required List<Color> gradientColors, // Warna gradien untuk card
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ListScreen(menu: menuType)), // Navigasi ke halaman ListScreen
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors, // Warna gradien
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16), // Membuat card melengkung
          boxShadow: [
            BoxShadow(
              color:
                  Colors.grey.withOpacity(0.3), // Efek bayangan di sekitar card
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding di dalam card
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    Colors.white.withOpacity(0.3), // Warna latar belakang ikon
                child: Icon(icon, size: 30, color: Colors.white), // Ikon menu
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Menyusun teks secara vertikal
                  children: [
                    Text(
                      title, // Menampilkan judul menu
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description, // Menampilkan deskripsi menu
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16), // Ikon panah untuk menunjukkan navigasi
            ],
          ),
        ),
      ),
    );
  }
}
