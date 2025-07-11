import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthState.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/DetailProfile_model.dart';
import 'package:petadopt/pages/MenuPage/EditProfilePage.dart';
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
    context.read<ProfileBloc>().add(GetProfileDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Authbloc, Authstate>(
      listener: (context, state) {
        if (state is Authunautenticated) {
          // Arahkan ke halaman login
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profilepage()));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profilepage()),
              );
            },
            icon: const Icon(Icons.arrow_back, color: ColorConfig.mainblue1),
          ),
          title: const Text(
            'Profil Saya',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Editprofilepage(
                                        profiledata: DetailProfileModel(
                                      name: data['name'],
                                      tanggalLahir: _parseTanggalLahir(
                                          data['tanggal_lahir']),
                                      jenisKelamin: data['jenis_kelamin'],
                                      noTelp: data['no_telp'],
                                      email: data['email'],
                                    ))),
                          );
                        }, // aksi untuk tombol ini
                        child: Image.asset(
                          'assets/Group 402.png',
                          width: 40,
                          height: 40,
                        ),
                      )),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
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
            } else if (state is ProfileError) {
              return Center(child: Text("Gagal: ${state.message}"));
            } else {
              return const Center(child: Text("Tidak ada data."));
            }
          },
        ),
      ),
    );
  }

  DateTime? _parseTanggalLahir(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      // Contoh format tanggal: "2000-03-14" atau "14-03-2000"
      if (dateStr.contains('-')) {
        if (dateStr.split('-')[0].length == 4) {
          return DateTime.parse(dateStr); // format yyyy-MM-dd
        } else {
          return DateFormat('dd-MM-yyyy').parse(dateStr); // format dd-MM-yyyy
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 15)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black54)),
          const Divider(height: 20),
        ],
      ),
    );
  }
}
