import 'package:equatable/equatable.dart';
import 'package:petadopt/model/PengajuanShelter_model.dart.dart';

abstract class ShelterState extends Equatable {
  const ShelterState();

  @override
  List<Object?> get props => [];
}

class ShelterInitial extends ShelterState {}

class ShelterLoading extends ShelterState {}

class ShelterSuccess extends ShelterState {
  final PengajuanShelter response;

  const ShelterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ShelterFailure extends ShelterState {
  final String error;

  const ShelterFailure(this.error);

  @override
  List<Object?> get props => [error];
}
