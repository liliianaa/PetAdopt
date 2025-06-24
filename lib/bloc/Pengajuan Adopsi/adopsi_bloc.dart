import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/providers/adopsi_provider.dart';

part 'adopsi_event.dart';
part 'adopsi_state.dart';

class AdopsiBloc extends Bloc<AdopsiEvent, AdopsiState> {
  final Adopsirepositories adopsiRepositories;

  AdopsiBloc(this.adopsiRepositories) : super(AdopsiInitial()) {
    on<SubmitPengajuanAdopsiEvent>((event, emit) async {
      emit(AdopsiLoading());

      final result = await adopsiRepositories.submitPengajuanAdopsi(
        hewanId: event.hewanId,
        nama: event.nama,
        umur: event.umur,
        noHp: event.noHp,
        email: event.email,
        nik: event.nik,
        jenisKelamin: event.jenisKelamin,
        tempatTanggalLahir: event.tempatTanggalLahir,
        pekerjaan: event.pekerjaan,
        alamat: event.alamat,
        riwayatAdopsi: event.riwayatAdopsi,
      );

      result.fold(
        (failureMessage) {
          emit(AdopsiError(message: failureMessage));
        },
        (successMessage) {
          emit(AdopsiSuccess(message: successMessage));
        },
      );
    });
  }
}
