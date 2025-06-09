import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'artikel_event.dart';
part 'artikel_state.dart';

class ArtikelBloc extends Bloc<ArtikelEvent, ArtikelState> {
  ArtikelBloc() : super(ArtikelInitial()) {
    on<ArtikelEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
