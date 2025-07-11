// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class GetProfileDetailEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final DetailProfileModel profiledetailmodel;
  UpdateProfileEvent({
    required this.profiledetailmodel,
  });
}

class ProfilePassUpdate extends ProfileEvent {
  final String old_password;
  final String new_password;
  final String confrim_password;

  ProfilePassUpdate({
    required this.old_password,
    required this.new_password,
    required this.confrim_password,
  });
}
