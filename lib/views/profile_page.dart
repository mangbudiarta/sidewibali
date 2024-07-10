import 'package:flutter/material.dart';
import 'package:sidewibali/utils/colors.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isObscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  String namaLengkap = "Dodek Alit";
  String email = "dodekalit@gmail.com";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
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
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://cdn.pixabay.com/photo/2017/05/31/04/59/beautiful-2359121_1280.jpg',
                            ),
                          ),
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
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 0),
                      Text(
                        'Dodek Alit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                  labelText: "Ganti Password",
                  placeholder: "Masukkan password baru",
                  isPasswordTextField: true,
                  hasIcon: true,
                  initialValue: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password harus terdiri dari minimal 6 karakter';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profil berhasil disimpan')),
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showLogoutConfirmationDialog();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
    required String initialValue,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
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
                    isPasswordTextField ? Icons.visibility : Icons.create,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    if (isPasswordTextField) {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    } else {
                      Navigator.pushNamed(context, '/edit_password');
                    }
                  },
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
