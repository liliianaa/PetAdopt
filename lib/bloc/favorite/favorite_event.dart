// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class PostFavoriteEvent extends FavoriteEvent {
  final int hewanId;
  PostFavoriteEvent({required this.hewanId});
}

class GetFavoriteEvent extends FavoriteEvent {}
