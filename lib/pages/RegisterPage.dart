import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/LoginPage.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final bool isAdd;
  const RegisterPage({Key? key, required this.isAdd}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

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
        child: BlocConsumer<Authbloc, Authstate>(
          listener: (context, state) async {
            if (state is Authunautenticated && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            } else if (state is Authautenticated) {
              // Simpan ke SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('email', _emailController.text);
              prefs.setString('password', _passwordController.text);
              prefs.setBool('rememberMe', true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage(isAdd: true)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Image.asset('assets/logo.png', height: 200),
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
                        hintText: 'Masukkan email anda',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
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
                        hintText: 'Masukkan nama anda',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
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
                        hintText: 'Masukkan kata sandi',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConfig.mainblue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<Authbloc>().add(
                                        AuthregisterRequest(
                                            _nameController.text,
                                            _emailController.text,
                                            _passwordController.text),
                                      );
                                }
                              },
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(isAdd: false),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Sudah punya akun? ',
                          children: [
                            TextSpan(
                              text: 'Masuk',
                              style: TextStyle(color: ColorConfig.mainblue),
                            ),
                          ],
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
            );
          },
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
