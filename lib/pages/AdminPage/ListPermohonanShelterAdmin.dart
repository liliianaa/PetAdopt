import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/admin/admin_bloc.dart';
import 'package:petadopt/model/List_shelter_admin.dart';
import 'package:petadopt/model/acc_pemohon_model.dart';
import 'package:petadopt/pages/AdminPage/NavbarAdmin.dart';

class DataPengajuanShelterPage extends StatelessWidget {
  const DataPengajuanShelterPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminBloc>().add(Getpermohonanshelter());
    return Scaffold(
      backgroundColor: const Color(0xFFE5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5F0FF),
        elevation: 0,
        title: const Text(
          'Data Pengajuan Shelter',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminMainPage(),
            ),
          ),
        ),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Adminerror) {
            return Center(child: Text("Terjadi kesalahan: ${state.message}"));
          } else if (state is AdminSuccess) {
            final List<Datum> daftarPemohon = state.dataadmin;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarPemohon.length,
              itemBuilder: (context, index) {
                final pemohon = daftarPemohon[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama lengkap  :  ${pemohon.user?.name ?? "-"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: pemohon.file != null
                            ? Image.network(
                                pemohon.file!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                              )
                            : const Icon(Icons.image_not_supported, size: 100),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                            ),
                            onPressed: () {
                              context.read<AdminBloc>().add(Updatestatusshelter(
                                  permohonan: pemohon.id!,
                                  permohonmodel:
                                      Acclistpemohonmodel(status: 'ditolak')));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminMainPage()));
                            },
                            child: const Text(
                              'Tolak',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              context.read<AdminBloc>().add(Updatestatusshelter(
                                  permohonan: pemohon.id!,
                                  permohonmodel:
                                      Acclistpemohonmodel(status: 'diterima')));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminMainPage()));
                            },
                            child: const Text(
                              'Terima',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }
}
