part of 'favorite_bloc.dart';

abstract class FavoriteState {
  const FavoriteState();
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {
  final PostLiked Postliked;

  FavoriteSuccess({required this.Postliked});
}

final class getFavoriteSuccess extends FavoriteState {
  final Datum getliked;

  getFavoriteSuccess({required this.getliked});
}

final class FavoriteError extends FavoriteState {
  final String? message;

  FavoriteError({required this.message});
}
