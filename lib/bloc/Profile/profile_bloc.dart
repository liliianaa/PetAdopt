// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/model/DetailProfile_model.dart';

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
      try {
        final datadetailprofile =
            await repositories.ProfileUpdate(event.profiledetailmodel);
        emit(ProfiledetailSuccess(profiledetilmodel: datadetailprofile));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });
    on<ProfilePassUpdate>((event, emit) async {
      emit(ProfileLoading());
      final response = await repositories.Profilepassupdate(
          event.old_password, event.new_password, event.confrim_password);
      if (response['success']) {
        emit(ProfileSuccess(profiledata: response['data']));
      } else {
        emit(ProfileError(message: response['message']));
      }
    });
  }
}
