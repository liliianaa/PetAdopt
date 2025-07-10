import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';

class Authrepostories {
  final String _BaseURL = 'http://10.0.2.2:8000/api';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  //Login
  Future<Map<String, dynamic>> Login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_BaseURL/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: {'email': email, 'password': password},
      );
      print("RESPONSE: ${response.body}");
      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = json['data']['token'];
        final role = json['data']['role'];
        await _tokenManager.saveToken(token);
        await _tokenManager.saveRole(role);
        return {'success': true, 'token': token};
      } else {
        // Ambil pesan error dari response Laravel
        final errorMessage = json['message'] ?? 'Login gagal';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }

  //register
  Future<Map<String, dynamic>> Register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_BaseURL/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: {'name': name, 'email': email, 'password': password},
      );
      print("RESPONSE: ${response.body}");
      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true};
      } else {
        final errorMessage = json['message'] ?? 'Login gagal';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }

  //apakah sudah login
  Future<bool> isLoggedIn() async {
    return await _tokenManager.isAuth();
  }

  //logout
  Future<void> logout() async {
    await _tokenManager.removeToken();
  }

  //mendapatkan token
  Future<String?> getToken() async {
    return await _tokenManager.getToken();
  }

  Future<String?> getUserRole() async {
    return await _tokenManager.getRole(); 
  }
}
