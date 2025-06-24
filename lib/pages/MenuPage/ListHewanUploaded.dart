import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/pages/MenuPage/ListPetsAdopter.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';
import 'package:provider/provider.dart';

class Listhewanuploaded extends StatefulWidget {
  const Listhewanuploaded({super.key});

  @override
  State<Listhewanuploaded> createState() => _ListhewanuploadedState();
}

class _ListhewanuploadedState extends State<Listhewanuploaded> {
  @override
  void initState() {
    super.initState();
    context.read<HewanBloc>().add(GetMyPets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Hewan di Upload',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profilepage()));
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HewanBloc, HewanState>(
          builder: (context, state) {
            if (state is HewanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HewanError) {
              return Center(child: Text(state.message));
            } else if (state is HewanSuccess) {
              final hewanlist = state.hewandata;
              if (hewanlist.isEmpty) {
                return const Center(
                    child: Text("Belum ada hewan yang di-upload."));
              }
              return GridView.builder(
                itemCount: hewanlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final hewan = hewanlist[index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Listpetsadopter(hewanID: hewan.id!))),
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              _getFullImageUrl(hewan.image ?? ""),
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    size: 100);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        hewan.nama ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      hewan.status ?? "",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      hewan.lokasi ?? "",
                                      style: const TextStyle(fontSize: 13),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("Tidak ada data."));
            }
          },
        ),
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
