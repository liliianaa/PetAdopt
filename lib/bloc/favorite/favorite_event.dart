// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class postFavoriteEvent extends FavoriteEvent {
  final int hewanId;
  final PostLiked postlike;
  postFavoriteEvent({
    required this.hewanId,
    required this.postlike,
  });
}

class getfavoriteEvent extends FavoriteEvent {
  final Datum getlike;
  getfavoriteEvent({
    required this.getlike,
  });
}
