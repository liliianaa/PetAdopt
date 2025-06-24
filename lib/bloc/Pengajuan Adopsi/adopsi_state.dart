part of 'adopsi_bloc.dart';

abstract class AdopsiState {}

class AdopsiInitial extends AdopsiState {}

class AdopsiLoading extends AdopsiState {}

class AdopsiSuccess extends AdopsiState {
  final String message;

  AdopsiSuccess({required this.message});
}

class AdopsiError extends AdopsiState {
  final String message;

  AdopsiError({required this.message});
}
