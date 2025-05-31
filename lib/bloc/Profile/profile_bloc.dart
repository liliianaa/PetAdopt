// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:petadopt/providers/profile_provider.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Profilerepositories repositories;
  ProfileBloc(
    this.repositories,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final response = await repositories.getProfil();
      if (response['success']) {
        emit(ProfileSuccess(profiledata: response['data']));
      } else {
        emit(ProfileError(message: response['message']));
      }
    });
    on<GetProfileDetailEvent>((event, emit) async {
      emit(ProfileLoading());
      final response = await repositories.getProfileDetail();
      if (response['success']) {
        emit(ProfileSuccess(profiledata: response['data']));
      } else {
        emit(ProfileError(message: response['message']));
      }
    });
    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final response = await repositories.ProfileUpdate(event.name,
          event.tgl_lahir, event.jenis_kelamin, event.no_telp, event.email);
      if (response['success'] && response['data'] != null) {
        emit(ProfileSuccess(profiledata: response['data']));
      } else {
        emit(ProfileError(message: response['message']));
      }
    });
  }
}
