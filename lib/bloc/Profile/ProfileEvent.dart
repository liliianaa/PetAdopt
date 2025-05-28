abstract class Profileevent {}

class fetchProfile extends Profileevent {}

class fetchProfiledetail extends Profileevent {}

class fetchProfileupdate extends Profileevent {
  final String name;
  final String tgl_lahir;
  final String jenis_kelamin;
  final String no_telp;
  final String email;

  fetchProfileupdate(
      this.name, this.tgl_lahir, this.jenis_kelamin, this.no_telp, this.email);
}
