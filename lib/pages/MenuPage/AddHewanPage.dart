import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadopt/bloc/hewan/hewan_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MenuPage/KatalogPage.dart';

class AddHewanPage extends StatefulWidget {
  @override
  State<AddHewanPage> createState() => _AddHewanPageState();
}

class _AddHewanPageState extends State<AddHewanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  bool _isLoadingDialogVisible = false;
  bool _navigated = false;

  String? _selectedKelamin;
  String? _selectedJenis;
  String? _selectedStatus;
  File? _imageFile;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null ||
          _selectedKelamin == null ||
          _selectedJenis == null ||
          _selectedStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lengkapi semua field dan gambar")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menyimpan data hewan...")),
      );

      context.read<HewanBloc>().add(
            AddHewanEvent(
              imageFile: _imageFile!,
              nama: _namaController.text,
              jenisKelamin: _selectedKelamin!,
              warna: _warnaController.text,
              jenisHewan: _selectedJenis!,
              umur: _umurController.text,
              status: _selectedStatus!,
              lokasi: _lokasiController.text,
              deskripsi: _deskripsiController.text,
            ),
          );
    }
  }

  void _showLoadingDialog() {
    if (!_isLoadingDialogVisible && context.mounted) {
      _isLoadingDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _hideLoadingDialog() {
    if (_isLoadingDialogVisible && context.mounted) {
      _isLoadingDialogVisible = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Hewan",
          style: TextStyle(color: Colors.white), // Judul putih
        ),
        backgroundColor: ColorConfig.mainbabyblue,
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back icon putih
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const KatalogPage()),
            );
          },
        ),
      ),
      body: BlocListener<HewanBloc, HewanState>(
        listener: (context, state) {
          print("Listener menerima state: $state");

          if (state is HewanLoading &&
              !_isLoadingDialogVisible &&
              !_navigated) {
            _showLoadingDialog();
          }

          if (state is HewanSuccess && !_navigated) {
            _navigated = true;
            _hideLoadingDialog();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added successfully")),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const KatalogPage()),
            );
          }

          if (state is HewanError) {
            _hideLoadingDialog();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _imageFile == null ? Colors.white : Colors.blue,
                        width: 2,
                      ),
                      boxShadow: _imageFile == null
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt_outlined,
                                  size: 50, color: Colors.blueAccent),
                              SizedBox(height: 8),
                              Text(
                                "Tap to upload photo",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextInput(
                  label: "Nama Hewan",
                  controller: _namaController,
                  validatorMsg: "Nama tidak boleh kosong",
                ),
                const SizedBox(height: 16),
                _buildDropdown<String>(
                  label: "Jenis Kelamin",
                  value: _selectedKelamin,
                  items: [
                    DropdownMenuItem(value: 'jantan', child: Text('Jantan')),
                    DropdownMenuItem(value: 'betina', child: Text('Betina')),
                  ],
                  hint: "Pilih jenis kelamin",
                  onChanged: (val) => setState(() => _selectedKelamin = val),
                  validatorMsg: "Pilih jenis kelamin",
                ),
                const SizedBox(height: 16),
                _buildTextInput(
                  label: "Warna",
                  controller: _warnaController,
                  validatorMsg: "Warna tidak boleh kosong",
                ),
                const SizedBox(height: 16),
                _buildDropdown<String>(
                  label: "Jenis Hewan",
                  value: _selectedJenis,
                  items: [
                    DropdownMenuItem(value: 'kucing', child: Text('Kucing')),
                    DropdownMenuItem(value: 'anjing', child: Text('Anjing')),
                  ],
                  hint: "Pilih jenis hewan",
                  onChanged: (val) => setState(() => _selectedJenis = val),
                  validatorMsg: "Pilih jenis hewan",
                ),
                const SizedBox(height: 16),
                _buildTextInput(
                  label: "Umur",
                  controller: _umurController,
                  keyboardType: TextInputType.number,
                  validatorMsg: "Umur tidak boleh kosong",
                ),
                const SizedBox(height: 16),
                _buildDropdown<String>(
                  label: "Status",
                  value: _selectedStatus,
                  items: [
                    DropdownMenuItem(
                        value: 'tersedia', child: Text('Tersedia')),
                    DropdownMenuItem(
                        value: 'tidak tersedia', child: Text('Tidak Tersedia')),
                  ],
                  hint: "Pilih status hewan",
                  onChanged: (val) => setState(() => _selectedStatus = val),
                  validatorMsg: "Pilih status",
                ),
                const SizedBox(height: 16),
                _buildTextInput(
                  label: "Lokasi",
                  controller: _lokasiController,
                  validatorMsg: "Lokasi tidak boleh kosong",
                ),
                const SizedBox(height: 16),
                _buildTextInput(
                  label: "Deskripsi",
                  controller: _deskripsiController,
                  maxLines: 4,
                  validatorMsg: "Deskripsi tidak boleh kosong",
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    String? validatorMsg,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? validatorMsg : null,
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required String hint,
    required void Function(T?) onChanged,
    required String validatorMsg,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      hint: Text(hint),
      items: items,
      onChanged: onChanged,
      validator: (value) => value == null ? validatorMsg : null,
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _warnaController.dispose();
    _umurController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }
}
