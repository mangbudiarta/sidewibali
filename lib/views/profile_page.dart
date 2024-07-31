import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isObscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaLengkapController;
  late TextEditingController _emailController;
  late TextEditingController _noTelpController;
  late TextEditingController _passwordController;
  String? foto;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaLengkapController = TextEditingController();
    _emailController = TextEditingController();
    _noTelpController = TextEditingController();
    _passwordController = TextEditingController();
    _fetchAkunDetails();
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _noTelpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchAkunDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      if (userId != null) {
        final userDetails = await ApiService.fetchAkunDetail(userId);

        setState(() {
          _namaLengkapController.text = userDetails['nama'] ?? '';
          _emailController.text = userDetails['email'] ?? '';
          _noTelpController.text = userDetails['no_telp'] ?? '';
          _passwordController.text = '';
          foto = userDetails['foto'] != null
              ? 'http://8.215.11.162:3000/resource/akun/${userDetails['foto']}'
              : null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        foto = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: _imageFile != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_imageFile!),
                                )
                              : (foto != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(foto!),
                                    )
                                  : null),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 45,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 0),
                      Text(
                        _namaLengkapController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField(
                  labelText: "Nama Lengkap",
                  placeholder: "Masukkan nama lengkap",
                  isPasswordTextField: false,
                  hasIcon: false,
                  controller: _namaLengkapController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  labelText: "Alamat Email",
                  placeholder: "Masukkan alamat email",
                  isPasswordTextField: false,
                  hasIcon: false,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  labelText: "Nomor Telepon",
                  placeholder: "Masukkan nomor telepon",
                  isPasswordTextField: false,
                  hasIcon: false,
                  controller: _noTelpController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Masukkan nomor telepon yang valid';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  labelText: "Ganti Password",
                  placeholder: "Masukkan password baru",
                  isPasswordTextField: true,
                  hasIcon: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password harus terdiri dari minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _updateProfile(); // Panggil fungsi update profile
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Simpan"),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      _showLogoutConfirmationDialog();
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String labelText,
    required String placeholder,
    required bool isPasswordTextField,
    required bool hasIcon,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: hasIcon
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                  icon: Icon(
                    isObscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      if (userId != null) {
        Map<String, dynamic> data = {
          'id': userId,
          'nama': _namaLengkapController.text,
          'email': _emailController.text,
          'no_telp': _noTelpController.text,
        };

        // Tambahkan password jika diisi
        if (_passwordController.text.isNotEmpty) {
          data['password'] = _passwordController.text;
        }

        // Tambahkan foto jika dipilih
        if (_imageFile != null) {
          data['foto'] = _imageFile!.path;
        }

        // Panggil API update
        final response = await ApiService.updateAkun(data);

        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          // Muat ulang data profil
          _fetchAkunDetails();
        } else {
          throw Exception(response['message'] ?? 'Gagal memperbarui profil');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
