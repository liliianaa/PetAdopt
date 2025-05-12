class Register {
  final String name;
  final String email;
  final String password;

  Register({
    required this.name,
    required this.email,
    required this.password,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );
}

class Login {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        email: json["email"],
        password: json["password"],
      );
}

class LoginResponse {
  final String message;
  final String token;

  LoginResponse({
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['data']['token'],
    );
  }
}
