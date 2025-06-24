// To parse this JSON data, do
//
//     final pemohonmodel = pemohonmodelFromJson(jsonString);

import 'dart:convert';

Pemohonmodel pemohonmodelFromJson(String str) =>
    Pemohonmodel.fromJson(json.decode(str));

String pemohonmodelToJson(Pemohonmodel data) => json.encode(data.toJson());

class Pemohonmodel {
  String message;
  Data data;

  Pemohonmodel({
    required this.message,
    required this.data,
  });

  factory Pemohonmodel.fromJson(Map<String, dynamic> json) => Pemohonmodel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int userId;
  int hewanId;
  int permohonanId;
  String namaLengkap;
  int umur;
  String noHp;
  String email;
  String nik;
  String jenisKelamin;
  String tempatTanggalLahir;
  String pekerjaan;
  String alamat;
  String riwayatAdopsi;
  String status;
  DateTime tanggalPermohonan;

  Data({
    required this.userId,
    required this.hewanId,
    required this.permohonanId,
    required this.namaLengkap,
    required this.umur,
    required this.noHp,
    required this.email,
    required this.nik,
    required this.jenisKelamin,
    required this.tempatTanggalLahir,
    required this.pekerjaan,
    required this.alamat,
    required this.riwayatAdopsi,
    required this.status,
    required this.tanggalPermohonan,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        hewanId: json["hewan_id"],
        permohonanId: json["permohonan_id"],
        namaLengkap: json["nama"],
        umur: json["umur"],
        noHp: json["no_hp"],
        email: json["email"],
        nik: json["nik"],
        jenisKelamin: json["jenis_kelamin"],
        tempatTanggalLahir: json["tempat_tanggal_lahir"],
        pekerjaan: json["pekerjaan"],
        alamat: json["alamat"],
        riwayatAdopsi: json["riwayat_adopsi"],
        status: json["status"],
        tanggalPermohonan: DateTime.parse(json["tanggal_permohonan"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "hewan_id": hewanId,
        "permohonan_id": permohonanId,
        "nama": namaLengkap,
        "umur": umur,
        "no_hp": noHp,
        "email": email,
        "nik": nik,
        "jenis_kelamin": jenisKelamin,
        "tempat_tanggal_lahir": tempatTanggalLahir,
        "pekerjaan": pekerjaan,
        "alamat": alamat,
        "riwayat_adopsi": riwayatAdopsi,
        "status": status,
        "tanggal_permohonan":
            "${tanggalPermohonan.year.toString().padLeft(4, '0')}-${tanggalPermohonan.month.toString().padLeft(2, '0')}-${tanggalPermohonan.day.toString().padLeft(2, '0')}",
      };
}
