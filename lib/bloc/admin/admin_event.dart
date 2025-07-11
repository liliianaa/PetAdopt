// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_bloc.dart';

abstract class AdminEvent {}

class Getpermohonanshelter extends AdminEvent {
  Getpermohonanshelter();
}

class Updatestatusshelter extends AdminEvent {
  int permohonan;
  Acclistpemohonmodel permohonmodel;
  Updatestatusshelter({
    required this.permohonan,
    required this.permohonmodel,
  });
}

class getjumlahuser extends AdminEvent {
  getjumlahuser();
}
class getjumlahhewan extends AdminEvent {
  getjumlahhewan();
}
class getNotifikasi extends AdminEvent{
  getNotifikasi();
}
