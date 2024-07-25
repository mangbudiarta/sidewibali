import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidewibali/models/berita_model.dart';
import 'package:sidewibali/utils/colors.dart';

// Stateless widget untuk menampilkan detail berita
class DetailBerita extends StatelessWidget {
  final Berita berita;

  // Konstruktor untuk menginisialisasi widget DetailBerita dengan objek Berita yang wajib
  const DetailBerita({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Mendapatkan ukuran layar

    // Format tanggal dari berita
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    final String formattedDate = dateFormat.format(berita.createdAt);

    return Scaffold(
      backgroundColor: white, // Mengatur warna latar belakang menjadi putih
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Menampilkan gambar dari berita
                Image.network(
                  "http://192.168.18.24:3000/resource/berita/${berita.gambar}",
                  height: 400,
                  fit: BoxFit.cover,
                  // Menangani kesalahan saat memuat gambar
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      height: 400,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // Widget Positioned untuk menempatkan tombol kembali
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors
                          .white, // Mengatur warna latar belakang menjadi putih
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Warna bayangan
                          blurRadius: 6.0, // Radius blur bayangan
                          offset: Offset(0, 2), // Offset bayangan
                        ),
                      ],
                    ),
                    // Tombol IconButton untuk navigasi kembali
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(
                  screenSize.width * 0.05), // Padding berdasarkan lebar layar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Menampilkan judul berita
                  Text(
                    berita.judul,
                    style: const TextStyle(
                      fontSize: 24.0, // Ukuran font
                      fontWeight: FontWeight.bold, // Ketebalan font
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Menampilkan tanggal berita yang telah diformat
                  Text(
                    '$formattedDate',
                    style: const TextStyle(
                      fontSize: 14.0, // Ukuran font
                      color: Colors.grey, // Warna font
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Menampilkan isi berita
                  Text(
                    berita.isiBerita,
                    style: const TextStyle(fontSize: 16.0), // Ukuran font
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
