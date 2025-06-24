class LikeResponse {
  final String message;
  final bool liked;

  LikeResponse({
    required this.message,
    required this.liked,
  });

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeResponse(
      message: json['message'] ?? '',
      liked: json['liked'] ?? false,
    );
  }
}

class FavoriteHewanResponse {
  final String message;
  final List<FavoriteHewanData> data;

  FavoriteHewanResponse({required this.message, required this.data});

  factory FavoriteHewanResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteHewanResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => FavoriteHewanData.fromJson(e))
          .toList(),
    );
  }
}

class FavoriteHewanData {
  final int id;        // id record favorit
  final int hewanId;   // id hewan yang di-like
  final String image;
  final String nama;
  final String status;
  final int likesCount;

  FavoriteHewanData({
    required this.id,
    required this.hewanId,
    required this.image,
    required this.nama,
    required this.status,
    required this.likesCount,
  });

  factory FavoriteHewanData.fromJson(Map<String, dynamic> json) {
    return FavoriteHewanData(
      id: json['id'] ?? 0,            // id tabel favorit
      hewanId: json['hewan_id'] ?? 0, // ini ambil dari kolom hewan_id
      image: json['image'] ?? '',
      nama: json['nama'] ?? '',
      status: json['status'] ?? '',
      likesCount: json['likes_count'] ?? 0,
    );
  }
}




