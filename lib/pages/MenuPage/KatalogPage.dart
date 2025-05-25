import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MainPage.dart';
import 'package:petadopt/pages/MenuPage/HomePage.dart';

class KatalogPage extends StatefulWidget {
  final String kategori;

  const KatalogPage({super.key, this.kategori = 'Semua'});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  late String selectedKategori;

  @override
  void initState() {
    super.initState();
    selectedKategori = widget.kategori;
  }

  List<Map<String, dynamic>> katalogHewan = [
    {
      'img': 'assets/kucing2.jpeg',
      'nama': 'Kucing Persia',
      'lokasi': 'Semarang',
      'kategori': 'Kucing',
      'isFavorit': true,
    },
    {
      'img': 'assets/anjing4.jpeg',
      'nama': 'Anjing Buldog',
      'lokasi': 'Semarang',
      'kategori': 'Anjing',
      'isFavorit': false,
    },
    {
      'img': 'assets/anjing4.jpeg',
      'nama': 'Anjing Pomeranian',
      'lokasi': 'Semarang',
      'kategori': 'Anjing',
      'isFavorit': false,
    },
    {
      'img': 'assets/kucing2.jpeg',
      'nama': 'Kucing Persia',
      'lokasi': 'Semarang',
      'kategori': 'Kucing',
      'isFavorit': false,
    },
    {
      'img': 'assets/anjing4.jpeg',
      'nama': 'Anjing Poodle',
      'lokasi': 'Semarang',
      'kategori': 'Anjing',
      'isFavorit': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConfig.mainblue),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
        title: const Text(
          'Katalog Hewan',
          style: TextStyle(
            color: ColorConfig.mainblue,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKategori(),
              const SizedBox(height: 16),
              Expanded(child: _buildKatalogGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKategori() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _kategoriButton(
            'Semua', 'assets/article1.jpeg'), // ikon all bisa custom
        const SizedBox(width: 20),
        _kategoriButton('Kucing', 'assets/kucing1.png'),
        const SizedBox(width: 20),
        _kategoriButton('Anjing', 'assets/anjing1.jpeg'),
      ],
    );
  }

  Widget _kategoriButton(String label, String imgPath) {
    bool isSelected = selectedKategori == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedKategori = label;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 3.5),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(imgPath),
              radius: 30,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKatalogGrid() {
    var filteredHewan = selectedKategori == 'Semua'
        ? katalogHewan
        : katalogHewan
            .where((item) => item['kategori'] == selectedKategori)
            .toList();

    return GridView.builder(
      itemCount: filteredHewan.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        var hewan = filteredHewan[index];
        return _buildKatalogCard(hewan);
      },
    );
  }

  Widget _buildKatalogCard(Map<String, dynamic> hewan) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  hewan['img'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hewan['isFavorit'] = !hewan['isFavorit'];
                    });
                  },
                  child: Icon(
                    hewan['isFavorit'] ? Icons.favorite : Icons.favorite_border,
                    color: hewan['isFavorit'] ? Colors.red : Colors.white,
                  ),
                ),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      'Sold Out',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hewan['nama'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12),
                    const SizedBox(width: 4),
                    Text(hewan['lokasi'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
