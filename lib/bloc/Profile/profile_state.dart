part of 'profile_bloc.dart';

abstract class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final dynamic profiledata;

  ProfileSuccess({required this.profiledata});
}

final class ProfileError extends ProfileState {
  final String? message;

  ProfileError({required this.message});
}
