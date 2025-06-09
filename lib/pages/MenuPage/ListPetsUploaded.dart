import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/Hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/models/pet_model.dart';
import 'package:petadopt/providers/pets_provider.dart';

class Listpetsuploaded extends StatelessWidget {
  const Listpetsuploaded({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HewanBloc(petsrepository())..add(getpetsuploaded()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Hewan di Upload',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorConfig.mainwhite,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: BlocBuilder<HewanBloc, HewanState>(
          builder: (context, state) {
            if (state is hewanloading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is hewansuccess) {
              final List<Datum> hewanlist = state.hewan;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: hewanlist.length,
                  itemBuilder: (context, index) {
                    final hewan = hewanlist[index];
                    return Card(
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
                              hewan.image,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                                      hewan.nama,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )),
                                    Text(
                                      hewan.status,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      hewan.lokasi ?? '_',
                                      style: const TextStyle(fontSize: 13),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (state is hewanerror) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Tidak ada data'));
            }
          },
        ),
      ),
    );
  }
}
