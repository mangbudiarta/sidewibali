import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/akomodasi_model.dart';
import 'package:sidewibali/models/berita_model.dart';
import 'package:sidewibali/models/desawisata_model.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/informasi_model.dart';
import 'package:sidewibali/models/kategoridestinasi_model.dart';
import 'package:sidewibali/models/paketwisata_model.dart';
import 'package:sidewibali/models/produk_model.dart';
import 'package:sidewibali/models/ulasan_model.dart';
import 'package:sidewibali/models/notifikasi_model.dart';
import 'dart:convert';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.43.155:3000';

  // Fungsi untuk melakukan register User
  static Future<bool> registerUser(User user) async {
    final url = Uri.parse('$_baseUrl/akun/add');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Fungsi untuk melakukan login User
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse('$_baseUrl/akun/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Email tidak ditemukan'};
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Fungsi untuk mendapatkan detail akun
  static Future<Map<String, dynamic>> fetchAkunDetail(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = '$_baseUrl/akun/$userId';

    Map<String, String> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseBody = jsonDecode(response.body);
      if (responseBody != null) {
        return responseBody;
      } else {
        throw Exception('Response body is null');
      }
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      // data dummy jika error 403 atau 401
      return {
        'nama': 'User',
        'foto': 'https://example.com/default-avatar.png',
      };
    } else {
      throw Exception('Failed to load account details: ${response.statusCode}');
    }
  }

  // Fungsi untuk melakukan update data User
  static Future<Map<String, dynamic>> updateAkun(
      Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/akun/${data['id']}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (!data.containsKey('foto') || data['foto'] == null || kIsWeb) {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': data['nama'],
          'email': data['email'],
          'no_telp': data['no_telp'],
          'password': data['password'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update account');
      }
    } else {
      var request = http.MultipartRequest('PATCH', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['nama'] = data['nama']
        ..fields['email'] = data['email']
        ..fields['no_telp'] = data['no_telp'];

      if (data['password'] != null && data['password'].isNotEmpty) {
        request.fields['password'] = data['password'];
      }

      request.files
          .add(await http.MultipartFile.fromPath('foto', data['foto']));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        return jsonDecode(responseData.body);
      } else {
        final responseData = await http.Response.fromStream(response);
        throw Exception('Failed to update account');
      }
    }
  }

  // Fungsi untuk mendapatkan semua data desa wisata
  Future<List<DesaWisata>> fetchDesaWisataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/desawisata'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => DesaWisata.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load desa wisata list');
    }
  }

  // Fungsi untuk mendapatkan data informasi desa
  Future<InformasiKontak> fetchInformasiKontak(int idDesaWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/informasi/$idDesaWisata'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return InformasiKontak.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load informasi kontak');
    }
  }

  // Fungsi untek mendapatkan data destinasi wisata berdasarkan id
  Future<List<Destinasi>> fetchDestinasiWisata(int idDesaWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/destinasiwisata/desa/$idDesaWisata'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Destinasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinasi wisata');
    }
  }

  // Fungsi untuk mendapatkan semua data akomodasi
  Future<List<Akomodasi>> fetchAkomodasiList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/akomodasi'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Akomodasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load akomodasi list');
    }
  }

  // Fungsi untuk mendapatkan detail akomodasi
  Future<List<Akomodasi>> fetchAkomodasi(int idDesaWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/akomodasi/desa/$idDesaWisata'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Akomodasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load akomodasi');
    }
  }

  // Fungsi untuk mendapatkan nama desa dari id desa
  Future<String> fetchNamaDesa(int idDesa) async {
    try {
      List<DesaWisata> desaWisataList = await fetchDesaWisataList();
      final desa = desaWisataList.firstWhere(
        (desa) => desa.id == idDesa,
        orElse: () => DesaWisata(
          id: -1,
          gambar: '',
          nama: 'Desa Tidak Diketahui',
          kabupaten: '',
          deskripsi: '',
          alamat: '',
          maps: '',
          kategori: '',
        ),
      );
      return desa.nama;
    } catch (e) {
      return 'Desa Tidak Diketahui';
    }
  }

  // Fungsi untuk mendapatkan semua data destinasi
  static Future<List<Destinasi>> fetchDestinasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/destinasiwisata'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Destinasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  // Fungsi untuk mendapatkan kategori destinasi
  Future<List<Kategori>> fetchKategoriDestinasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/kategoridestinasi'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Kategori.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load kategori list');
    }
  }

  // Fungsi untuk mendapatkan kategori dengan id kategori
  Future<String> fetchKategoriDestinasiDetail(int idKategori) async {
    try {
      List<Kategori> kategoriDestinasi = await fetchKategoriDestinasi();
      final kategori = kategoriDestinasi.firstWhere(
        (kategori) => kategori.id == idKategori,
        orElse: () => Kategori(
          id: -1,
          nama: 'kategori Tidak Diketahui',
        ),
      );
      return kategori.nama;
    } catch (e) {
      return 'kategori Tidak Diketahui';
    }
  }

  // Fungsi untuk mendapatkan review dari id destinasi
  Future<List<ReviewDestinasi>> fetchReviewsDestinasi(int destinasiId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/reviewdestinasi/destinasi/$destinasiId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((review) => ReviewDestinasi.fromJson(review))
          .toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // Fungsi untuk mendapatkan semua paket wisata
  static Future<List<PaketWisata>> fetchPaketWisata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/paketwisata'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => PaketWisata.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  Future<void> addReview(ReviewDestinasi review, String token) async {
    final url = Uri.parse('$_baseUrl/reviewdestinasi/add');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(review.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add review');
    }
  }

  // Fungsi untuk mendapatkan semua produk
  static Future<List<Produk>> fetchProduk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/produk'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  // Fungsi untuk mendapatkan semua produk
  static Future<List<Berita>> fetchBerita() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/berita'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Berita.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  static Future<List<ReviewDestinasi>> fetchReviewDestinasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/reviewdestinasi'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ReviewDestinasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

// Fungsi untek mendapatkan data notifikasi berdasrkan idAkun
  Future<List<Notifikasi>> fetchNotifikasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$_baseUrl/notifikasi/akun/$idAkun'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Notifikasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifikasi');
    }
  }

  Future<bool> updateStatusNotifikasi(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.patch(Uri.parse('$_baseUrl/notifikasi/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': 1,
        }));

    return response.statusCode == 200;
  }

  Future<bool> addDesaFavorite(int idDesaWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.post(
      Uri.parse('$_baseUrl/desafavorit/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_akun': idAkun,
        'id_desawisata': idDesaWisata,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteDesaFavorite(int idFavorit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/desafavorit/$idFavorit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<List<int>> fetchMyDesaFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$_baseUrl/desafavorit/akun/$idAkun'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map<int>((item) => item['id_desawisata'] as int).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<int>> fetchAllDesaFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/desafavorit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map<int>((item) => item['id_desawisata'] as int).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<int> fetchIdByIdDesa(int idDesaWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$_baseUrl/desafavorit/akun/$idAkun'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Mencari objek dengan id_desawisata yang sesuai
      var target =
          data.firstWhere((item) => item['id_desawisata'] == idDesaWisata);
      return target['id'] as int;
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<bool> addDestinasiFavorite(int idDestinasiWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.post(
      Uri.parse('$_baseUrl/destinasifavorit/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_akun': idAkun,
        'id_destinasiwisata': idDestinasiWisata,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteDestinasiFavorite(int idFavorit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/destinasifavorit/$idFavorit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<List<int>> fetchMyDestinasiFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$_baseUrl/destinasifavorit/akun/$idAkun'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .map<int>((item) => item['id_destinasiwisata'] as int)
          .toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<int>> fetchAllDestinasiFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/destinasifavorit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .map<int>((item) => item['id_destinasiwisata'] as int)
          .toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<int> fetchIdByIdDestinasi(int idDestinasiWisata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idAkun = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$_baseUrl/destinasifavorit/akun/$idAkun'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Mencari objek dengan id_desawisata yang sesuai
      var target = data.firstWhere(
          (item) => item['id_destinasiwisata'] == idDestinasiWisata);
      return target['id'] as int;
    } else {
      throw Exception('Failed to load favorites');
    }
  }
}
