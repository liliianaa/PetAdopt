import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Authrepostories authrepostories = Authrepostories();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          Authbloc(authrepostories: authrepostories)..add(AuthCheckStatus()),
      child: MaterialApp(
        home: BlocBuilder<Authbloc, Authstate>(
          builder: (context, state) {
            if (state is AuthLoading || state is Authinitial) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (state is Authautenticated) {
              return MainPage();
            } else {
              return LandingPage();
            }
          },
        ),
      ),
    );
  }
}
