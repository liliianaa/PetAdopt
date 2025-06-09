part of 'artikel_bloc.dart';


abstract class ArtikelState {}

class ArtikelInitial extends ArtikelState {}

class ArtikelLoading extends ArtikelState {}

final class ArtikelSuccess extends ArtikelState {
  final dynamic Artikeldata;

  ArtikelSuccess({required this.Artikeldata});
}

final class ArtikelError extends ArtikelState {
  final String? message;

  ArtikelError({required this.message});
}
