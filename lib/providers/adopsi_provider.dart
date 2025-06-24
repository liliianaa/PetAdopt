import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';

class Adopsirepositories {
  final String _BaseURL = 'http://10.0.2.2:8000/api/user';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<Either<String, String>> submitPengajuanAdopsi({
    required int hewanId,
    required String nama,
    required String umur,
    required String noHp,
    required String email,
    required String nik,
    required String jenisKelamin,
    required String tempatTanggalLahir,
    required String pekerjaan,
    required String alamat,
    String? riwayatAdopsi,
  }) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.post(
        Uri.parse('$_BaseURL/permohonan-adopsi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'hewan_id': hewanId.toString(),
          'nama': nama,
          'umur': umur,
          'no_hp': noHp,
          'email': email,
          'nik': nik,
          'jenis_kelamin': jenisKelamin,
          'tempat_tanggal_lahir': tempatTanggalLahir,
          'pekerjaan': pekerjaan,
          'alamat': alamat,
          'riwayat_adopsi': riwayatAdopsi ?? '',
        },
      );

      if (response.statusCode == 201) {
        return const Right('Pengajuan berhasil dikirim');
      } else {
        return Left('Gagal: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
