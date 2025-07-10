import 'dart:convert';

class DashboardAdminModel {
  final String? message;
  final Data? data;

  DashboardAdminModel({
    this.message,
    this.data,
  });

  factory DashboardAdminModel.fromJson(String str) =>
      DashboardAdminModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardAdminModel.fromMap(Map<String, dynamic> json) =>
      DashboardAdminModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final int? totalUsers;
  final int? totalHewan;
  final int? user;
  final int? shelter;
  final int? admin;
  final int? kucing;
  final int? anjing;

  Data({
    this.totalUsers,
    this.totalHewan,
    this.user,
    this.shelter,
    this.admin,
    this.kucing,
    this.anjing,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        totalUsers: json["total_users"],
        totalHewan: json["total_hewan"],
        user: json["user"],
        shelter: json["shelter"],
        admin: json["admin"],
        kucing: json["kucing"],
        anjing: json["anjing"],
      );

  Map<String, dynamic> toMap() => {
        "total_users": totalUsers,
        "total_hewan": totalHewan,
        "user": user,
        "shelter": shelter,
        "admin": admin,
        "kucing": kucing,
        "anjing": anjing,
      };
}
