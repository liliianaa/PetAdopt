import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petadopt/models/auth_model.dart';
import 'package:petadopt/services/petadopt_services.dart';

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

  AuthState get state => _state;
  String get message => _message;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(Login loginData) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final result = await authServices.loginUser(loginData);
      if (result != null) {
        _state = AuthState.success;
        _isAuthenticated = true;
      } else {
        _state = AuthState.failed;
        _message = 'Login failed';
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
    } catch (e) {
      _state = AuthState.failed;
      if (e is SocketException) {
        _message = 'No Internet Connection';
      } else {
        _message = 'Registration Error';
      }
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _state = AuthState.idle;
    notifyListeners();
  }
}
