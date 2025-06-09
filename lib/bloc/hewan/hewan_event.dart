part of 'hewan_bloc.dart';

abstract class HewanEvent {}

class AddHewanEvent extends HewanEvent {
  final File imageFile;
  final String nama;
  final String jenisKelamin;
  final String warna;
  final String jenisHewan;
  final String umur;
  final String status;
  final String lokasi;
  final String deskripsi;

  AddHewanEvent({
    required this.imageFile,
    required this.nama,
    required this.jenisKelamin,
    required this.warna,
    required this.jenisHewan,
    required this.umur,
    required this.status,
    required this.lokasi,
    required this.deskripsi,
  });
}

class GetHewanEvent extends HewanEvent {
  GetHewanEvent();
}

class GetHewanByIdEvent extends HewanEvent {
  final int id;
  GetHewanByIdEvent({required this.id});
}

class GetHewanByJenisEvent extends HewanEvent {
  final String jenis; // nullable
  GetHewanByJenisEvent({required this.jenis});
}

class UpdateHewanEvent extends HewanEvent {
  final String id;
  final String nama;
  final String jenis_kelamin;
  final String warna;
  final String jenis_hewan;
  final String umur;
  final String status;
  final String deskripsi;
  final File? imageFile;

  UpdateHewanEvent({
    required this.id,
    required this.nama,
    required this.jenis_kelamin,
    required this.warna,
    required this.jenis_hewan,
    required this.umur,
    required this.status,
    required this.deskripsi,
    this.imageFile,
  });
}
