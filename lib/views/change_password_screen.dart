import 'package:flutter/material.dart';
import 'edit_profile_ui.dart'; // Pastikan untuk mengimpor halaman EditProfileUI

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Implementasi tombol kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Image.asset(
                'assets/logo_sidewi.png',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Ganti Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildPasswordField(
                      'Password Lama',
                      _obscureOldPassword,
                      () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPasswordField(
                      'Password Baru',
                      _obscureNewPassword,
                      () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPasswordField(
                      'Ketik Ulang Password Baru',
                      _obscureConfirmPassword,
                      () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          // Implement password change functionality here
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileUI(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Ganti Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, bool obscureText, VoidCallback toggleObscureText) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleObscureText,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan masukkan $labelText';
        }
        return null;
      },
    );
  }
}
