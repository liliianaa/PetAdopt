import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/LoginPage.dart';
import 'package:petadopt/pages/RegisterPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 250,
                ),
                const SizedBox(height: 10),
                // Nama App
                const Text(
                  "PetAdopt",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConfig.mainblue,
                  ),
                ),
                const SizedBox(height: 5),
                // Slogan
                const Text(
                  "Kasih Kata Slogan",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConfig.mainblue,
                  ),
                ),
                const SizedBox(height: 20),
                // Deskripsi Aplikasi
                const Text(
                  "Aplikasi untuk memantau terapi sensorik\nanak autisme secara real-time, memberikan\nfeedback untuk penyesuaian terapi yang\nlebih tepat.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                // Tombol Masuk
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConfig.mainblue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                // Tombol Daftar
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConfig.mainbabyblue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
