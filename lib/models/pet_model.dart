class Hewan {
  final int id;
  final int userId;
  final String nama;
  final String jenis;
  final int usia;
  final String status;
  final String? deskripsi;

  Hewan({
    required this.id,
    required this.userId,
    required this.nama,
    required this.jenis,
    required this.usia,
    required this.status,
    this.deskripsi,
  });
}
