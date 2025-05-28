abstract class Profilestate {}

class Profileinitial extends Profilestate {}

class Profileloading extends Profilestate {}

class ProfileLoaded extends Profilestate {
  final Map<String, dynamic> profiledata;

  ProfileLoaded(this.profiledata);
}

class Profileerror extends Profilestate {
  final String message;

  Profileerror(this.message);
}
