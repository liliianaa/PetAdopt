import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadopt/pages/LoginPage.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:provider/provider.dart';
import 'package:petadopt/providers/auth_model.dart';
import 'package:petadopt/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
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
                    color: ColorConfig.mainblue,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: ColorConfig.mainblue),
                    hintText: 'Masukkan email anda',
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: ColorConfig.mainblue,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pengguna',
                    labelStyle: TextStyle(color: ColorConfig.mainblue),
                    hintText: 'Masukkan nama anda',
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(
                      Icons.person_2_outlined,
                      color: ColorConfig.mainblue,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi',
                    labelStyle: const TextStyle(color: ColorConfig.mainblue),
                    hintText: 'Masukkan kata sandi anda',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.lock_clock_outlined,
                      color: ColorConfig.mainblue,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      color: ColorConfig.mainblue,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConfig.mainblue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConfig.mainblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.register(Register(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        ));

                        if (authProvider.state == AuthState.success) {
                          // Simpan email dan password ke SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('email', _emailController.text);
                          prefs.setString('password', _passwordController.text);
                          prefs.setBool('rememberMe', true);

                          // Navigasi ke halaman utama setelah registrasi berhasil
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(authProvider.message)),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Align(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Sudah punya akun? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Masuk',
                                style: TextStyle(color: ColorConfig.mainblue)),
                          ],
                        ),
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
