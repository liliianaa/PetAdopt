import 'package:flutter/material.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/helper/SharedPrefHelper.dart';
import 'package:petadopt/pages/MenuPage/AddHewanPage.dart';
import 'package:petadopt/pages/MenuPage/HomePage.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';
import 'package:petadopt/pages/MenuPage/KomunitasPage.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  String? token;
  String? message;

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

    _loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefsHelper = SharedPrefHelper();
    final savedToken = await prefsHelper.getToken();
    final savedMessage = await prefsHelper.getMessage();

    setState(() {
      token = savedToken;
      message = savedMessage;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.forward(from: 0.0);
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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return const KatalogPage();
      // case 2:
      //   return const KomunitasPage();
      case 2:
        return const Profilepage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
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
          // _buildNavItem(Icons.group_add_outlined, 'Komunitas', 2),
          _buildNavItem(Icons.person, 'Profil', 2),
        ],
      ),
    );
  }
}
