import 'dart:convert';

import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/models/pet_model.dart';
import 'package:http/http.dart' as http;

class petsrepository {
  final String _BaseURL = 'http://10.0.2.2:8000/api';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<Map<String, dynamic>> getHewanuploaded() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/profile/my-pets'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hewanmodel = hewanmodelFromJson(jsonEncode(data));
        return {'success': true, 'data': hewanmodel.data};
      } else {
        return {'success': false, 'message': 'gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'terjadi kesalahan'};
    }
  }
}
