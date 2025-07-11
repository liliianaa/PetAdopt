import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/model/PengajuanShelter_model.dart.';

class PermohonanAdopsiRepository {
  final String _baseURL = 'http://10.0.2.2:8000/api/user';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<Either<String, PengajuanShelter>> uploadPermohonanAdopsi(File file) async {
    try {
      final token = await _tokenManager.getToken();
      final uri = Uri.parse('$_baseURL/pengajuan-shelter');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final multipartFile = await http.MultipartFile.fromPath(
        'file', // harus sama dengan key di Laravel ($request->file)
        file.path,
        contentType: MediaType.parse(mimeType),
        filename: basename(file.path),
      );

      request.files.add(multipartFile);

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (responseString.isEmpty) {
        return Left('Server tidak memberikan respons.');
      }

      final jsonResponse = json.decode(responseString);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final pengajuan = PengajuanShelter.fromJson(jsonResponse);
        return Right(pengajuan);
      } else {
        final errorMsg = jsonResponse['message'] ?? 'Gagal mengunggah permohonan.';
        return Left(errorMsg);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
