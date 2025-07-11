import 'dart:convert';

class DetailProfileModel {
    final String? name;
    final DateTime? tanggalLahir;
    final String? jenisKelamin;
    final String? noTelp;
    final String? email;

    DetailProfileModel({
        this.name,
        this.tanggalLahir,
        this.jenisKelamin,
        this.noTelp,
        this.email,
    });

    factory DetailProfileModel.fromJson(String str) => DetailProfileModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DetailProfileModel.fromMap(Map<String, dynamic> json) => DetailProfileModel(
        name: json["name"],
        tanggalLahir: json["tgl_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        noTelp: json["no_telp"],
        email: json["email"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "tgl_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "jenis_kelamin": jenisKelamin,
        "no_telp": noTelp,
        "email": email,
    };
}