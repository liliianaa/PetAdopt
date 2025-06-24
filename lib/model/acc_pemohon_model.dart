import 'dart:convert';

class Acclistpemohonmodel {
    final String? status;

    Acclistpemohonmodel({
        this.status,
    });

    factory Acclistpemohonmodel.fromJson(String str) => Acclistpemohonmodel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Acclistpemohonmodel.fromMap(Map<String, dynamic> json) => Acclistpemohonmodel(
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
    };
}