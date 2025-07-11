import 'dart:convert';

class NotifikasiModel {
    final String? message;
    final List<NotifikasiMod>? data;

    NotifikasiModel({
        this.message,
        this.data,
    });

    factory NotifikasiModel.fromJson(String str) => NotifikasiModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NotifikasiModel.fromMap(Map<String, dynamic> json) => NotifikasiModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<NotifikasiMod>.from(json["data"]!.map((x) => NotifikasiMod.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class NotifikasiMod {
    final int? id;
    final int? userId;
    final String? judul;
    final String? pesan;
    final String? status;
    final DateTime? sendAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    NotifikasiMod({
        this.id,
        this.userId,
        this.judul,
        this.pesan,
        this.status,
        this.sendAt,
        this.createdAt,
        this.updatedAt,
    });

    factory NotifikasiMod.fromJson(String str) => NotifikasiMod.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NotifikasiMod.fromMap(Map<String, dynamic> json) => NotifikasiMod(
        id: json["id"],
        userId: json["user_id"],
        judul: json["judul"],
        pesan: json["pesan"],
        status: json["status"],
        sendAt: json["send_at"] == null ? null : DateTime.parse(json["send_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "judul": judul,
        "pesan": pesan,
        "status": status,
        "send_at": sendAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
