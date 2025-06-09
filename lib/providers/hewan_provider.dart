import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/model/hewan_respon_model.dart';

class Hewanrepositories {
  final String _BaseURL = 'http://10.0.2.2:8000/api';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<Either<String, Datum>> addHewan({
    required String nama,
    required String jenis_kelamin,
    required String warna,
    required String jenis_hewan,
    required String umur,
    required String status,
    required String lokasi,
    required String deskripsi,
    File? imageFile,
  }) async {
    try {
      final token = await _tokenManager.getToken();
      final uri = Uri.parse('$_BaseURL/hewan');
      final request = http.MultipartRequest('POST', uri);

      // Header authorization dan content type
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Fields data form
      request.fields.addAll({
        'nama': nama,
        'jenis_kelamin': jenis_kelamin,
        'warna': warna,
        'jenis_hewan': jenis_hewan,
        'umur': umur,
        'status': status,
        'lokasi': lokasi,
        'deskripsi': deskripsi,
      });

      // Jika ada gambar, tambahkan file multipart
      if (imageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        );
        request.files.add(multipartFile);
      }

      // Kirim request
      final response = await request.send();

      // Baca response sebagai string
      final responseString = await response.stream.bytesToString();

      if (responseString.isEmpty) {
        return Left('Server tidak memberikan response.');
      }

      // Decode JSON
      final jsonResponse = jsonDecode(responseString);

      // Cek status code sukses (200 atau 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonResponse['data'];
        if (data == null || data is! Map<String, dynamic>) {
          return Left(
              jsonResponse['message'] ?? 'Data hewan tidak valid dari server.');
        }
        final datum = Datum.fromJson(data);
        return Right(datum);
      } else {
        return Left(jsonResponse['message'] ?? 'Gagal menambahkan hewan');
      }
    } catch (e) {
      // Tangkap error apapun dan return Left dengan pesan error
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Hewan?> getHewan({int? id}) async {
    try {
      final token = await _tokenManager.getToken();

      String url = '$_BaseURL/hewan';
      if (id != null) {
        url += '/$id';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (id == null) {
          return Hewan.fromJson(jsonData);
        } else {
          final datumJson = jsonData["data"];
          return Hewan(
            message: jsonData["message"],
            data: datumJson == null ? [] : [Datum.fromJson(datumJson)],
          );
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error getHewan: $e");
      return null;
    }
  }

  Future<Either<String, Datum>> getHewanById(int id) async {
    try {
      final token = await _tokenManager.getToken();
      final url = '$_BaseURL/hewan/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final dataField = jsonData['data'];
        if (dataField == null) {
          return Left('Data hewan tidak ditemukan');
        }

        if (dataField is List) {
          if (dataField.isEmpty) {
            return Left('Data hewan kosong');
          }
          return Right(Datum.fromJson(dataField[0]));
        } else if (dataField is Map<String, dynamic>) {
          return Right(Datum.fromJson(dataField));
        } else {
          return Left('Format data tidak dikenali');
        }
      } else if (response.statusCode == 404) {
        return Left('Hewan dengan id $id tidak ditemukan');
      } else {
        return Left('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, List<Datum>>> getHewanByJenis(String jenis) async {
    try {
      final token = await _tokenManager.getToken();
      final url = '$_BaseURL/jenis/$jenis';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final dataField = jsonData['data'];

        if (dataField == null || dataField.isEmpty) {
          return Left('Data hewan tidak ditemukan');
        }

        if (dataField is List) {
          final hewanList = dataField.map((e) => Datum.fromJson(e)).toList();
          return Right(hewanList);
        } else {
          return Left('Format data tidak dikenali');
        }
      } else if (response.statusCode == 400) {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Jenis tidak valid';
        return Left(errorMessage);
      } else {
        return Left('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateHewan({
    required String id,
    required String nama,
    required String jenis_kelamin,
    required String warna,
    required String jenis_hewan,
    required String umur,
    required String status,
    required String deskripsi,
    File? imageFile,
  }) async {
    try {
      final token = await _tokenManager.getToken();

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_BaseURL/hewan/$id'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add fields
      request.fields['nama'] = nama;
      request.fields['jenis_kelamin'] = jenis_kelamin;
      request.fields['warna'] = warna;
      request.fields['jenis_hewan'] = jenis_hewan;
      request.fields['umur'] = umur;
      request.fields['status'] = status;
      request.fields['deskripsi'] = deskripsi;

      // Add image file if provided
      if (imageFile != null) {
        var fileStream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = http.MultipartFile(
          'image', // This should match the field name expected by your API
          fileStream,
          length,
          filename: imageFile.path.split('/').last,
        );

        request.files.add(multipartFile);
      }

      // Send request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': json};
      } else {
        final errorMessage = json['message'] ?? 'Gagal Update Hewan';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan server: ${e.toString()}'
      };
    }
  }
}
