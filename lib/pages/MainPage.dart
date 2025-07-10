import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/pages/MenuPage/AddHewanPage.dart';
import 'package:petadopt/pages/MenuPage/HomePage.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';
import 'package:petadopt/pages/MenuPage/KomunitasPage.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class MainPage extends StatefulWidget {
  final String? jenisAwal;
  const MainPage({super.key, this.jenisAwal});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _pages = [
      HomePage(onJenisSelected: _handleJenisSelected),
      KatalogPage(jenis: widget.jenisAwal ?? 'semua'),
      const Profilepage(),
    ];
  }

  void _handleJenisSelected(String jenis) {
    setState(() {
      _selectedIndex = 1;
      _pages[1] = KatalogPage(jenis: jenis);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorConfig.mainblue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.grid_view, 'Katalog', 1),
          _buildNavItem(Icons.person, 'Profil', 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double scale = isSelected ? _animation.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: Icon(
              icon,
              color: isSelected ? ColorConfig.mainblue : Colors.grey,
            ),
          );
        },
      ),
      label: label,
    );
  }
}
