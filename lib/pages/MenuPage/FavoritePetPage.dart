import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';

class FavoritePetPage extends StatelessWidget {
  const FavoritePetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConfig.mainblue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hewan Favorit',
          style: TextStyle(
            color: ColorConfig.mainblue,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            _buildFavoriteList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList() {
    final favoritData = [
      {
        'img': 'assets/kucing2.jpeg',
        'nama': 'Kucing Persia',
        'lokasi': 'Semarang',
      },
      {
        'img': 'assets/anjing3.jpeg',
        'nama': 'Anjing Golden',
        'lokasi': 'Bandung',
      },
      {
        'img': 'assets/kucing4.jpeg',
        'nama': 'Kucing Anggora',
        'lokasi': 'Jakarta',
      },
      {
        'img': 'assets/kucing5.jpeg',
        'nama': 'Kucing Kampung',
        'lokasi': 'Yogyakarta',
      },
      {
        'img': 'assets/anjing4.jpeg',
        'nama': 'Anjing Husky',
        'lokasi': 'Surabaya',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daftar Hewan Favorit Anda',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 12,
              color: ColorConfig.mainblue1,
            )),
        const SizedBox(height: 12),
        ListView.separated(
          itemCount: favoritData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = favoritData[index];
            return _buildFavoriteItem(
              item['img']!,
              item['nama']!,
              item['lokasi']!,
            );
          },
        )
      ],
    );
  }

  Widget _buildFavoriteItem(String imgPath, String nama, String lokasi) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset(imgPath,
                width: 100, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(lokasi, style: const TextStyle(fontSize: 13)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.favorite, color: Colors.red),
          )
        ],
      ),
    );
  }
}
