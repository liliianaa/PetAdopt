import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/LoginPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/RegisterPage.dart';
import 'package:petadopt/models/auth_model.dart';
import 'package:petadopt/providers/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    setState(() {
      _rememberMe = rememberMe;
    });
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
                const SizedBox(height: 32),
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConfig.mainblue,
                  ),
                ),
                const SizedBox(height: 24),
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
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) async {
                            setState(() {
                              _rememberMe = value ?? false;
                            });

                            final prefs = await SharedPreferences.getInstance();

                            if (_rememberMe) {
                              // Load data saat dicentang
                              setState(() {
                                _emailController.text =
                                    prefs.getString('email') ?? '';
                                _passwordController.text =
                                    prefs.getString('password') ?? '';
                              });
                            } else {
                              // Clear data saat tidak dicentang
                              setState(() {
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
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
                      backgroundColor: ColorConfig.mainblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.login(Login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ));

                      if (authProvider.state == AuthState.success) {
                        // Ambil token dari SharedPreferences
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');

                        // Simpan email, password, dan remember me status ke SharedPreferences jika rememberMe true
                        if (_rememberMe) {
                          prefs.setString('email', _emailController.text);
                          prefs.setString('password', _passwordController.text);
                          prefs.setBool('rememberMe', true);
                        } else {
                          prefs.remove('email');
                          prefs.remove('password');
                          prefs.remove('rememberMe');
                        }

                        // Cetak token ke konsol
                        print('TOKEN: $token');

                        // Navigasi ke MainPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.message)),
                        );
                      }
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
                const SizedBox(height: 8),
                Center(
                  child: Align(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registerpage()),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Daftar',
                                style: TextStyle(color: ColorConfig.mainblue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
