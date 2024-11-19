import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final String menu;
  final String id;
  final String url;

  DetailScreen({
    required this.menu,
    required this.id,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          menu == 'articles'
              ? 'Detail Berita'
              : menu == 'blogs'
                  ? 'Detail Blog'
                  : 'Detail Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue.shade900,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService()
            .fetchDetail(menu, id), // Ambil data detail menggunakan API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error handling
          } else {
            final data = snapshot.data!; // Ambil data dari snapshot
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian Gambar
                  _buildImage(
                      data), // Fungsi untuk menampilkan gambar dengan error handling
                  // Bagian Konten
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul artikel
                        Text(
                          data['title'] ??
                              'No Title', // Menampilkan judul atau teks default
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Sumber dan Tanggal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['news_site'] ??
                                  'Unknown Source', // Sumber berita
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              _formatDate(data['published_at'] ??
                                  ''), // Menampilkan tanggal yang diformat
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Ringkasan artikel
                        Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['summary'] ??
                              'No Summary Available', // Ringkasan artikel atau teks default
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 24),
                        // Tombol untuk membuka artikel asli
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchURL(url); // Fungsi untuk membuka URL
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.blue.shade700,
                            ),
                            icon: Icon(Icons.open_in_browser,
                                color: Colors.white),
                            label: Text(
                              'Buka Artikel Asli',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membuka URL menggunakan package url_launcher
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url); // Membuka URL di browser
    } else {
      throw 'Could not launch $url'; // Menangani jika URL tidak bisa diluncurkan
    }
  }

  // Helper untuk memformat tanggal menjadi format DD-MM-YYYY
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString); // Parsing tanggal
      return '${date.day}-${date.month}-${date.year}'; // Mengembalikan format tanggal
    } catch (e) {
      return 'Invalid Date'; // Menangani jika parsing gagal
    }
  }

  // Fungsi untuk menangani tampilan gambar dengan error handling
  Widget _buildImage(Map<String, dynamic> data) {
    final imageUrl = data['image_url']; // Ambil URL gambar
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        child: Image.network(
          imageUrl, // Menampilkan gambar
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Menampilkan gambar saat selesai dimuat
            } else {
              return Center(
                child: CircularProgressIndicator(
                  // Menampilkan indikator loading
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons
                  .broken_image, // Menampilkan ikon error jika gambar gagal dimuat
              size: 250,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      return SizedBox.shrink(); // Tidak ada gambar, tampilkan ruang kosong
    }
  }
}
