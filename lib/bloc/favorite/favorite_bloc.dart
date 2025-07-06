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
    on<PostFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final likedpost = await favoriteRepository.postLikes(event.hewanId);
        emit(FavoriteSuccess(
          postLiked: likedpost,
          hewanId: event.hewanId,
        ));
      } catch (e) {
        emit(FavoriteError(message: e.toString()));
      }
    });

    on<GetFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final likedData = await favoriteRepository.getLikes();
        final likedIds =
            likedData.map((item) => item.id!).toSet(); // Pastikan id ada
        emit(
            GetFavoriteSuccess(getLikedList: likedData, favoriteIds: likedIds));
      } catch (e) {
        emit(FavoriteError(message: e.toString()));
      }
    });
  }
}
