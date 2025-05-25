import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadopt/config/ColorConfig.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.mainwhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 30, top: 30, right: 30, left: 5),
              margin: const EdgeInsets.only(top: 30, bottom: 40),
              decoration: const BoxDecoration(
                color: ColorConfig.mainbabyblue,
              ),
              child: Row(
                children: [
                  IconButton(
                    iconSize: 32,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/anjing1.jpeg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sufyaan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildmenuitem(
                      icon: Icons.person_outline,
                      title: 'Profil Saya',
                      // onTap: () => {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         //builder: (context) => Myprofilepage()),
                      //   )
                      // },
                    ),
                    _buildmenuitem(
                      icon: Icons.pets_outlined,
                      title: 'Daftar Hewan Diupload',
                      onTap: () => {},
                    ),
                    _buildmenuitem(
                      icon: Icons.history,
                      title: 'Riwayat Pengajuan',
                      onTap: () => {},
                    ),
                    _buildmenuitem(
                      icon: Icons.lock_outline,
                      title: 'Ubah Kata Sandi',
                      onTap: () => {},
                    ),
                    _buildmenuitem(
                      icon: Icons.logout,
                      title: 'Keluar',
                      onTap: () => {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildmenuitem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color color = Colors.black,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: ColorConfig.mainblue),
        title: Text(title, style: TextStyle(color: color)),
        onTap: onTap,
      ),
    );
  }
}
