import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/ProfileBloc.dart';
import 'package:petadopt/bloc/Profile/ProfileEvent.dart';
import 'package:petadopt/bloc/Profile/ProfileState.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class Myprofilepage extends StatefulWidget {
  const Myprofilepage({super.key});

  @override
  State<Myprofilepage> createState() => _MyprofilepageState();
}

class _MyprofilepageState extends State<Myprofilepage> {
  @override
  void initState() {
    super.initState();
    context.read<Profilebloc>().add(fetchProfiledetail());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Authbloc, Authstate>(
      listener: (context, state) {
        if (state is Authunautenticated) {
          // Arahkan ke halaman login
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.blue),
          title: const Text(
            'Profil Saya',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
        body: BlocBuilder<Profilebloc, Profilestate>(
          builder: (context, state) {
            if (state is Profileloading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final data = state.profiledata;

              return Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/anjing1.jpeg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {}, // aksi untuk tombol ini
                        child: Image.asset(
                          'assets/Group 402.png',
                          width: 40,
                          height: 40,
                        ),
                      )),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileField(
                            label: 'Nama Lengkap',
                            value: data['name'] ?? 'Tidak tersedia'),
                        _ProfileField(
                            label: 'Tanggal Lahir',
                            value: data['tanggal_lahir'] ?? 'Tidak tersedia'),
                        _ProfileField(
                            label: 'Jenis Kelamin',
                            value: data['jenis_kelamin'] ?? 'Tidak tersedia'),
                        _ProfileField(
                            label: 'No Telepon',
                            value: data['no_telp'] ?? 'Tidak tersedia'),
                        _ProfileField(
                            label: 'Email',
                            value: data['email'] ?? 'Tidak tersedia'),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is Profileerror) {
              return Center(child: Text("Gagal: ${state.message}"));
            } else {
              return const Center(child: Text("Tidak ada data."));
            }
          },
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black54)),
          const Divider(height: 20),
        ],
      ),
    );
  }
}
