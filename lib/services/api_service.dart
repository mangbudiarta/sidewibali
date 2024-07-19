import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.18.24:3000';

  // Fungsi untuk melakukan register User
  static Future<bool> registerUser(User user) async {
    var url = Uri.parse('$_baseUrl/akun/add');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Fungsi untuk melakukan login
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    var url = Uri.parse('$_baseUrl/akun/login');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message']
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', data['email']);
    await prefs.setString('name', data['name']);
    await prefs.setBool('isLoggedIn', true);
  }
}
