// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class GetMyPets extends HewanEvent {
  GetMyPets();
}

class GetPemohonHewanbyID extends HewanEvent {
  final int id;
  GetPemohonHewanbyID({
    required this.id,
  });
}

class getDetailPemohon extends HewanEvent {
  final int id;
  final int userId;
  getDetailPemohon({
    required this.id,
    required this.userId,
  });
}

class updatestatusPemohon extends HewanEvent {
  final int pemohonId;
  final Acclistpemohonmodel accpemohon;
  updatestatusPemohon({
    required this.pemohonId,
    required this.accpemohon,
  });
}

class getHistoryPermohonan extends HewanEvent {
  getHistoryPermohonan();
}

class getDetailhistorypemohon extends HewanEvent {
  final int pemohonID;

  getDetailhistorypemohon({required this.pemohonID});
}

class deletepermohonan extends HewanEvent {
  final int permohonanID;
  deletepermohonan({
    required this.permohonanID,
  });
}

class EditDataPemohon extends HewanEvent {
  final int permohonanID;
  final Data datapermohonan;
  EditDataPemohon({
    required this.permohonanID,
    required this.datapermohonan,
  });
}
