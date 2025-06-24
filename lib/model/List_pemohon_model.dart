// To parse this JSON data, do
//
//     final historyPermohonan = historyPermohonanFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HistoryPermohonan historyPermohonanFromMap(String str) => HistoryPermohonan.fromMap(json.decode(str));

String historyPermohonanToMap(HistoryPermohonan data) => json.encode(data.toMap());

class HistoryPermohonan {
    final String message;
    final List<Listhistorymodel> data;

    HistoryPermohonan({
        required this.message,
        required this.data,
    });

    factory HistoryPermohonan.fromMap(Map<String, dynamic> json) => HistoryPermohonan(
        message: json["message"],
        data: List<Listhistorymodel>.from(json["data"].map((x) => Listhistorymodel.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Listhistorymodel {
    final int userId;
    final int hewanId;
    final int permohonanId;
    final String nama;
    final String image;

    Listhistorymodel({
        required this.userId,
        required this.hewanId,
        required this.permohonanId,
        required this.nama,
        required this.image,
    });

    factory Listhistorymodel.fromMap(Map<String, dynamic> json) => Listhistorymodel(
        userId: json["user_id"],
        hewanId: json["hewan_id"],
        permohonanId: json["permohonan_id"],
        nama: json["nama"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "hewan_id": hewanId,
        "permohonan_id": permohonanId,
        "nama": nama,
        "image": image,
    };
}
