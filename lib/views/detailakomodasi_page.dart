import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidewibali/models/akomodasi_model.dart';
import 'package:sidewibali/models/desawisata_model.dart';
import 'package:sidewibali/models/informasi_model.dart'; // Import model InformasiKontak
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/widgets/informasi_kontak.dart';

class DetailAkomodasi extends StatefulWidget {
  final Akomodasi akomodasi;

  const DetailAkomodasi({super.key, required this.akomodasi});

  @override
  _DetailAkomodasiState createState() => _DetailAkomodasiState();
}

class _DetailAkomodasiState extends State<DetailAkomodasi> {
  late Future<InformasiKontak> _informasiKontak;
  late Future<String> _namaDesa;

  @override
  void initState() {
    super.initState();
    _informasiKontak =
        ApiService().fetchInformasiKontak(widget.akomodasi.id_desawisata);
    _namaDesa = ApiService().fetchNamaDesa(widget.akomodasi.id_desawisata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  "http://192.168.18.24:3000/resource/akomodasi/${widget.akomodasi.gambar}",
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/default_image.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          widget.akomodasi.kategori,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.akomodasi.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<String>(
                    future: _namaDesa,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              snapshot.data!,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Desa Tidak Diketahui');
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<InformasiKontak>(
                    future: _informasiKontak,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final kontak = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Informasi AKomodasi',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.envelope,
                                    text: kontak.email,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.globe,
                                    text: kontak.website,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.phone,
                                    text: kontak.noTelp,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.instagram,
                                    text: kontak.instagram,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.whatsapp,
                                    text: kontak.noWa,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: BarisInfoKontak(
                                    icon: FontAwesomeIcons.facebook,
                                    text: kontak.facebook,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const Text('Informasi Kontak Tidak Diketahui');
                      }
                    },
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
