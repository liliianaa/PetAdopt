import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/models/auth_model.dart';

class AuthServices {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  Future<String?> registerUser(Register data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return "success";
    } else {
      return null;
    }
  }

  Future<LoginResponse?> loginUser(Login loginData) async {
    print('loginUser called with: ${loginData.email}, ${loginData.password}');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData.toJson()),
      );

      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      try {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return LoginResponse.fromJson(data);
        } else {
          // Ambil error dari JSON response
          String errorMessage = 'Login gagal';
          Map<String, dynamic>? errors;

          if (data['errors'] != null) {
            errors = Map<String, dynamic>.from(data['errors']);
            final emailErrors = data['errors']['email'];
            if (emailErrors is List && emailErrors.isNotEmpty) {
              errorMessage = emailErrors[0];
            }
          } else if (data['message'] != null) {
            errorMessage = data['message'];
          }

          return LoginResponse(
            token: '',
            message: errorMessage,
            errors: errors,
          );
        }
      } catch (_) {
        // JSON tidak bisa di-decode
        return LoginResponse(
          token: '',
          message: 'Login gagal: format respons tidak dikenali.',
        );
      }
    } catch (e) {
      print('[AuthService] Exception during login: $e');
      return LoginResponse(
        token: '',
        message: 'Login gagal: ${e.toString()}',
      );
    }
  }

  String _extractErrorMessage(Map<String, dynamic> data) {
    if (data['errors'] != null && data['errors'] is Map) {
      final errors = data['errors'] as Map<String, dynamic>;
      final firstErrorKey = errors.keys.first;
      final messages = errors[firstErrorKey];
      if (messages is List && messages.isNotEmpty) {
        return messages[0];
      }
    }
    return data['message'] ?? 'Login failed';
  }
}
