import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Profile/ProfileEvent.dart';
import 'package:petadopt/bloc/Profile/ProfileState.dart';
import 'package:petadopt/providers/profile_provider.dart';

class Profilebloc extends Bloc<Profileevent, Profilestate> {
  final Profilerepositories profilerepo;

  Profilebloc({required this.profilerepo}) : super(Profileinitial()) {
    on<fetchProfile>((event, emit) async {
      emit(Profileloading());

      final response = await profilerepo.getProfil();
      if (response['success']) {
        emit(ProfileLoaded(response['data']));
      } else {
        emit(Profileerror(response['message']));
      }
    });
    on<fetchProfiledetail>((event, emit) async {
      emit(Profileloading());

      final response = await profilerepo.getProfileDetail();
      if (response['success']) {
        emit(ProfileLoaded(response['data']));
      } else {
        emit(Profileerror(response['message']));
      }
    });
    on<fetchProfileupdate>((fetchProfileupdate event, emit) async {
      emit(Profileloading());

      final response = await profilerepo.ProfileUpdate(event.name,
          event.tgl_lahir, event.jenis_kelamin, event.no_telp, event.email);
      if (response['success']) {
        emit(ProfileLoaded(response['data']));
      } else {
        emit(Profileerror(response['message']));
      }
    });
  }
}
