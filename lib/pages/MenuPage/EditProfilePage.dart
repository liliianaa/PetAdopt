import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/DetailProfile_model.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';

class Editprofilepage extends StatefulWidget {
  final DetailProfileModel profiledata;
  const Editprofilepage({
    Key? key,
    required this.profiledata,
  }) : super(key: key);

  @override
  State<Editprofilepage> createState() => _EditprofilepageState();
}

class _EditprofilepageState extends State<Editprofilepage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _emailController;
  late TextEditingController _ttlController;
  String? selectedJenisKelamin;
  DateTime? rawTanggal;

  @override
  void initState() {
    super.initState();
    final data = widget.profiledata;
    _namaController = TextEditingController(text: data.name ?? '');
    _noHpController = TextEditingController(text: data.noTelp ?? '');
    _emailController = TextEditingController(text: data.email ?? '');
    selectedJenisKelamin = _formatJenisKelamin(data.jenisKelamin ?? '');

    if (data.tanggalLahir != null) {
      rawTanggal = data.tanggalLahir;
      _ttlController = TextEditingController(
        text: DateFormat('dd-MM-yyyy', 'en_US').format(data.tanggalLahir!),
      );
    } else {
      _ttlController = TextEditingController();
    }
  }

  String? _formatJenisKelamin(String jenis) {
    if (jenis.toLowerCase().contains("laki")) {
      return "Laki-laki";
    } else if (jenis.toLowerCase().contains("perempuan")) {
      return "Perempuan";
    }
    return null;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _ttlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfiledetailSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profil berhasil diperbarui")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Myprofilepage()),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal: ${state.message}")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorConfig.mainbabyblue1,
        appBar: AppBar(
          backgroundColor: ColorConfig.mainbabyblue1,
          title: const Text(
            'Ubah Profile',
            style: TextStyle(
              color: ColorConfig.mainblue1,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: const BackButton(color: ColorConfig.mainblue1),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Nama Lengkap", _namaController),
                _buildDateField("Tanggal Lahir", _ttlController),
                _buildDropdownJenisKelamin(),
                _buildTextField("No. HP", _noHpController,
                    keyboardType: TextInputType.phone),
                _buildTextField("Email", _emailController,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updated = DetailProfileModel(
                          name: _namaController.text,
                          noTelp: _noHpController.text,
                          email: _emailController.text,
                          jenisKelamin: selectedJenisKelamin,
                          tanggalLahir: rawTanggal,
                        );
                        context.read<ProfileBloc>().add(
                            UpdateProfileEvent(profiledetailmodel: updated));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConfig.mainblue1,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: rawTanggal ?? DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              rawTanggal = picked;
              controller.text =
                  DateFormat('yyyy-MM-dd', 'en_US').format(picked);
            });
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib pilih tanggal" : null,
      ),
    );
  }

  Widget _buildDropdownJenisKelamin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedJenisKelamin,
        decoration: InputDecoration(
          labelText: "Jenis Kelamin",
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: const [
          DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
          DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
        ],
        onChanged: (value) {
          setState(() {
            selectedJenisKelamin = value;
          });
        },
        validator: (value) =>
            value == null ? "Jenis kelamin wajib dipilih" : null,
      ),
    );
  }
}
