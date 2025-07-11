import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:petadopt/bloc/admin/admin_bloc.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/model/List_shelter_admin.dart';
import 'package:http/http.dart' as http;
import 'package:petadopt/model/acc_pemohon_model.dart';
import 'package:petadopt/model/dashboard_admin_model.dart';
import 'package:petadopt/model/getNotifikasiAdmin_model.dart';

class Adminrepository {
  final String _BaseURL = 'http://10.0.2.2:8000/api/admin';
  final SharedPrefHelper _tokenManager = SharedPrefHelper();

  Future<List<Datum>> getpermohonanshelter() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/daftar-permohonan-shelter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        if (data is List) {
          return data.map((e) => Datum.fromMap(e)).toList();
        } else {
          throw Exception('Data tidak valid');
        }
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal memuat data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Acclistpemohonmodel> updateStatuspermohonanshelter(
      int permohonan, Acclistpemohonmodel modelpemohon) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.post(
          Uri.parse('$_BaseURL/permohonan-shelter/$permohonan/verifikasi'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: modelpemohon.toJson());
      if (response.statusCode == 200) {
        // final jsondata = jsonDecode(response.body);
        return Acclistpemohonmodel.fromJson(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal update status');
      }
    } catch (e) {
      throw Exception('Error saat update status: $e');
    }
  }

  Future<DashboardAdminModel> getjumlahuser() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/dashboard/user-stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        return DashboardAdminModel.fromJson(response.body);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal mengambil data dashboard');
      }
    } catch (e) {
      throw Exception('Error saat update status: $e');
    }
  }

  Future<DashboardAdminModel> getjumlahhewan() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/dashboard/hewan-stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        return DashboardAdminModel.fromJson(response.body);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal mengambil data dashboard');
      }
    } catch (e) {
      throw Exception('Error saat update status: $e');
    }
  }

  Future<List<NotifikasiMod>> getnotifikasi() async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('$_BaseURL/notifikasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
       final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        if (data is List) {
          return data.map((e) => NotifikasiMod.fromMap(e)).toList();
        } else {
          throw Exception('Data tidak valid');
        }
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal memuat data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
