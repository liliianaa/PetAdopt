import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/providers/adopsi_provider.dart';

import '../../bloc/Pengajuan Adopsi/adopsi_bloc.dart';

class AdopsiFormPage extends StatefulWidget {
  final int hewanId;

  const AdopsiFormPage({super.key, required this.hewanId});

  @override
  State<AdopsiFormPage> createState() => _AdopsiFormPageState();
}

class _AdopsiFormPageState extends State<AdopsiFormPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final noHpController = TextEditingController();
  final emailController = TextEditingController();
  final nikController = TextEditingController();
  final tempatTanggalLahirController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final alamatController = TextEditingController();
  final riwayatAdopsiController = TextEditingController();

  String? jenisKelamin;

  late final AdopsiBloc _adopsiBloc;

  @override
  void initState() {
    super.initState();
    _adopsiBloc = AdopsiBloc(Adopsirepositories());
  }

  @override
  void dispose() {
    namaController.dispose();
    umurController.dispose();
    noHpController.dispose();
    emailController.dispose();
    nikController.dispose();
    tempatTanggalLahirController.dispose();
    pekerjaanController.dispose();
    alamatController.dispose();
    riwayatAdopsiController.dispose();
    _adopsiBloc.close();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    _adopsiBloc.add(
      SubmitPengajuanAdopsiEvent(
        hewanId: widget.hewanId,
        nama: namaController.text,
        umur: umurController.text,
        noHp: noHpController.text,
        email: emailController.text,
        nik: nikController.text,
        jenisKelamin: jenisKelamin!,
        tempatTanggalLahir: tempatTanggalLahirController.text,
        pekerjaan: pekerjaanController.text,
        alamat: alamatController.text,
        riwayatAdopsi: riwayatAdopsiController.text.isEmpty
            ? null
            : riwayatAdopsiController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adopsiBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF3FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("Formulir Pendaftaran",
              style: TextStyle(color: Colors.black)),
        ),
        body: BlocConsumer<AdopsiBloc, AdopsiState>(
          listener: (context, state) {
            if (state is AdopsiLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is AdopsiSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            } else if (state is AdopsiError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        "Nama Sesuai KTP", "Muhammad Rizki", namaController),
                    _buildTextField("Umur", "25 Tahun", umurController,
                        keyboardType: TextInputType.number),
                    _buildTextField(
                        "Riwayat Adopsi (jika pernah)",
                        "ceritakan hewan apa dan berapa lama",
                        riwayatAdopsiController),
                    _buildTextField("No HP", "088xxxxxxxxx", noHpController,
                        keyboardType: TextInputType.phone),
                    _buildTextField(
                        "Email", "example@gmail.com", emailController,
                        keyboardType: TextInputType.emailAddress),
                    _buildTextField("NIK", "3304xxxxxxxxxxxx", nikController,
                        keyboardType: TextInputType.number),
                    _buildDropdownJenisKelamin(),
                    _buildTextField(
                        "Tempat, Tanggal Lahir",
                        "Contoh: Semarang, 11-11-2000",
                        tempatTanggalLahirController),
                    _buildTextField("Pekerjaan", "Pelajar/Mahasiswa/Bekerja",
                        pekerjaanController),
                    _buildTextField("Alamat",
                        "Jl Woltermonginsidi No.32 Semarang", alamatController),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text("Kirim",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(label, hint: hint),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildDropdownJenisKelamin() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration("Jenis Kelamin"),
        value: jenisKelamin,
        onChanged: (value) => setState(() => jenisKelamin = value),
        items: const [
          DropdownMenuItem(value: "laki-laki", child: Text("Laki -Laki")),
          DropdownMenuItem(value: "perempuan", child: Text("Perempuan")),
        ],
        validator: (value) => value == null ? "Pilih jenis kelamin" : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      labelStyle: const TextStyle(
          color: ColorConfig.mainblue, fontWeight: FontWeight.w500),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    );
  }
}
