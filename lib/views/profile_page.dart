import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilPage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const ProfilPage({super.key, required this.userDetails});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isObscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  late String namaLengkap;
  late String email;
  late String password;
  late String noTelp;
  String? foto;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    namaLengkap = widget.userDetails['nama'];
    email = widget.userDetails['email'];
    password = ''; // Buat field password kosong
    noTelp = widget.userDetails['no_telp'];
    foto = widget.userDetails['foto'] != null
        ? 'http://192.168.43.155:3000/resource/akun/${widget.userDetails['foto']}'
        : null;
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
          backgroundColor: Colors.white,
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
                        namaLengkap,
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
                  hasIcon: true,
                  initialValue: namaLengkap,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    namaLengkap = value!;
                  },
                ),
                buildTextField(
                  labelText: "Alamat Email",
                  placeholder: "Masukkan alamat email",
                  isPasswordTextField: false,
                  hasIcon: false,
                  initialValue: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                buildTextField(
                  labelText: "Nomor Telepon",
                  placeholder: "Masukkan nomor telepon",
                  isPasswordTextField: false,
                  hasIcon: false,
                  initialValue: noTelp,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Masukkan nomor telepon yang valid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    noTelp = value!;
                  },
                ),
                buildTextField(
                  labelText: "Ganti Password",
                  placeholder: "Masukkan password baru",
                  isPasswordTextField: true,
                  hasIcon: true,
                  initialValue: password,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password harus terdiri dari minimal 6 karakter';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
    String? initialValue,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        initialValue: initialValue,
        decoration: InputDecoration(
          suffixIcon: hasIcon
              ? IconButton(
                  icon: Icon(
                    isPasswordTextField
                        ? isObscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility
                        : null,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    if (isPasswordTextField) {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    }
                  },
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 15),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');
    final userId = widget.userDetails['id'];

    if (accessToken != null) {
      final updatedUserDetails =
          await ApiService.getAccountDetails(userId, accessToken);
      if (updatedUserDetails != null) {
        setState(() {
          widget.userDetails['nama'] = updatedUserDetails['nama'];
          widget.userDetails['email'] = updatedUserDetails['email'];
          widget.userDetails['no_telp'] = updatedUserDetails['no_telp'];
          // Update foto jika diperlukan
          if (updatedUserDetails['foto'] != null) {
            widget.userDetails['foto'] =
                'http://192.168.43.155:3000/resource/akun/${updatedUserDetails['foto']}';
          }
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      final userId = widget.userDetails['id'];
      final response = await ApiService.updateProfile(
        userId: userId,
        namaLengkap: namaLengkap,
        email: email,
        noTelp: noTelp,
        password: password.isNotEmpty ? password : null,
        foto: foto,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        await _fetchUserDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');

    if (accessToken != null) {
      try {
        final response = await ApiService.logout(accessToken);

        if (response.statusCode == 200) {
          // Hapus token dari SharedPreferences setelah logout berhasil
          prefs.remove('token');

          // Tampilkan snackbar untuk pesan berhasil logout
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout berhasil')),
          );

          // Navigasi ke halaman login dan hapus semua rute lain di dalam stack
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else {
          // Tampilkan snackbar untuk pesan gagal logout jika status code bukan 200
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal logout')),
          );
        }
      } catch (e) {
        print('Error: $e');
        // Tampilkan snackbar untuk pesan terjadi kesalahan jika terjadi exception
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan')),
        );
      }
    } else {
      // Jika token tidak ada, langsung navigasi ke halaman login
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }
}
