import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';

class Profilerepositories {
  final String _BaseURL = 'http://10.0.2.2:8000/api';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<Map<String, dynamic>> getProfil() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan'};
    }
  }

  Future<Map<String, dynamic>> getProfileDetail() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/profile/detail'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan'};
    }
  }

  Future<Map<String, dynamic>> ProfileUpdate(String name, String tgl_lahir,
      String jenis_kelamin, String no_telp, String email) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.put(
        Uri.parse('$_BaseURL/profile/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'name': name,
          'tgl_lahir': tgl_lahir,
          'jenis_kelamin': jenis_kelamin,
          'no_telp': no_telp,
          'email': email
        },
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'token': token};
      } else {
        final errorMessage = json['message'] ?? 'Gagal Update Profile';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }
}
