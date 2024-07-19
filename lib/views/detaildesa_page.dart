import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidewibali/models/akomodasi_model.dart';
import 'package:sidewibali/models/desawisata_model.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/informasi_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/views/detailakomodasi_page.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/widgets/informasi_kontak.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailDesa extends StatefulWidget {
  final DesaWisata desa;

  const DetailDesa({super.key, required this.desa});

  @override
  _DetailDesaState createState() => _DetailDesaState();
}

class _DetailDesaState extends State<DetailDesa> {
  final ApiService apiService = ApiService();
  int likeCount = 120;
  bool isLiked = false;

  String email = '';
  String website = '';
  String noTelp = '';
  String instagram = '';
  String facebook = '';
  String noWa = '';

  List<Destinasi> destinasiWisata = [];
  List<Akomodasi> akomodasi = [];
  List<DesaWisata> desaWisataLainnya = [];

  @override
  void initState() {
    super.initState();
    _fetchInformasiKontak(widget.desa.id);
    _fetchDestinasiWisata(widget.desa.id);
    _fetchAkomodasi(widget.desa.id);
    _fetchDesaWisataLainnya();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _share(String linkWebsite) {
    Clipboard.setData(ClipboardData(text: linkWebsite)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Link telah disalin ke clipboard"),
      ));
    });
  }

  void _launchMaps(String mapsUrl) async {
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not launch $mapsUrl';
    }
  }

  Future<void> _fetchInformasiKontak(int idDesaWisata) async {
    try {
      final data = await apiService.fetchInformasiKontak(idDesaWisata);
      setState(() {
        email = data.email;
        website = data.website;
        noTelp = data.noTelp;
        instagram = data.instagram;
        facebook = data.facebook;
        noWa = data.noWa;
      });
    } catch (e) {
      print(e);
      // Handle error here
    }
  }

  Future<void> _fetchDestinasiWisata(int idDesaWisata) async {
    try {
      final data = await apiService.fetchDestinasiWisata(idDesaWisata);
      print("Destinasi Wisata Data: $data"); // Cetak data
      setState(() {
        destinasiWisata = data;
      });
    } catch (e) {
      print("Error fetching Destinasi Wisata: $e");
    }
  }

  Future<void> _fetchAkomodasi(int idDesaWisata) async {
    try {
      final data = await apiService.fetchAkomodasi(idDesaWisata);
      print("Akomodasi Data: $data"); // Cetak data
      setState(() {
        akomodasi = data;
      });
    } catch (e) {
      print("Error fetching Akomodasi: $e");
    }
  }

  Future<void> _fetchDesaWisataLainnya() async {
    try {
      final data = await apiService.fetchDesaWisataList();
      setState(() {
        desaWisataLainnya = data;
      });
    } catch (e) {
      print(e);
      // Handle error here
    }
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
                  "http://192.168.43.155:3000/resource/desawisata/${widget.desa.gambar}",
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: _toggleLike,
                        ),
                        const SizedBox(width: 4),
                        Text('$likeCount Suka'),
                      ],
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
                        child: Text(widget.desa.kategori),
                      ),
                      const Spacer(),
                      IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            _share(website);
                          }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.desa.nama,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.desa.kabupaten,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kontak',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: BarisInfoKontak(
                          icon: FontAwesomeIcons.envelope,
                          text: email,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: BarisInfoKontak(
                          icon: FontAwesomeIcons.globe,
                          text: website,
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
                          text: noTelp,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: BarisInfoKontak(
                          icon: FontAwesomeIcons.instagram,
                          text: instagram,
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
                          text: noWa,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: BarisInfoKontak(
                          icon: FontAwesomeIcons.facebook,
                          text: facebook,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tentang Desa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.desa.deskripsi,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lokasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _launchMaps(widget.desa.maps);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 215, 208),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Buka Maps'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Destinasi Wisata',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: destinasiWisata
                          .map((destinasi) => WisataCard(
                                imageUrl:
                                    'http://192.168.43.155:3000/resource/destinasiwisata/${destinasi.gambar}',
                                title: destinasi.nama,
                                destinasi: destinasi,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Akomodasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: akomodasi
                          .map((akomodasi) => AkomodasiCard(
                                imageUrl:
                                    'http://192.168.43.155:3000/resource/akomodasi/${akomodasi.gambar}',
                                title: akomodasi.nama,
                                akomodasi: akomodasi,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Desa Wisata Lainnya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: desaWisataLainnya
                          .map((desa) => DesaCard(
                                imageUrl:
                                    'http://192.168.43.155:3000/resource/desawisata/${desa.gambar}',
                                title: desa.nama,
                                desa: desa,
                              ))
                          .toList(),
                    ),
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

class DesaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final DesaWisata desa;

  const DesaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.desa,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDesa(desa: desa),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 150,
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
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class WisataCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Destinasi destinasi;

  const WisataCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.destinasi,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDestinasi(
              destinasi: destinasi,
            ), // Navigasi ke DetailAkomodasi
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 150,
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
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AkomodasiCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Akomodasi akomodasi; // Tambahkan parameter ini

  const AkomodasiCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.akomodasi, // Tambahkan parameter ini
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAkomodasi(
                akomodasi: akomodasi), // Navigasi ke DetailAkomodasi
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 150,
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
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
