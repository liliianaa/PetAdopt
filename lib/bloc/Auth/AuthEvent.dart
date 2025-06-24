abstract class Authevent {}

//pengguna menekan tombol register
class AuthregisterRequest extends Authevent {
  final String name;
  final String email;
  final String password;

  AuthregisterRequest(this.name, this.email, this.password);
}

//pengguna menekan tombol login
class AuthLoginRequest extends Authevent {
  final String email;
  final String password;

  AuthLoginRequest(this.email, this.password);
}

// mengecek status pengguna
class AuthCheckStatus extends Authevent {}

// pengguna menekan tombol logout
class AuthLogoutRequest extends Authevent {}
