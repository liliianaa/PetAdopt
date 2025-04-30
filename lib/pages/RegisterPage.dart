import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Image.asset(
                'assets/logo.png',
                height: 200,
              ),
              const SizedBox(height: 5),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colorconfig.mainblue,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman daftar
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Jika belum punya akun\n',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Daftar di sini!',
                            style: TextStyle(color: Colorconfig.mainblue)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colorconfig.mainblue),
                  hintText: 'Masukkan email anda',
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colorconfig.mainblue,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Pengguna',
                  labelStyle: TextStyle(color: Colorconfig.mainblue),
                  hintText: 'Masukkan nama anda',
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Icon(
                    Icons.person_2_outlined,
                    color: Colorconfig.mainblue,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Kata sandi',
                  labelStyle: const TextStyle(color: Colorconfig.mainblue),
                  hintText: 'Masukkan kata sandi anda',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.lock_clock_outlined,
                    color: Colorconfig.mainblue,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    color: Colorconfig.mainblue,
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colorconfig.mainblue),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke lupa sandi
                    },
                    child: const Text('Lupa kata sandi?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colorconfig.mainblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    // Aksi untuk Register
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('atau masuk dengan'),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(icon: FontAwesomeIcons.facebookF),
                  SizedBox(width: 16),
                  SocialButton(icon: FontAwesomeIcons.apple),
                  SizedBox(width: 16),
                  SocialButton(icon: FontAwesomeIcons.google),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;

  const SocialButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade200,
      child: Icon(icon, color: Colors.black),
    );
  }
}
