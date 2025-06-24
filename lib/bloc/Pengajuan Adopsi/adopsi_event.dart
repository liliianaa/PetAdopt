part of 'adopsi_bloc.dart';

abstract class AdopsiEvent {}

class SubmitPengajuanAdopsiEvent extends AdopsiEvent {
  final int hewanId;
  final String nama;
  final String umur;
  final String noHp;
  final String email;
  final String nik;
  final String jenisKelamin;
  final String tempatTanggalLahir;
  final String pekerjaan;
  final String alamat;
  final String? riwayatAdopsi;

  SubmitPengajuanAdopsiEvent({
    required this.hewanId,
    required this.nama,
    required this.umur,
    required this.noHp,
    required this.email,
    required this.nik,
    required this.jenisKelamin,
    required this.tempatTanggalLahir,
    required this.pekerjaan,
    required this.alamat,
    this.riwayatAdopsi,
  });
}
