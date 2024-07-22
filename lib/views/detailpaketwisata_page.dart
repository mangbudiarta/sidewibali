import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidewibali/models/informasi_model.dart';
import 'package:sidewibali/models/paketwisata_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/widgets/informasi_kontak.dart';

class DetailPaketwisata extends StatefulWidget {
  final PaketWisata paketWisata;
  final String? namadesa;

  DetailPaketwisata({
    super.key,
    required this.paketWisata,
    required this.namadesa,
  });

  @override
  _DetailPaketwisataState createState() => _DetailPaketwisataState();
}

class _DetailPaketwisataState extends State<DetailPaketwisata> {
  late Future<InformasiKontak> _informasiKontak;

  @override
  void initState() {
    super.initState();
    _informasiKontak =
        ApiService().fetchInformasiKontak(widget.paketWisata.idDesawisata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  "http://192.168.43.155:3000/resource/paketwisata/${widget.paketWisata.gambar}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 400,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      height: 400,
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
                        Navigator.pop(context);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.paketWisata.nama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp. ${widget.paketWisata.harga}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.namadesa ?? 'Desa Tidak Diketahui',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.paketWisata.deskripsi,
                    style: const TextStyle(fontSize: 16),
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
                              'Informasi Paket Wisata',
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
