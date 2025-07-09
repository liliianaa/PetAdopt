import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/favorite/favorite_bloc.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/model/Like_response.dart';
import 'package:petadopt/pages/MenuPage/DeskripsiHewanPage.dart';
import 'package:petadopt/pages/MenuPage/FavoritePetPage.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.token, this.message, this.onJenisSelected})
      : super(key: key);
  final String? token;
  final String? message;
  final Function(String)? onJenisSelected;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetFavoriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildKategori(context),
              const SizedBox(height: 16),
              _buildHewanFavorit(),
              const SizedBox(height: 16),
              _buildArtikelSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/logo.png', height: 60),
        Row(
          children: const [
            Icon(Icons.notifications_none),
            SizedBox(width: 12),
            Icon(Icons.message_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'search',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildKategori(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategori Hewan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKategoriIcon('assets/kucing1.png', 'Kucing', context),
            const SizedBox(width: 70),
            _buildKategoriIcon('assets/anjing4.jpeg', 'Anjing', context),
          ],
        ),
      ],
    );
  }

  Widget _buildKategoriIcon(String img, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KatalogPage(jenis: label.toLowerCase()),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 3.5),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(img),
              radius: 30,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildHewanFavorit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hewan Favorite Anda',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetFavoriteSuccess) {
              final favoriteList = state.getLikedList;

              if (favoriteList.isEmpty) {
                return const Text("Belum ada hewan favorit.");
              }

              return SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoriteList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = favoriteList[index];
                    return _buildHewanCardFromAPI(item);
                  },
                ),
              );
            } else if (state is FavoriteError) {
              return Text("Gagal memuat favorit: ${state.message}");
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  Widget _buildHewanCardFromAPI(Datum item) {
    return GestureDetector(
      onTap: () {
        if (item.id != null) {
          context.read<HewanBloc>().add(GetHewanByIdEvent(id: item.id!));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeskripsiHewanPage(id: item.id!),
            ),
          ).then((_) {
            context.read<FavoriteBloc>().add(GetFavoriteEvent());
            context.read<HewanBloc>().add(GetHewanEvent());
          });
        }
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: (item.image != null && item.image!.isNotEmpty)
                        ? item.image!
                        : 'https://via.placeholder.com/140x100.png?text=No+Image',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40, color: Colors.red),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (item.id != null) {
                        BlocProvider.of<FavoriteBloc>(context)
                            .add(PostFavoriteEvent(hewanId: item.id!));
                      }
                    },
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Favorit',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    item.nama ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.status?.name.toUpperCase() ?? '-',
                    style: TextStyle(
                      color: item.status == Status.TERSEDIA
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        '${item.likesCount ?? 0} suka',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArtikelSection() {
    final List<Map<String, String>> artikelData = [
      {
        'img': 'assets/article1.jpeg',
        'judul': 'Penyuluhan dan Edukasi Keamanan',
        'waktu': '2 hari lalu',
        'like': '1.4k',
      },
      {
        'img': 'assets/article2.jpeg',
        'judul': 'Cara Merawat Hewan Adopsi dengan Baik',
        'waktu': '1 minggu lalu',
        'like': '900',
      },
      {
        'img': 'assets/article3.jpeg',
        'judul': 'Manfaat Adopsi Hewan untuk Kesehatan Mental',
        'waktu': '3 hari lalu',
        'like': '1.1k',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Artikel', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: artikelData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = artikelData[index];
              return _buildArtikelCard(
                item['img']!,
                item['judul']!,
                item['waktu']!,
                item['like']!,
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildArtikelCard(
      String img, String judul, String waktu, String like) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(img,
                height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 12),
                const SizedBox(width: 4),
                Text(waktu, style: const TextStyle(fontSize: 12)),
                const Spacer(),
                const Icon(Icons.favorite_border, size: 12),
                const SizedBox(width: 4),
                Text(like, style: const TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
