import 'package:flutter/material.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/providers/auth_provider.dart';
import 'package:petadopt/services/auth_services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authServices: AuthServices()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adopt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: SharedPrefHelper().isAuth(), // ini cek token
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // atau splash
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          } else {
            return const LandingPage();
          }
        },
      ),
    );
  }
}
