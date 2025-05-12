import 'package:flutter/material.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/providers/auth_model.dart';
import 'package:petadopt/services/petadopt_services.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LandingPage(),
    );
  }
}
