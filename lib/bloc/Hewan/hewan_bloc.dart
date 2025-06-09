import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/models/pet_model.dart';
import 'package:petadopt/providers/pets_provider.dart';

part 'hewan_event.dart';
part 'hewan_state.dart';

class HewanBloc extends Bloc<HewanEvent, HewanState> {
  final petsrepository hewanrespository;
  HewanBloc(this.hewanrespository) : super(hewaninitial()) {
    on<getpetsuploaded>((event, emit) async {
      emit(hewanloading());
      try {
        final data = await hewanrespository.getHewanuploaded();
        if (data['success']) {
          final List<Datum> hewanList = data['data'];
          emit(hewansuccess(hewan: hewanList));
        } else {
          emit(hewanerror(message: data['message']));
        }
      } catch (e) {
        emit(hewanerror(message: 'terjadi kesalahan'));
      }
    });
  }
}
