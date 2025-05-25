//menggambarkan status authentifikasi saaat ini
abstract class Authstate {}

//waktu awal buka aplikasi
class Authinitial extends Authstate {}

//sedang memproses login/daftar
class AuthLoading extends Authstate {}

//sudah login sukses
class Authautenticated extends Authstate {}

//belum login
class Authunautenticated extends Authstate {
  final String? message;
  Authunautenticated({this.message});
}
