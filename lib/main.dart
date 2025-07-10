import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/bloc/admin/admin_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/pages/AdminPage/AdminDashboardPage.dart';
import 'package:petadopt/pages/AdminPage/NavbarAdmin.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/pages/MenuPage/AddHewanPage.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';
import 'package:petadopt/providers/admin_provider.dart';
import 'package:petadopt/providers/auth_provider.dart';
import 'package:petadopt/providers/hewan_provider.dart';
import 'package:petadopt/providers/profile_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Authrepostories authrepostories = Authrepostories();
  final Profilerepositories repositories = Profilerepositories();
  final Hewanrepositories hewanrepositories = Hewanrepositories();
  final Adminrepository adminrepositories = Adminrepository();
  final SharedPrefHelper _helper = SharedPrefHelper();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<Authbloc>(
          create: (_) => Authbloc(authrepostories: authrepostories)
            ..add(AuthCheckStatus()),
        ),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc(repositories)),
        BlocProvider<HewanBloc>(create: (_) => HewanBloc(hewanrepositories)),
        BlocProvider<AdminBloc>(create: (_) => AdminBloc(adminrepositories)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<Authbloc, Authstate>(
          builder: (context, state) {
            if (state is AuthLoading || state is Authinitial) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else if (state is Authautenticated) {
              return FutureBuilder<String?>(
                future: authrepostories.getUserRole(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final role = snapshot.data;
                  return role == 'admin'
                      ? const AdminMainPage()
                      : const MainPage();
                },
              );
            } else {
              return const LandingPage();
            }
          },
        ),
      ),
    );
  }
}
