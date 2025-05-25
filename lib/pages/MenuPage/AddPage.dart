// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// import 'package:petadopt/config/ColorConfig.dart';
// import 'package:petadopt/pages/MainPage.dart';

// class AddPage extends StatefulWidget {
//   const AddPage({super.key});

//   @override
//   State<AddPage> createState() => _AddPageState();
// }

// class _AddPageState extends State<AddPage> {
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController warnaController = TextEditingController();
//   final TextEditingController jenisController = TextEditingController();
//   final TextEditingController deskripsiController = TextEditingController();
//   String? jenisKelamin;

//   File? _selectedImage; // untuk menyimpan file gambar yang dipilih

//   Future<void> pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _selectedImage = File(result.files.single.path!);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: ColorConfig.mainblue),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => MainPage()),
//             );
//           },
//         ),
//         title: const Text(
//           "Tambah Hewan",
//           style: TextStyle(
//             color: ColorConfig.mainblue,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildImageUpload(),
//               const SizedBox(height: 20),
//               _buildTextField(
//                   "Nama Hewan", "Masukkan nama hewan", namaController),
//               const SizedBox(height: 16),
//               _buildDropdown("Jenis Kelamin", ["Jantan", "Betina"]),
//               const SizedBox(height: 16),
//               _buildTextField("Warna", "Warna hewan", warnaController),
//               const SizedBox(height: 16),
//               _buildTextField(
//                   "Jenis Hewan", "Contoh: Kucing, Anjing", jenisController),
//               const SizedBox(height: 16),
//               _buildTextArea("Deskripsi", deskripsiController),
//               const SizedBox(height: 24),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageUpload() {
//     return GestureDetector(
//       onTap: pickImage, // panggil fungsi pickImage saat ditekan
//       child: Container(
//         height: 150,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(12),
//           image: _selectedImage != null
//               ? DecorationImage(
//                   image: FileImage(_selectedImage!),
//                   fit: BoxFit.cover,
//                 )
//               : null,
//         ),
//         child: _selectedImage == null
//             ? const Center(
//                 child: Icon(Icons.camera_alt, size: 40, color: Colors.blue),
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, String hint, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             contentPadding: const EdgeInsets.all(12),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown(String label, List<String> options) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: jenisKelamin,
//           decoration: InputDecoration(
//             hintText: "Pilih jenis kelamin",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             contentPadding: const EdgeInsets.all(12),
//           ),
//           items: options.map((value) {
//             return DropdownMenuItem(value: value, child: Text(value));
//           }).toList(),
//           onChanged: (value) {
//             setState(() => jenisKelamin = value);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTextArea(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           maxLines: 4,
//           decoration: InputDecoration(
//             hintText: "Tuliskan deskripsi...",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             contentPadding: const EdgeInsets.all(12),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           // Logika simpan data, bisa kirim _selectedImage.path ke backend / simpan lokal
//           print("Data disimpan:");
//           print("Nama: ${namaController.text}");
//           print("Jenis Kelamin: $jenisKelamin");
//           print("Warna: ${warnaController.text}");
//           print("Jenis: ${jenisController.text}");
//           print("Deskripsi: ${deskripsiController.text}");
//           print("Path Gambar: ${_selectedImage?.path ?? 'Belum pilih gambar'}");
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: const Text("Simpan", style: TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
