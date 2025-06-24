// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:petadopt/model/Like_response.dart';
import 'package:petadopt/providers/like_provider.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  FavoriteBloc(
    this.favoriteRepository,
  ) : super(FavoriteInitial()) {
    on<postFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final likedpost =
            await favoriteRepository.postLikes(event.hewanId, event.postlike);
        emit(FavoriteSuccess(Postliked: likedpost));
      } catch (e) {
        emit(FavoriteError(message: e.toString()));
      }
    });
    on<getfavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final likedget = await favoriteRepository.getlikes(event.getlike);
        emit(getFavoriteSuccess(getliked: likedget));
      } catch (e) {
        emit(FavoriteError(message: e.toString()));
      }
    });
  }
}
