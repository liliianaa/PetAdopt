import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static const String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<String?> registerUser(Register data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': data.name,
        'email': data.email,
        'password': data.password,
      }),
    );

    if (response.statusCode == 200) {
      return "success";
    } else {
      return null;
    }
  }

  Future<String?> loginUser(Login data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': data.email,
        'password': data.password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['data']['token'];

      // Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return token;
    } else {
      return null;
    }
  }
}
