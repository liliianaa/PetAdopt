import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/providers/pengajuanshelter_provider.dart';
import 'shelter_event.dart';
import 'shelter_state.dart';

class ShelterBloc extends Bloc<ShelterEvent, ShelterState> {
  final PermohonanAdopsiRepository shelterrepository;

  ShelterBloc(this.shelterrepository) : super(ShelterInitial()) {
    on<UploadShelterRequestEvent>(_onUploadShelter);
  }

  Future<void> _onUploadShelter(
    UploadShelterRequestEvent event,
    Emitter<ShelterState> emit,
  ) async {
    emit(ShelterLoading());

    final result = await shelterrepository.uploadPermohonanAdopsi(event.file);

    result.fold(
      (failure) => emit(ShelterFailure(failure)),
      (response) => emit(ShelterSuccess(response)),
    );
  }
}
