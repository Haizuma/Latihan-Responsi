import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class ListScreen extends StatelessWidget {
  final String menu;

  // Konstruktor untuk menerima menu (articles, blogs, reports)
  ListScreen({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          menu == 'articles'
              ? 'News'
              : menu == 'blogs'
                  ? 'Blog'
                  : 'Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue.shade900,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().fetchData(menu), // Ambil data dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menunggu response dari API
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan error jika terjadi kesalahan
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else {
            final data = snapshot.data!; // Data yang diterima dari API
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: data.length, // Jumlah item yang diterima
              itemBuilder: (context, index) {
                final item = data[index]; // Data per item
                return _buildCard(
                  context,
                  title: item['title'] ?? 'Tidak ada judul',
                  imageUrl: _validateImageUrl(item['image_url']),
                  source: item['news_site'] ?? 'Sumber tidak diketahui',
                  date: item['published_at'] ?? 'Tanggal tidak diketahui',
                  summary: item['summary'] ?? '',
                  url: item['url'] ?? '',
                  id: item['id'].toString(),
                  menu: menu,
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membangun card untuk setiap item dalam list
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required String source,
    required String date,
    required String summary,
    required String url,
    required String id,
    required String menu,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke detail screen saat card ditekan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              menu: menu,
              id: id,
              url: url,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Menampilkan gambar jika sudah dimuat
                  } else {
                    // Menampilkan progress loading gambar
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300], // Gambar error placeholder
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Bagian Konten
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Judul item
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                    maxLines: 2, // Maksimal 2 baris judul
                    overflow:
                        TextOverflow.ellipsis, // Menggulung teks jika panjang
                  ),
                  SizedBox(height: 8),
                  Text(
                    summary, // Ringkasan konten
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    maxLines: 3, // Maksimal 3 baris ringkasan
                    overflow:
                        TextOverflow.ellipsis, // Menggulung teks jika panjang
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        source, // Sumber berita
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        _formatDate(date), // Format tanggal
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk memvalidasi URL gambar
  String _validateImageUrl(String? imageUrl) {
    // Jika URL gambar tidak valid atau kosong, gunakan placeholder
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        !Uri.parse(imageUrl).isAbsolute) {
      return 'https://via.placeholder.com/300'; // URL placeholder
    }
    return imageUrl;
  }

  // Helper untuk memformat tanggal
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString); // Parsing string tanggal
      return '${date.day}-${date.month}-${date.year}'; // Format tanggal DD-MM-YYYY
    } catch (e) {
      return 'Tanggal tidak valid'; // Menangani kesalahan parsing tanggal
    }
  }
}
