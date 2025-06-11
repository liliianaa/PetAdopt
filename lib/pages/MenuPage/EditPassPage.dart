import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class Editpasspage extends StatefulWidget {
  const Editpasspage({super.key});

  @override
  State<Editpasspage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Editpasspage> {
  final _formKey = GlobalKey<FormState>();
  final _oldpassController = TextEditingController();
  final _newpassController = TextEditingController();
  final _confirmpassController = TextEditingController();

  bool _obsecureoldpass = true;
  bool _obsecurenewpass = true;
  bool _obsecureconfirmnewpass = true;

  @override
  void initState() {
    context.read<ProfileBloc>()..add(GetProfileDetailEvent());
    super.initState();
  }

  @override
  void dispose() {
    _oldpassController.dispose();
    _newpassController.dispose();
    _confirmpassController.dispose();
    super.dispose();
  }

  void _handleSavepassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(ProfilePassUpdate(
          old_password: _oldpassController.text,
          new_password: _newpassController.text,
          confrim_password: _confirmpassController.text));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profilepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.mainbabyblue1,
      appBar: AppBar(
        backgroundColor: ColorConfig.mainbabyblue1,
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            color: ColorConfig.mainblue1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: const BackButton(color: ColorConfig.mainblue1),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfilePassUpdate) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorConfig.mainwhite,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildpasswordfield(
                        label: 'Kata Sandi Lama',
                        controller: _oldpassController,
                        obscureText: _obsecureoldpass,
                        toggleObsecure: () {
                          setState(() {
                            _obsecureoldpass = !_obsecureoldpass;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password lama tidak boleh kosong';
                          }
                          return null;
                        }),
                    const SizedBox(height: 16),
                    _buildpasswordfield(
                      label: 'Kata Sandi Baru',
                      controller: _newpassController,
                      obscureText: _obsecurenewpass,
                      toggleObsecure: () {
                        setState(() {
                          _obsecurenewpass = !_obsecurenewpass;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password Minimal 6 Karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildpasswordfield(
                      label: 'Konfirmasi Kata Sandi',
                      controller: _confirmpassController,
                      obscureText: _obsecureconfirmnewpass,
                      toggleObsecure: () {
                        setState(() {
                          _obsecureconfirmnewpass = !_obsecureconfirmnewpass;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value != _newpassController.text) {
                          return 'Konfirmasi password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    state is ProfileLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: _handleSavepassword,
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorConfig.mainblue,
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildpasswordfield({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleObsecure,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 18),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              filled: true,
              fillColor: ColorConfig.mainbabyblue,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: toggleObsecure,
              )),
          validator: validator,
        ),
      ],
    );
  }
}
