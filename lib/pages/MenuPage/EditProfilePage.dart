import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';

class Editprofilepage extends StatefulWidget {
  const Editprofilepage({super.key});

  @override
  State<Editprofilepage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Editprofilepage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tgl_lahirController = TextEditingController();
  final TextEditingController _no_telpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? SelectedjenisKelamin;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileSuccess) {
      final data = state.profiledata;
      _nameController.text = data['name'] ?? '';
      _tgl_lahirController.text = data['tgl_lahir'] != null
          ? DateFormat('dd / MM / yyyy')
              .format(DateTime.parse(data['tgl_lahir']))
          : '';
      SelectedjenisKelamin = data['jenis_kelamin'];
      _no_telpController.text = data['no_telp'] ?? '';
      _emailController.text = data['email'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.red,
            ));
          } else if (state is ProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Profil berhasil diperbarui!"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Myprofilepage()),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorConfig.mainbabyblue1,
        appBar: AppBar(
          backgroundColor: ColorConfig.mainbabyblue1,
          elevation: 0,
          leading: BackButton(color: ColorConfig.mainblue),
          title: const Text(
            'Ubah Profil',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConfig.mainblue,
                fontSize: 16),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/anjing1.jpeg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: ColorConfig.mainblue, size: 20),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildTextField("Nama Lengkap", _nameController),
                    const SizedBox(height: 12),
                    _buildDateField("Tanggal Lahir", _tgl_lahirController),
                    const SizedBox(height: 12),
                    _buildDropdown("Jenis Kelamin"),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Nomor Telepon",
                      _no_telpController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Email",
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSaveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConfig.mainblue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConfig.mainwhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSaveProfile() {
    if (_nameController.text.isEmpty ||
        _tgl_lahirController.text.isEmpty ||
        SelectedjenisKelamin == null ||
        _no_telpController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Semua kolom harus diisi."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final parsedDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd / MM / yyyy').parse(_tgl_lahirController.text),
    );

    context.read<ProfileBloc>().add(UpdateProfileEvent(
          name: _nameController.text,
          tgl_lahir: parsedDate,
          jenis_kelamin: SelectedjenisKelamin!,
          no_telp: _no_telpController.text,
          email: _emailController.text,
        ));
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorConfig.mainbabyblue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: _selectDate,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorConfig.mainbabyblue,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: SelectedjenisKelamin,
          hint: const Text("Pilih jenis kelamin"),
          items: const [
            DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
            DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
          ],
          onChanged: (value) => setState(() => SelectedjenisKelamin = value),
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorConfig.mainbabyblue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tgl_lahirController.text = DateFormat('dd / MM / yyyy').format(picked);
      });
    }
  }
}
