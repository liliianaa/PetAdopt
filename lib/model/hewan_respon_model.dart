import 'dart:convert';

class Hewan {
    final String? message;
    final List<Datum>? data;

    Hewan({
        this.message,
        this.data,
    });

    factory Hewan.fromRawJson(String str) => Hewan.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Hewan.fromJson(Map<String, dynamic> json) => Hewan(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? id;
    final int? userId;
    final String? image;
    final String? nama;
    final String? jenisKelamin;
    final String? warna;
    final String? jenisHewan;
    final int? umur;
    final String? status;
    final String? lokasi;
    final String? deskripsi;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;

    Datum({
        this.id,
        this.userId,
        this.image,
        this.nama,
        this.jenisKelamin,
        this.warna,
        this.jenisHewan,
        this.umur,
        this.status,
        this.lokasi,
        this.deskripsi,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}

class User {
    final int? id;
    final dynamic profilePhoto;
    final String? name;
    final String? email;
    final String? role;
    final dynamic noTelp;
    final dynamic tglLahir;
    final dynamic jenisKelamin;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    User({
        this.id,
        this.profilePhoto,
        this.name,
        this.email,
        this.role,
        this.noTelp,
        this.tglLahir,
        this.jenisKelamin,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profilePhoto: json["profile_photo"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        noTelp: json["no_telp"],
        tglLahir: json["tgl_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
