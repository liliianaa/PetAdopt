import 'dart:convert';

class Sheltermodel {
    final String? message;
    final List<Modelshelterlist>? data;

    Sheltermodel({
        this.message,
        this.data,
    });

    factory Sheltermodel.fromJson(String str) => Sheltermodel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Sheltermodel.fromMap(Map<String, dynamic> json) => Sheltermodel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Modelshelterlist>.from(json["data"]!.map((x) => Modelshelterlist.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Modelshelterlist {
    final int? id;
    final int? userId;
    final String? file;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;

    Modelshelterlist({
        this.id,
        this.userId,
        this.file,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    factory Modelshelterlist.fromJson(String str) => Modelshelterlist.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Modelshelterlist.fromMap(Map<String, dynamic> json) => Modelshelterlist(
        id: json["id"],
        userId: json["user_id"],
        file: json["file"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "file": file,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toMap(),
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

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
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

    Map<String, dynamic> toMap() => {
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
