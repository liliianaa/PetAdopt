import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petadopt/bloc/Profile/profile_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:petadopt/pages/MenuPage/MyProfilePage.dart';

class Editprofilepage extends StatefulWidget {
  const Editprofilepage({super.key});

  @override
  State<Editprofilepage> createState() => _EditprofilepageState();
}

class _EditprofilepageState extends State<Editprofilepage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tgl_lahirController = TextEditingController();
  final _no_telpController = TextEditingController();
  final _emailController = TextEditingController();

  String? selectjenis_kelamin;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>()..add(GetProfileDetailEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _no_telpController.dispose();
    _tgl_lahirController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is UpdateProfileEvent) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileSuccess) {
            final profile = state.profiledata ?? {};
            _nameController.text = profile?['name'] ?? '';
            if (profile['tgl_lahir'] != null) {
              try {
                final parsedDate =
                    DateFormat('yyyy-MM-dd').parse(profile['tgl_lahir']);
                _tgl_lahirController.text =
                    DateFormat('dd / MM / yyyy').format(parsedDate);
              } catch (e) {
                print('Error parsing tgl_lahir: $e');
                _tgl_lahirController.text = '';
              }
            } else {
              _tgl_lahirController.text = '';
            }
            _no_telpController.text = profile['no_telp'] ?? '';
            _emailController.text = profile['email'] ?? '';
            if (selectjenis_kelamin == null) {
              selectjenis_kelamin = profile['jenis_kelamin'];
            }
          }
          return Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/anjing1.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(Icons.edit,
                          color: ColorConfig.mainblue1, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorConfig.mainwhite,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('Nama Lengkap', _nameController),
                        const SizedBox(height: 12),
                        _builddatefiels(
                            context, 'Tanggal lahir', _tgl_lahirController),
                        const SizedBox(height: 12),
                        _buildDropdown('Jenis Kelamin'),
                        const SizedBox(height: 12),
                        _buildTextField('Nomor Telepon', _no_telpController,
                            keyboardtype: TextInputType.phone),
                        const SizedBox(height: 12),
                        _buildTextField('Email', _emailController,
                            keyboardtype: TextInputType.emailAddress),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleUpdateProfile(context);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Myprofilepage()));
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
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardtype = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _builddatefiels(
      BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4FF),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now());
            if (picked != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
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
          value: selectjenis_kelamin,
          hint: const Text("Pilih jenis kelamin"),
          items: const [
            DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
            DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
          ],
          onChanged: (value) {
            setState(() {
              selectjenis_kelamin = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) =>
              value == null ? 'Jenis kelamin wajib dipilih' : null,
        ),
      ],
    );
  }

  void _handleUpdateProfile(BuildContext context) {
    // Validasi Jenis Kelamin
    if (selectjenis_kelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jenis kelamin wajib dipilih.')),
      );
      return;
    }

    // Validasi Tanggal Lahir
    if (_tgl_lahirController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir wajib diisi.')),
      );
      return;
    }

    // Parsing Tanggal Lahir
    DateTime parsedDate;
    try {
      parsedDate = DateFormat('yyyy-MM-dd').parse(_tgl_lahirController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tanggal lahir tidak valid.')),
      );
      return;
    }

    // Format Tanggal ke yyyy-MM-dd
    final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    // Dispatch event ke Bloc
    context.read<ProfileBloc>().add(UpdateProfileEvent(
          name: _nameController.text,
          tgl_lahir: formattedDate,
          jenis_kelamin: selectjenis_kelamin!,
          no_telp: _no_telpController.text,
          email: _emailController.text,
        ));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Myprofilepage()));
  }
}
