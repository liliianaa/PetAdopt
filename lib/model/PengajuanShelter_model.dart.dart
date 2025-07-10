import 'dart:convert';

class PengajuanShelter {
    final String? message;

    PengajuanShelter({
        this.message,
    });

    factory PengajuanShelter.fromRawJson(String str) => PengajuanShelter.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PengajuanShelter.fromJson(Map<String, dynamic> json) => PengajuanShelter(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
