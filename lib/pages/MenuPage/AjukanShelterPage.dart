import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart'; // Untuk mendeteksi tipe file
import 'package:petadopt/bloc/Pengajuan Shelter/shelter_bloc.dart';
import 'package:petadopt/bloc/Pengajuan Shelter/shelter_event.dart';
import 'package:petadopt/bloc/Pengajuan Shelter/shelter_state.dart';
import 'package:petadopt/pages/MenuPage/ProfilePage.dart';

class AjukanShelterPage extends StatefulWidget {
  @override
  State<AjukanShelterPage> createState() => _AjukanShelterPageState();
}

class _AjukanShelterPageState extends State<AjukanShelterPage> {
  File? selectedFile;
  bool isImage = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final mimeType = lookupMimeType(file.path);

      setState(() {
        selectedFile = file;
        isImage = mimeType != null && mimeType.startsWith('image/');
      });
    }
  }

  void submit() {
    if (selectedFile != null) {
      context.read<ShelterBloc>().add(
            UploadShelterRequestEvent(selectedFile!),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih file terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pengajuan Shelter", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: BlocConsumer<ShelterBloc, ShelterState>(
        listener: (context, state) {
          if (state is ShelterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(state.response.message ?? 'Berhasil diajukan!')),
            );
            setState(() => selectedFile = null);

            // ⬇️ Navigasi ke halaman Profile
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Profilepage()),
              );
            });

          } else if (state is ShelterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Bagian atas scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),

                          // 🏠 Icon rumah shelter
                          Icon(Icons.home, size: 80, color: Colors.blue),

                          const SizedBox(height: 12),

                          // 📝 Judul halaman
                          const Text(
                            'Pengajuan Shelter',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          // 📝 Deskripsi bawah judul
                          const Text(
                            'Ajukan tempatmu sebagai shelter resmi\nuntuk hewan adopsi',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),

                          const SizedBox(height: 30),

                          // 📁 Kotak upload file
                          GestureDetector(
                            onTap: pickFile,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedFile == null
                                      ? Colors.grey
                                      : Colors.blue,
                                  width: 2,
                                ),
                                boxShadow: selectedFile == null
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: selectedFile == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.file_upload_outlined,
                                            size: 50, color: Colors.blueAccent),
                                        SizedBox(height: 8),
                                        Text(
                                          "Tap untuk unggah gambar / PDF",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  : isImage
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.file(
                                            selectedFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              selectedFile!.path
                                                  .split('/')
                                                  .last,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // 📤 Tombol "Ajukan Sekarang" di bawah
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: state is ShelterLoading ? null : submit,
                        child: state is ShelterLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Ajukan Sekarang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
