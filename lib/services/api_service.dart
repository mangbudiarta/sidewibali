import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/desa_model.dart';
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
        // contoh status kode untuk email tidak ditemukan
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

  static Future<Map<String, dynamic>?> getAccountDetails(
      int userId, String token) async {
    final url = Uri.parse('$_baseUrl/akun/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load user details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<http.Response> updateProfile({
    required int userId,
    required String namaLengkap,
    required String email,
    required String noTelp,
    String? password,
    String? foto,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse('$_baseUrl/akun/$userId');
    final Map<String, dynamic> body = {
      'nama': namaLengkap,
      'email': email,
      'no_telp': noTelp,
      if (password != null && password.isNotEmpty) 'password': password,
      if (foto != null && foto.isNotEmpty) 'foto': foto,
    };

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return response;
  }

  static Future<http.Response> logout(String accessToken) async {
    final url = Uri.parse('$_baseUrl/akun/logout');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'accessToken': accessToken,
      }),
    );

    return response;
  }

  Future<List<DesaWisata>> fetchDesaWisataList(String token) async {
    final Uri uri = Uri.parse('$_baseUrl/desawisata');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<DesaWisata> desaList =
            data.map((item) => DesaWisata.fromJson(item)).toList();
        return desaList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
