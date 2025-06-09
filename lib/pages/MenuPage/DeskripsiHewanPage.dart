import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/hewan_respon_model.dart';
import 'package:petadopt/providers/hewan_provider.dart';

class DeskripsiHewanPage extends StatelessWidget {
  final int id;

  const DeskripsiHewanPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HewanBloc(Hewanrepositories())..add(GetHewanByIdEvent(id: id)),
      child: const DeskripsiHewanPageView(),
    );
  }
}

class DeskripsiHewanPageView extends StatelessWidget {
  const DeskripsiHewanPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Hewan"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: BlocBuilder<HewanBloc, HewanState>(
        builder: (context, state) {
          if (state is HewanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HewanError) {
            return Center(
              child: Text(
                state.message,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            );
          }

          if (state is HewanSuccess && state.hewandata.isNotEmpty) {
            final Datum data = state.hewandata[0];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(data.image),
                  const SizedBox(height: 24),
                  _buildNameAndStatus(theme, data),
                  const SizedBox(height: 28),
                  _buildInfoRow(data),
                  const SizedBox(height: 30),
                  _buildOwnerCard(data),
                  const SizedBox(height: 30),
                  _buildAdoptButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return Center(
            child: Text("Data tidak ditemukan.",
                style: theme.textTheme.bodyMedium),
          );
        },
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Builder(
          builder: (context) {
            if (imagePath != null && imagePath.isNotEmpty) {
              final url = _getFullImageUrl(imagePath);
              print("🔍 Gambar dimuat dari URL: $url");

              return Image.network(
                url,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 240,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print("❌ Gagal memuat gambar dari URL: $url");
                  return _buildErrorImage();
                },
              );
            } else {
              print("⚠️ imagePath null atau kosong");
              return _buildErrorImage();
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      height: 240,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 80),
      ),
    );
  }

  Widget _buildNameAndStatus(ThemeData theme, Datum data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            data.nama ?? '-',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: (data.status?.toLowerCase().trim() == 'tersedia')
                ? Colors.green[600]
                : Colors.red[600],
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            data.status ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(Datum data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoBox(data.jenisKelamin ?? '-', "Jenis Kelamin"),
        _infoBox(data.warna ?? '-', "Warna"),
        _infoBox(data.jenisHewan ?? '-', "Jenis"),
        _infoBox("${data.umur ?? '-'} bulan", "Umur"),
      ],
    );
  }

  Widget _buildOwnerCard(Datum data) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Owned by",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      data.user?.name ?? 'Unknown User',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              data.deskripsi ?? '-',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdoptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue[600],
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Fitur adopsi belum tersedia")),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                "Adopt Me",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String value, String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 83, maxWidth: 100),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.30),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConfig.mainblue,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
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
