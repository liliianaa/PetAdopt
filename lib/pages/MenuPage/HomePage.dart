import 'package:flutter/material.dart';
import 'package:petadopt/pages/MenuPage/FavoritePetPage.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, this.token, this.message}) : super(key: key);
  final String? token;
  final String? message;


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
          children: [
            const Icon(Icons.notifications_none),
            const SizedBox(width: 12),
            const Icon(Icons.message_outlined),
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
        // Navigasi ke KatalogPage dengan kategori label
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KatalogPage(kategori: label),
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
    final favoritData = [
      {
        'img': 'assets/kucing2.jpeg',
        'nama': 'Kucing Persia',
        'lokasi': 'Semarang',
      },
      {
        'img': 'assets/anjing3.jpeg',
        'nama': 'Kucing Oren',
        'lokasi': 'Bandung',
      },
      {
        'img': 'assets/kucing4.jpeg',
        'nama': 'Kucing Anggora',
        'lokasi': 'Jakarta',
      },
      {
        'img': 'assets/kucing5.jpeg',
        'nama': 'Kucing Anggora',
        'lokasi': 'Jakarta',
      },
      {
        'img': 'assets/anjing4.jpeg',
        'nama': 'Kucing Anggora',
        'lokasi': 'Jakarta',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hewan Favorit anda',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favoritData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = favoritData[index];
              return _buildHewanCard(
                  item['img']!, item['nama']!, item['lokasi']!);
            },
          ),
        )
      ],
    );
  }

  Widget _buildHewanCard(String imgPath, String nama, String lokasi) {
    return Container(
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
                child: Image.asset(imgPath,
                    height: 100, width: double.infinity, fit: BoxFit.cover),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite, color: Colors.red),
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
                  child: const Text('Sold out', style: TextStyle(fontSize: 10)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 12),
                    const SizedBox(width: 4),
                    Text(lokasi, style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
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
