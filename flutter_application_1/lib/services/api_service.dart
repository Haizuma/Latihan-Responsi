import 'dart:convert'; // Untuk mengonversi data JSON ke dalam format yang bisa digunakan
import 'package:http/http.dart'
    as http; // Menggunakan package http untuk membuat request API

class ApiService {
  // URL dasar untuk API
  final String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  // Fungsi untuk mengambil daftar data dari API dengan pagination
  Future<List<dynamic>> fetchData(String menu,
      {int limit = 10, int offset = 0}) async {
    // Membuat URL dengan parameter limit dan offset untuk pagination
    final url = Uri.parse('$_baseUrl/$menu/?limit=$limit&offset=$offset');
    try {
      final response = await http.get(url); // Mengirim request GET ke API

      if (response.statusCode == 200) {
        // Mengecek apakah status code adalah 200 (OK)
        final jsonData = json.decode(
            response.body); // Mengonversi response body menjadi objek JSON
        if (jsonData.containsKey('results')) {
          return jsonData[
              'results']; // Mengembalikan daftar data yang terdapat pada key 'results'
        } else {
          throw Exception(
              'Missing "results" in the response.'); // Menangani jika tidak ada key 'results'
        }
      } else {
        // Jika status code bukan 200, throw exception dengan pesan error
        throw Exception(
            'Failed to load $menu data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani jika terjadi error saat melakukan request
      throw Exception('Error fetching $menu data: $e');
    }
  }

  // Fungsi untuk mengambil data detail berdasarkan ID
  Future<Map<String, dynamic>> fetchDetail(String menu, String id) async {
    final url =
        Uri.parse('$_baseUrl/$menu/$id/'); // Membuat URL untuk request detail
    try {
      final response = await http.get(url); // Mengirim request GET ke API

      if (response.statusCode == 200) {
        return json.decode(response
            .body); // Mengonversi response body menjadi Map dan mengembalikannya
      } else {
        throw Exception(
            'Failed to load detail for $menu with ID $id. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani jika terjadi error saat mengambil detail
      throw Exception('Error fetching detail for $menu with ID $id: $e');
    }
  }

  // Fungsi untuk mengambil jumlah total item dari menu
  Future<int> fetchTotalCount(String menu) async {
    final url = Uri.parse(
        '$_baseUrl/$menu/'); // Membuat URL untuk mengambil total count
    try {
      final response = await http.get(url); // Mengirim request GET ke API

      if (response.statusCode == 200) {
        final jsonData = json.decode(
            response.body); // Mengonversi response body menjadi objek JSON
        if (jsonData.containsKey('count')) {
          return jsonData[
              'count']; // Mengembalikan jumlah total item yang terdapat pada key 'count'
        } else {
          throw Exception(
              'Missing "count" in the response.'); // Menangani jika tidak ada key 'count'
        }
      } else {
        throw Exception(
            'Failed to fetch total count for $menu. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani jika terjadi error saat mengambil total count
      throw Exception('Error fetching total count for $menu: $e');
    }
  }

  // Fungsi untuk mengambil data dengan fitur pencarian
  Future<List<dynamic>> searchData(String menu, String query) async {
    final url = Uri.parse(
        '$_baseUrl/$menu/?search=$query'); // Membuat URL dengan parameter pencarian
    try {
      final response = await http.get(url); // Mengirim request GET ke API

      if (response.statusCode == 200) {
        final jsonData = json.decode(
            response.body); // Mengonversi response body menjadi objek JSON
        if (jsonData.containsKey('results')) {
          return jsonData[
              'results']; // Mengembalikan hasil pencarian yang terdapat pada key 'results'
        } else {
          throw Exception(
              'Missing "results" in the search response.'); // Menangani jika tidak ada key 'results'
        }
      } else {
        // Menangani jika status code bukan 200
        throw Exception(
            'Failed to search $menu with query "$query". Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani jika terjadi error saat melakukan pencarian
      throw Exception('Error searching $menu with query "$query": $e');
    }
  }
}
