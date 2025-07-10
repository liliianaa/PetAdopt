import 'package:bloc/bloc.dart';
import 'package:petadopt/model/List_shelter_admin.dart';
import 'package:petadopt/model/acc_pemohon_model.dart';
import 'package:petadopt/model/dashboard_admin_model.dart';
import 'package:petadopt/providers/admin_provider.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final Adminrepository adminrepository;
  AdminBloc(this.adminrepository) : super(AdminInitial()) {
    on<Getpermohonanshelter>((event, emit) async {
      emit(AdminLoading());
      try {
        final permohonan = await adminrepository.getpermohonanshelter();
        emit(AdminSuccess(dataadmin: permohonan));
      } catch (e) {
        emit(Adminerror(message: e.toString()));
      }
    });
    on<Updatestatusshelter>((event, emit) async {
      emit(AdminLoading());
      try {
        final permohonan = await adminrepository.updateStatuspermohonanshelter(
            event.permohonan, event.permohonmodel);
        emit(updatestatuspermohonansuccess(permohonanmodel: permohonan));
      } catch (e) {
        emit(Adminerror(message: e.toString()));
      }
    });
    on<getjumlahuser>((event, emit) async {
      try {
        final userData = await adminrepository.getjumlahuser();

        // Ambil state sebelumnya (kalau sudah ada jumlahHewan)
        final current = state is dashboardAdminsuccess
            ? (state as dashboardAdminsuccess)
            : null;

        emit(dashboardAdminsuccess(
          jumlahUser: userData,
          jumlahHewan: current?.jumlahHewan,
        ));
      } catch (e) {
        emit(Adminerror(message: e.toString()));
      }
    });

    on<getjumlahhewan>((event, emit) async {
      try {
        final hewanData = await adminrepository.getjumlahhewan();

        final current = state is dashboardAdminsuccess
            ? (state as dashboardAdminsuccess)
            : null;

        emit(dashboardAdminsuccess(
          jumlahUser: current?.jumlahUser,
          jumlahHewan: hewanData,
        ));
      } catch (e) {
        emit(Adminerror(message: e.toString()));
      }
    });
  }
}
