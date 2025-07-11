import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/model/DetailProfile_model.dart';

class Profilerepositories {
  final String _BaseURL = 'http://10.0.2.2:8000/api/user';
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

  Future<DetailProfileModel> ProfileUpdate(
      DetailProfileModel Profiledetailmodel) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.put(
        Uri.parse('$_BaseURL/profile/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(Profiledetailmodel.toMap()),
        // print("Body yang dikirim: ${jsonEncode(Profiledetailmodel.toMap())}");
        // print("Response: ${response.body}");
      );
      if (response.statusCode == 200) {
        return DetailProfileModel.fromJson(response.body);
      } else {
        throw Exception("Gagal memuat data profil");
      }
    } catch (e) {
      throw Exception("tidak ada data");
    }
  }

  Future<Map<String, dynamic>> Profilepassupdate(
      String old_password, String new_password, String confrim_password) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.put(
        Uri.parse('$_BaseURL/update-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'old_password': old_password,
          'new_password': new_password,
          'new_password_confirmation': confrim_password,
        },
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': json['data'], 'token': token};
      } else {
        final errorMessage = json['message'] ?? 'Gagal Update Profile';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }
}
