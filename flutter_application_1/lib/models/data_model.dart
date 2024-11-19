class DataModel {
  final int id; // Menyimpan ID data (misalnya artikel atau entri lainnya)
  final String title; // Menyimpan judul data
  final String url; // Menyimpan URL data (misalnya link artikel)

  // Konstruktor yang menerima parameter id, title, dan url
  DataModel({
    required this.id,
    required this.title,
    required this.url,
  });

  // Factory constructor untuk membuat instance DataModel dari Map JSON
  factory DataModel.fromJson(Map<String, dynamic> json) {
    // Memastikan bahwa nilai null atau ketidakhadiran field tidak menyebabkan error
    return DataModel(
      id: json['id'] ?? 0, // Defaultkan id menjadi 0 jika 'id' tidak ditemukan
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
    );
  }
}
