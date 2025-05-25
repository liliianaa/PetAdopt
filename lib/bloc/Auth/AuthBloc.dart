import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/providers/auth_provider.dart';

class Authbloc extends Bloc<Authevent, Authstate> {
  final Authrepostories authrepostories;

  Authbloc({required this.authrepostories}) : super(Authinitial()) {
    on<AuthLoginRequest>(_onLoginRequested);
    on<AuthregisterRequest>(_onRegisterRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLogoutRequest>(_onLogoutRequested);
  }

  void _onLoginRequested(
      AuthLoginRequest event, Emitter<Authstate> emit) async {
    emit(AuthLoading());
    final response = await authrepostories.Login(event.email, event.password);
    print('Login response: $response');
    if (response['success']) {
      emit(Authautenticated());
    } else {
      emit(Authunautenticated(message: response['message']));
      print(response);
    }
  }

  void _onRegisterRequested(
      AuthregisterRequest event, Emitter<Authstate> emit) async {
    final Response =
        await authrepostories.Register(event.name, event.email, event.password);
    if (Response['success']) {
      emit(Authautenticated());
    } else {
      emit(Authunautenticated(message: Response['message']));
    }
  }

  void _onCheckStatus(AuthCheckStatus event, Emitter<Authstate> emit) async {
    final isLoggedIn = await authrepostories.isLoggedIn();
    if (isLoggedIn) {
      emit(Authautenticated());
    } else {
      emit(Authunautenticated());
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequest event, Emitter<Authstate> emit) async {
    await authrepostories.logout();
    emit(Authunautenticated());
  }
}
