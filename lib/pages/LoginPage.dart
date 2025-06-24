import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/RegisterPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final bool isAdd;
  const LoginPage({Key? key, required this.isAdd}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    setState(() {
      _rememberMe = rememberMe;
      if (rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveCredentials(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      prefs.setString('email', _emailController.text);
      prefs.setString('password', _passwordController.text);
      prefs.setBool('rememberMe', true);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<Authbloc, Authstate>(
        listener: (context, state) {
          if (state is Authautenticated) {
            _saveCredentials(_rememberMe);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          } else if (state is Authunautenticated && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Image.asset('assets/logo.png', height: 180),
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
                        hintText: 'Masukkan email anda',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Email wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Kata sandi',
                        hintText: 'Masukkan kata sandi anda',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password wajib diisi'
                          : null,
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
                            const Text('Ingat saya'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: forgot password
                          },
                          child: const Text('Lupa kata sandi?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConfig.mainblue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<Authbloc>().add(
                                        AuthLoginRequest(
                                          _emailController.text,
                                          _passwordController.text,
                                        ),
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
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage(isAdd: true)),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Belum punya akun? ',
                          children: [
                            TextSpan(
                              text: 'Daftar',
                              style: TextStyle(color: ColorConfig.mainblue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
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
