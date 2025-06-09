// To parse this JSON data, do
//
//     final hewanmodel = hewanmodelFromJson(jsonString);

import 'dart:convert';

Hewanmodel hewanmodelFromJson(String str) =>
    Hewanmodel.fromJson(json.decode(str));

String hewanmodelToJson(Hewanmodel data) => json.encode(data.toJson());

class Hewanmodel {
  String message;
  List<Datum> data;

  Hewanmodel({
    required this.message,
    required this.data,
  });

  factory Hewanmodel.fromJson(Map<String, dynamic> json) => Hewanmodel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int userId;
  String image;
  String nama;
  String jenisKelamin;
  String warna;
  String jenisHewan;
  int umur;
  String status;
  dynamic lokasi;
  String deskripsi;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Datum({
    required this.id,
    required this.userId,
    required this.image,
    required this.nama,
    required this.jenisKelamin,
    required this.warna,
    required this.jenisHewan,
    required this.umur,
    required this.status,
    required this.lokasi,
    required this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        image: json["image"],
        nama: json["nama"],
        jenisKelamin: json["jenis_kelamin"],
        warna: json["warna"],
        jenisHewan: json["jenis_hewan"],
        umur: json["umur"],
        status: json["status"],
        lokasi: json["lokasi"],
        deskripsi: json["deskripsi"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "image": image,
        "nama": nama,
        "jenis_kelamin": jenisKelamin,
        "warna": warna,
        "jenis_hewan": jenisHewan,
        "umur": umur,
        "status": status,
        "lokasi": lokasi,
        "deskripsi": deskripsi,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  int id;
  dynamic profilePhoto;
  String name;
  String email;
  String role;
  dynamic noTelp;
  dynamic tglLahir;
  dynamic jenisKelamin;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.profilePhoto,
    required this.name,
    required this.email,
    required this.role,
    required this.noTelp,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profilePhoto: json["profile_photo"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        noTelp: json["no_telp"],
        tglLahir: json["tgl_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_photo": profilePhoto,
        "name": name,
        "email": email,
        "role": role,
        "no_telp": noTelp,
        "tgl_lahir": tglLahir,
        "jenis_kelamin": jenisKelamin,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
