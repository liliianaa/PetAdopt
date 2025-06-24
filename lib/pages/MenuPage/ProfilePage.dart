import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/LandingPage.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/MenuPage/EditPassPage.dart';
import 'package:petadopt/pages/MenuPage/HistoryAdoptionPage.dart';
import 'package:petadopt/pages/MenuPage/ListHewanUploaded.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';
import 'package:petadopt/providers/profile_provider.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(Profilerepositories())..add(GetProfileEvent()),
      child: BlocListener<Authbloc, Authstate>(
        listener: (context, state) {
          if (state is Authautenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          }
        },
        child: Scaffold(
          backgroundColor: ColorConfig.mainwhite,
          body: SafeArea(
            child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileSuccess) {
                final profile = state.profiledata;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 30, top: 30, right: 30, left: 5),
                      margin: const EdgeInsets.only(top: 30, bottom: 40),
                      decoration: const BoxDecoration(
                        color: ColorConfig.mainbabyblue,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              iconSize: 32,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              },
                              icon: const Icon(Icons.arrow_back)),
                          const CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage('assets/anjing1.jpeg'),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['name'] ?? 'tidak ada data',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile['email'] ?? 'tidak ada data',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildmenuitem(
                              icon: Icons.person_outline,
                              title: 'Profil Saya',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Myprofilepage()),
                                );
                              },
                            ),
                            _buildmenuitem(
                              icon: Icons.pets_outlined,
                              title: 'Daftar hewan yang Diupload',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Listhewanuploaded()));
                              },
                            ),
                            _buildmenuitem(
                              icon: Icons.history,
                              title: 'Riwayat Pengajuan',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Historyadoptionpage()));
                              },
                            ),
                            _buildmenuitem(
                              icon: Icons.lock_outlined,
                              title: 'Ubah Kata Sandi',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Editpasspage()));
                              },
                            ),
                            _buildmenuitem(
                              icon: Icons.logout,
                              title: 'Keluar',
                              onTap: () => _showLogoutDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(child: Text("Error: ${state.message}"));
              } else {
                return const Center(child: Text("Tidak ada data profil."));
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildmenuitem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color color = Colors.black,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: ColorConfig.mainblue),
        title: Text(title, style: TextStyle(color: color)),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
              context.read<Authbloc>().add(AuthLogoutRequest());
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
