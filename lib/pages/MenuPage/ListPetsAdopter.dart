// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/pages/MenuPage/DetailPetsAdoption.dart';
import 'package:petadopt/pages/MenuPage/ListHewanUploaded.dart';
import 'package:provider/provider.dart';

class Listpetsadopter extends StatelessWidget {
  final int hewanID;
  const Listpetsadopter({
    Key? key,
    required this.hewanID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HewanBloc>()..add(GetPemohonHewanbyID(id: hewanID));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Permohonan Adopsi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Listhewanuploaded()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: BlocBuilder<HewanBloc, HewanState>(
        builder: (context, state) {
          if (state is HewanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HewanSuccess) {
            final data = state.hewandata;
            return ListView.separated(
              padding: const EdgeInsets.only(top: 18, bottom: 18),
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final pemohon = data[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_getFullImageUrl(pemohon.image ?? "")),
                      radius: 24,
                    ),
                    title: Text(
                      pemohon.nama ?? 'Nama Tidak Tersedia',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detailpetsadoption(
                            hewanID: hewanID,
                            userID: pemohon.userId!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is HewanError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }

  String _getFullImageUrl(String imagePath) {
    const baseUrl = 'http://10.0.2.2:8000';

    if (imagePath.startsWith('http')) {
      // Ganti 'localhost' dengan '10.0.2.2' agar bisa diakses dari emulator
      return imagePath.replaceFirst('localhost', '10.0.2.2');
    } else if (imagePath.startsWith('/storage')) {
      return '$baseUrl$imagePath';
    } else {
      return '$baseUrl/storage/$imagePath';
    }
  }
}
