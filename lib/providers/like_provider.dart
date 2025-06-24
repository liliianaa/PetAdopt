import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/model/Like_response.dart';

class FavoriteRepository {
  final String _baseURL = 'http://10.0.2.2:8000/api/user';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  // Toggle Like / Dislike
  Future<PostLiked> postLikes(int hewanid, PostLiked postliked) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.post(
        Uri.parse('$_baseURL/hewan/$hewanid/like'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: postliked.toJson(),
      );
      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        final data = jsondata['data'];
        return PostLiked.fromJson(data);
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal memuat data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Datum> getlikes(Datum datalike) async {
    try {
      final token = await _tokenManager.getToken();
      final response =
          await http.get(Uri.parse('$_baseURL/hewan/favorite'), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        final data = jsondata['data'];
        return Datum.fromJson(data);
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal memuat data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
