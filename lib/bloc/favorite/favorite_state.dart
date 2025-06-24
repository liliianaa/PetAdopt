part of 'favorite_bloc.dart';

abstract class FavoriteState {
  const FavoriteState();
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {
  final dynamic favoritedata;

  FavoriteSuccess({required this.favoritedata});
}

final class FavoriteError extends FavoriteState {
  final String? message;

  FavoriteError({required this.message});
}