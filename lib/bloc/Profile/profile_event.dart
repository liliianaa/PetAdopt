part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class GetProfileDetailEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String tgl_lahir;
  final String jenis_kelamin;
  final String no_telp;
  final String email;

  UpdateProfileEvent(
      {required this.name,
      required this.tgl_lahir,
      required this.jenis_kelamin,
      required this.no_telp,
      required this.email});
}
