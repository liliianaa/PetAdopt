import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/hewan_respon_model.dart';
import 'package:petadopt/pages/MenuPage/AddHewanPage.dart';
import 'package:petadopt/pages/MenuPage/DeskripsiHewanPage.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  String selectedJenis = 'Semua';
  Set<int> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _getHewanByJenis("semua");
  }

  void _getHewanByJenis(String jenis) {
    if (jenis.toLowerCase() == 'semua') {
      context
          .read<HewanBloc>()
          .add(GetHewanEvent()); // event untuk ambil semua hewan
    } else {
      context
          .read<HewanBloc>()
          .add(GetHewanByJenisEvent(jenis: jenis.toLowerCase()));
    }
  }

  void _toggleFavorite(int id) {
    setState(() {
      favoriteIds.contains(id) ? favoriteIds.remove(id) : favoriteIds.add(id);
    });
  }

  void _onSelectJenis(String jenis) {
    setState(() {
      selectedJenis = jenis;
      _getHewanByJenis(jenis);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Hewan"),
        backgroundColor: ColorConfig.mainbabyblue,
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildJenisSelector(),
          const SizedBox(height: 8),
          Expanded(child: _buildHewanList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddHewanPage())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildJenisSelector() {
    final jenisList = [
      {
        'label': 'Semua',
        'icon': 'https://cdn-icons-png.flaticon.com/512/616/616408.png'
      },
      {
        'label': 'Kucing',
        'icon': 'https://cdn-icons-png.flaticon.com/512/1998/1998592.png'
      },
      {
        'label': 'Anjing',
        'icon': 'https://cdn-icons-png.flaticon.com/512/2171/2171990.png'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: jenisList
              .map((jenis) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _hewanSelector(jenis['label']!, jenis['icon']!),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildHewanList() {
    return BlocBuilder<HewanBloc, HewanState>(
      builder: (context, state) {
        if (state is HewanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HewanSuccess) {
          final data = state.hewandata;
          if (data.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final isFavorited = favoriteIds.contains(item.id);
              return _hewanCard(item, isFavorited);
            },
          );
        } else if (state is HewanError) {
          return Center(
            child: Text(
              state.message ?? "Terjadi kesalahan",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _hewanSelector(String jenis, String imageUrl) {
    final isSelected = selectedJenis == jenis;
    return InkWell(
      onTap: () => _onSelectJenis(jenis),
      borderRadius: BorderRadius.circular(40),
      splashColor: Colors.blue.withOpacity(0.3),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? ColorConfig.mainbabyblue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(40),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(imageUrl,
                  width: 40, height: 40, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(
              jenis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hewanCard(Datum item, bool isFavorited) {
    return GestureDetector(
      onTap: () {
        if (item.id != null) {
          context.read<HewanBloc>().add(GetHewanByIdEvent(id: item.id!));
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DeskripsiHewanPage(id: item.id!)),
        ).then((_) {
          _getHewanByJenis(
              selectedJenis); // reload data sesuai kategori terpilih
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: item.image ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 48, color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.status?.toUpperCase() ?? 'TERSEDIA',
                        style: TextStyle(
                          color: item.status == 'tersedia'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item.lokasi ?? '-',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black26,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () {
                    if (item.id != null) {
                      _toggleFavorite(item.id!);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
