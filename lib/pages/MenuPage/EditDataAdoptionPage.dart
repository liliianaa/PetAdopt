import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/model/pemohonModel.dart';
import 'package:petadopt/pages/MenuPage/HistoryAdoptionPage.dart';

class FormUpdatePemohonPage extends StatefulWidget {
  final Data existingData;
  const FormUpdatePemohonPage({super.key, required this.existingData});

  @override
  State<FormUpdatePemohonPage> createState() => _FormUpdatePemohonPageState();
}

class _FormUpdatePemohonPageState extends State<FormUpdatePemohonPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _umurController;
  late TextEditingController _noHpController;
  late TextEditingController _emailController;
  late TextEditingController _nikController;
  late TextEditingController _ttlTempatController;
  late TextEditingController _ttlTanggalController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _alamatController;
  late TextEditingController _riwayatController;
  String? selectedJenisKelamin;
  String? _rawTanggalLahir;

  @override
  void initState() {
    super.initState();
    final data = widget.existingData;
    _namaController = TextEditingController(text: data.namaLengkap);
    _umurController = TextEditingController(text: data.umur.toString());
    _noHpController = TextEditingController(text: data.noHp);
    _emailController = TextEditingController(text: data.email);
    _nikController = TextEditingController(text: data.nik);
    _pekerjaanController = TextEditingController(text: data.pekerjaan);
    _alamatController = TextEditingController(text: data.alamat);
    _riwayatController = TextEditingController(text: data.riwayatAdopsi);
    selectedJenisKelamin = _formatJenisKelamin(data.jenisKelamin);

    if (data.tempatTanggalLahir.contains(',')) {
      final split = data.tempatTanggalLahir.split(',');
      _ttlTempatController = TextEditingController(text: split[0].trim());

      // Ambil raw format dan tampilkan dalam format lokal
      try {
        final rawDate = split[1].trim(); // ex: "14-03-2000"
        final parsedDate = DateFormat('dd-MM-yyyy').parse(rawDate);
        _ttlTanggalController = TextEditingController(
          text: DateFormat('dd MMMM yyyy', 'en_US').format(parsedDate),
        );
        _rawTanggalLahir = rawDate;
      } catch (_) {
        _ttlTanggalController = TextEditingController();
      }
    } else {
      _ttlTempatController = TextEditingController();
      _ttlTanggalController = TextEditingController();
    }
  }

  String? _formatJenisKelamin(String jenis) {
    if (jenis.toLowerCase().contains("laki")) {
      return "laki-laki";
    } else if (jenis.toLowerCase().contains("perempuan")) {
      return "perempuan";
    }
    return null; // fallback kalau nilainya nggak dikenal
  }

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _ttlTempatController.dispose();
    _ttlTanggalController.dispose();
    _pekerjaanController.dispose();
    _alamatController.dispose();
    _riwayatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.mainbabyblue1,
      appBar: AppBar(
        backgroundColor: ColorConfig.mainbabyblue1,
        title: const Text(
          'Ubah Data Pemohon',
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
              _buildTextField("Umur", _umurController,
                  keyboardType: TextInputType.number),
              _buildTextField("No. HP", _noHpController,
                  keyboardType: TextInputType.phone),
              _buildTextField("Email", _emailController,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField("NIK", _nikController),
              _buildDropdownJenisKelamin(),
              _buildTextField("Tempat Lahir", _ttlTempatController),
              _buildTanggalField(context, _ttlTanggalController),
              _buildTextField("Pekerjaan", _pekerjaanController),
              _buildTextField("Alamat", _alamatController),
              _buildTextField("Riwayat Adopsi", _riwayatController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final ttl =
                          "${_ttlTempatController.text}, ${_rawTanggalLahir ?? _ttlTanggalController.text}";
                      final data = Data(
                        userId: widget.existingData.userId,
                        hewanId: widget.existingData.hewanId,
                        permohonanId: widget.existingData.permohonanId,
                        namaLengkap: _namaController.text,
                        umur: int.parse(_umurController.text),
                        noHp: _noHpController.text,
                        email: _emailController.text,
                        nik: _nikController.text,
                        jenisKelamin: selectedJenisKelamin!,
                        tempatTanggalLahir: ttl,
                        pekerjaan: _pekerjaanController.text,
                        alamat: _alamatController.text,
                        riwayatAdopsi: _riwayatController.text,
                        status: widget.existingData.status,
                        tanggalPermohonan:
                            widget.existingData.tanggalPermohonan,
                      );
                      context.read<HewanBloc>().add(EditDataPemohon(
                            permohonanID: widget.existingData.permohonanId,
                            datapermohonan: data,
                          ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Historyadoptionpage()));
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
          DropdownMenuItem(value: "laki-laki", child: Text("Laki-laki")),
          DropdownMenuItem(value: "perempuan", child: Text("Perempuan")),
        ],
        onChanged: (value) {
          setState(() {
            selectedJenisKelamin = value;
          });
        },
        validator: (value) => value == null ? "Pilih jenis kelamin" : null,
      ),
    );
  }

  Widget _buildTanggalField(
      BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Tanggal Lahir",
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              _rawTanggalLahir = DateFormat('dd-MM-yyyy').format(picked);
              controller.text =
                  DateFormat('dd MMMM yyyy', 'en_US').format(picked);
            });
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Pilih tanggal" : null,
      ),
    );
  }
}
