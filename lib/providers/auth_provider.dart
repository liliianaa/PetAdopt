import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petadopt/models/auth_model.dart';
import 'package:petadopt/services/auth_services.dart';

enum AuthState {
  idle,
  loading,
  success,
  failed,
}

class AuthProvider extends ChangeNotifier {
  final AuthServices authServices;

  AuthProvider({required this.authServices});

  AuthState _state = AuthState.idle;
  String _message = '';
  bool _isAuthenticated = false;
  String _token = ''; // <- tambahkan ini

  AuthState get state => _state;
  String get message => _message;
  bool get isAuthenticated => _isAuthenticated;
  String get token => _token; // <- getter token

  Future<void> login(Login loginData) async {
  try {
    _state = AuthState.loading;
    notifyListeners();

    final result = await authServices.loginUser(loginData);

    print('[AuthProvider] login result: token=${result?.token}, message=${result?.message}');

    if (result != null && result.token.isNotEmpty) {
      _state = AuthState.success;
      _isAuthenticated = true;
      _message = result.message ?? 'Login berhasil';
      _token = result.token;
    } else if (result != null && result.errors != null) {
      _state = AuthState.failed;
      final emailErrors = result.errors?["email"];
      if (emailErrors != null && emailErrors.isNotEmpty) {
        _message = emailErrors[0];
      } else {
        _message = result.message ?? 'Login failed';
      }
    } else {
      _state = AuthState.failed;
      _message = result?.message ?? 'Login failed';
    }
  } catch (e) {
    _state = AuthState.failed;
    if (e is SocketException) {
      _message = 'No Internet Connection';
    } else {
      _message = 'Login Error';
    }
  } finally {
    notifyListeners();
  }
}

  // Metode register tetap sama sesuai kebutuhan
  Future<void> register(Register registerData) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final result = await authServices.registerUser(registerData);
      if (result != null) {
        _state = AuthState.success;
      } else {
        _state = AuthState.failed;
        _message = 'Registration failed';
      }
    } on SocketException {
      _state = AuthState.failed;
      _message = 'No Internet Connection';
    } catch (e) {
      _state = AuthState.failed;
      _message = 'Registration Error: $e';
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _state = AuthState.idle;
    _message = '';
    notifyListeners();
  }
}
