part of 'favorite_bloc.dart';

abstract class FavoriteState {
  const FavoriteState();
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {
  final PostLiked postLiked;
  final int hewanId;

  FavoriteSuccess({required this.postLiked, required this.hewanId});
}

final class GetFavoriteSuccess extends FavoriteState {
  final List<Datum> getLikedList;
  final Set<int> favoriteIds;

  GetFavoriteSuccess({
    required this.getLikedList,
    required this.favoriteIds,
  });
}

final class FavoriteError extends FavoriteState {
  final String? message;

  FavoriteError({required this.message});
}
