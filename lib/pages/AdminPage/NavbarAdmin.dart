import 'package:flutter/material.dart';
import 'package:petadopt/bloc/Auth/AuthBloc.dart';
import 'package:petadopt/bloc/Auth/AuthEvent.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/AdminPage/AdminDashboardPage.dart';
import 'package:petadopt/pages/AdminPage/ListPermohonanShelterAdmin.dart';
import 'package:provider/provider.dart';
import 'package:petadopt/pages/LandingPage.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Logout index
      _showLogoutDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _controller.forward(from: 0.0);
    }
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
        return const AdminDashboard();
      case 1:
        return const DataPengajuanShelterPage(); // Buat halaman user manajemen
      default:
        return const AdminDashboard();
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
          _buildNavItem(Icons.home, 'Dashboard', 0),
          _buildNavItem(Icons.grid_view_rounded, 'Shelter', 1),
          _buildNavItem(Icons.logout, 'Logout', 2),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<Authbloc>()..add(AuthLogoutRequest());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
