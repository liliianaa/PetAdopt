import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/providers/auth_provider.dart';
import 'package:petadopt/providers/profile_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Authrepostories authrepostories = Authrepostories();
  final Profilerepositories repositories = Profilerepositories();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<Authbloc>(
          create: (_) => Authbloc(authrepostories: authrepostories)
            ..add(AuthCheckStatus()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(repositories)
        ),
        // BlocProvider<Profiledetailbloc>(
        //   create: (_) => Profiledetailbloc(profilrepo: profilrepositories)
        //     ..add(fetchProfiledetail()), // bisa juga ..add(fetchProfile())
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<Authbloc, Authstate>(
          builder: (context, state) {
            if (state is AuthLoading || state is Authinitial) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else if (state is Authautenticated) {
              return const MainPage();
            } else {
              return const LandingPage();
            }
          },
        ),
      ),
    );
  }
}
