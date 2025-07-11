part of 'admin_bloc.dart';

abstract class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminLoading extends AdminState {}

final class AdminSuccess extends AdminState {
  final List<Datum> dataadmin;

  AdminSuccess({required this.dataadmin});
}

final class updatestatuspermohonansuccess extends AdminState {
  final Acclistpemohonmodel permohonanmodel;

  updatestatuspermohonansuccess({required this.permohonanmodel});
}

class dashboardAdminsuccess extends AdminState {
  final DashboardAdminModel? jumlahUser;
  final DashboardAdminModel? jumlahHewan;

  dashboardAdminsuccess({
    this.jumlahUser,
    this.jumlahHewan,
  });

  dashboardAdminsuccess copyWith({
    DashboardAdminModel? jumlahUser,
    DashboardAdminModel? jumlahHewan,
  }) {
    return dashboardAdminsuccess(
      jumlahUser: jumlahUser ?? this.jumlahUser,
      jumlahHewan: jumlahHewan ?? this.jumlahHewan,
    );
  }
}

final class getnotifikasiSuccess extends AdminState {
  final List<NotifikasiMod> datanotifikasi;
  getnotifikasiSuccess({required this.datanotifikasi});
}

final class Adminerror extends AdminState {
  final String? message;

  Adminerror({required this.message});
}
