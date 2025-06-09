part of 'hewan_bloc.dart';

abstract class HewanState {}

class HewanInitial extends HewanState {}

class HewanLoading extends HewanState {}

final class HewanSuccess extends HewanState {
  final List<Datum> hewandata;

  HewanSuccess({required this.hewandata});
}

final class HewanError extends HewanState {
  final String message;

  HewanError({required this.message});
}
