class Register {
  final String name;
  final String email;
  final String password;

  Register({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

class Login {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String message;
  final Map<String, dynamic>? errors;

  LoginResponse({
    required this.token,
    required this.message,
    this.errors,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['data']?['token'] ?? '',  // <-- fix di sini
      message: json['message'] ?? '',
      errors: json['errors'],
    );
  }
}

class AuthModel {
  final String token;
  final String message;

  AuthModel({
    required this.token,
    required this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      message: json['message'],
    );
  }
}

class AuthResponse {
  final String message;

  AuthResponse({required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(message: json['message']);
  }
}
