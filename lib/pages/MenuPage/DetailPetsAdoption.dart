// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/acc_pemohon_model.dart';
import 'package:petadopt/pages/MenuPage/HistoryAdoptionPage.dart';
import 'package:petadopt/pages/MenuPage/ListPetsAdopter.dart';
import 'package:provider/provider.dart';

class Detailpetsadoption extends StatelessWidget {
  final int hewanID;
  final int userID;
  const Detailpetsadoption({
    Key? key,
    required this.hewanID,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HewanBloc>()
      ..add(getDetailPemohon(id: hewanID, userId: userID));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemohon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Listpetsadopter(hewanID: hewanID),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocBuilder<HewanBloc, HewanState>(
        builder: (context, state) {
          if (state is HewanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is updateStatusPemohonSuccess) {
            return const Center(child: Text("status berhasil diperbarui"));
          } else if (state is HewanPemohonSuccess) {
            final data = state.pemohondata;
            final Map<String, String?> detaildata = {
              "Nama Lengkap": data.namaLengkap,
              "Umur": data.umur.toString(),
              "No. HP": data.noHp,
              "Email": data.email,
              "NIK": data.nik,
              "Jenis Kelamin": data.jenisKelamin,
              "Tempat Tanggal Lahir": data.tempatTanggalLahir,
              "Pekerjaan": data.pekerjaan,
              "Riwayat Adopsi": data.riwayatAdopsi,
              "Status" : data.status,
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
                      children: detaildata.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${entry.key}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const Text(": "),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  entry.value ?? "-",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
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
                          context.read<HewanBloc>().add(updatestatusPemohon(
                              pemohonId: data.permohonanId,
                              accpemohon:
                                  Acclistpemohonmodel(status: "ditolak")));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Listpetsadopter(hewanID: hewanID)));
                        },
                        child: const Text(
                          'Tolak',
                          style: TextStyle(
                            color: ColorConfig.mainwhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConfig.mainblue,
                        ),
                        onPressed: () {
                          context.read<HewanBloc>().add(updatestatusPemohon(
                              pemohonId: data.permohonanId,
                              accpemohon:
                                  Acclistpemohonmodel(status: "diterima")));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Listpetsadopter(hewanID: hewanID)));
                        },
                        child: const Text(
                          'Terima',
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
      ),
    );
  }
}
