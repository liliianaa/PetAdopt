import 'dart:convert';

class PostLiked {
  final String? message;
  final bool? liked;

  PostLiked({
    this.message,
    this.liked,
  });

  factory PostLiked.fromJson(String str) => PostLiked.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostLiked.fromMap(Map<String, dynamic> json) => PostLiked(
        message: json["message"],
        liked: json["liked"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "liked": liked,
      };
}

class GetLiked {
  final String? message;
  final List<Datum>? data;

  GetLiked({
    this.message,
    this.data,
  });

  factory GetLiked.fromJson(String str) => GetLiked.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetLiked.fromMap(Map<String, dynamic> json) => GetLiked(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  final String? image;
  final String? nama;
  final Status? status;
  final int? likesCount;

  Datum({
    this.image,
    this.nama,
    this.status,
    this.likesCount,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        image: json["image"],
        nama: json["nama"],
        status: statusValues.map[json["status"]]!,
        likesCount: json["likes_count"],
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "nama": nama,
        "status": statusValues.reverse[status],
        "likes_count": likesCount,
      };
}

enum Status { TERSEDIA }

final statusValues = EnumValues({"tersedia": Status.TERSEDIA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
