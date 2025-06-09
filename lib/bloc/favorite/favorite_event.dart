part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class GetFavoriteEvent extends FavoriteEvent {
  final int? id; // atau String, sesuaikan dengan tipe di repository
  GetFavoriteEvent({required this.id});
}
