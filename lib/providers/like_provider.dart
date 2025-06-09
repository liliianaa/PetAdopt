import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';

class FavoriteRepository {
  final String _baseURL = 'http://10.0.2.2:8000/api';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  // Toggle Like / Dislike
  Future<Map<String, dynamic>> toggleLike(int hewanId) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.post(
        Uri.parse('$_baseURL/like/$hewanId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': json['message']};
      } else {
        return {'success': false, 'message': json['message'] ?? 'Gagal menyukai hewan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }

  // Fetch daftar hewan favorit (like terbanyak)
  Future<Map<String, dynamic>> getFavoriteHewan() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_baseURL/hewans/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': json['data']};
      } else {
        return {'success': false, 'message': json['message'] ?? 'Gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan server.'};
    }
  }
}
