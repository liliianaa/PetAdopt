// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hewan_bloc.dart';

abstract class HewanState {}

class hewaninitial extends HewanState {}

class hewanloading extends HewanState {}

class hewansuccess extends HewanState {
  final List<Datum> hewan;
  hewansuccess({
    required this.hewan,
  });
}

class hewanerror extends HewanState {
  final String message;
  hewanerror({
    required this.message,
  });
}
