import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/model/hewan_respon_model.dart';
import 'package:petadopt/pages/MenuPage/DetailHistoryPemohonPage.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class Historyadoptionpage extends StatelessWidget {
  const Historyadoptionpage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HewanBloc>()..add(getHistoryPermohonan());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pegajuan Adopsi',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD6EFFF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profilepage(),
            ),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<HewanBloc, HewanState>(
          builder: (context, state) {
            if (state is HewanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HewanError) {
              return Center(child: Text(state.message));
            } else if (state is HistoryPermohonanSucces) {
              final historylist = state.historypermohonan;
              if (historylist.isEmpty) {
                return const Center(
                  child: Text("Belum Ada History Pengajuan"),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: historylist.length,
                itemBuilder: (context, index) {
                  final historyitem = historylist[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(historyitem.image ?? ''),
                        radius: 24,
                      ),
                      title: Text(
                        historyitem.nama ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        print(historyitem.permohonanId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detailhistorypemohonpage(
                                    pemohonID: historyitem.permohonanId!)));
                      },
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
}
