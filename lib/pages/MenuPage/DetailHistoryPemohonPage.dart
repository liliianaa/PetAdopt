import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/hewan_respon_model.dart';
import 'package:petadopt/pages/MenuPage/EditDataAdoptionPage.dart';
import 'package:petadopt/pages/MenuPage/HistoryAdoptionPage.dart';
import 'package:petadopt/pages/MenuPage/ListPetsAdopter.dart';

class Detailhistorypemohonpage extends StatelessWidget {
  final int pemohonID;

  const Detailhistorypemohonpage({super.key, required this.pemohonID});

  @override
  Widget build(BuildContext context) {
    context.read<HewanBloc>()
      ..add(getDetailhistorypemohon(pemohonID: pemohonID));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Data Pengajuan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.lightBlueAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Historyadoptionpage()),
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: BlocBuilder<HewanBloc, HewanState>(
          builder: (context, state) {
            if (state is HewanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HewanPemohonSuccess) {
              final datadetail = state.pemohondata;
              final Map<String, String?> detailhistory = {
                "Nama Lengkap": datadetail.namaLengkap,
                "Umur": datadetail.umur.toString(),
                "No. HP": datadetail.noHp,
                "Email": datadetail.email,
                "NIK": datadetail.nik,
                "Jenis Kelamin": datadetail.jenisKelamin,
                "Tempat Tanggal Lahir": datadetail.tempatTanggalLahir,
                "Alamat": datadetail.alamat,
                "Pekerjaan": datadetail.pekerjaan,
                "Riwayat Adopsi": datadetail.riwayatAdopsi,
              };
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConfig.mainblue),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailhistory.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${entry.key}',
                                      style: const TextStyle(fontSize: 14),
                                    )),
                                const Text(': '),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${entry.value}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            context.read<HewanBloc>().add(deletepermohonan(
                                permohonanID: datadetail.permohonanId));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Historyadoptionpage()));
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: ColorConfig.mainwhite,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConfig.mainblue1,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormUpdatePemohonPage(
                                        existingData: datadetail)));
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: ColorConfig.mainwhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is HewanError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Tidak ada data"));
            }
          },
        ));
  }
}
