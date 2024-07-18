import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidewibali/models/desa_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailDesa extends StatefulWidget {
  final DesaWisata desa;

  const DetailDesa({super.key, required this.desa});

  @override
  _DetailDesaState createState() => _DetailDesaState();
}

class _DetailDesaState extends State<DetailDesa> {
  int likeCount = 120;
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _share() {
    Clipboard.setData(const ClipboardData(text: "Link berbagi: https://google.com"))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Link telah disalin ke clipboard"),
      ));
    });
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(widget.desa.kategori),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: _share,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.desa.nama,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Kabupaten ${widget.desa.kabupaten}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Flexible(
                        child: BarisInfoKontak(
                          icon: Icons.phone,
                          text: '083 123 123 123',
                        ),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: BarisInfoKontak(
                          icon: Icons.email,
                          text: 'admin@candikuning.id',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Flexible(
                        child: BarisInfoKontak(
                          icon: Icons.web,
                          text: 'candikuning.id',
                        ),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: BarisInfoKontak(
                          icon: Icons.photo_camera,
                          text: '@desacandikuning',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
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
                      launchMaps();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 215, 208),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
                      children: const [
                        WisataCard(
                          imageUrl:
                              'https://www.rentalmobilbali.net/wp-content/uploads/2021/12/Bali-Botanic-Garden.jpg',
                          title: 'Kebun Raya Bedugul',
                        ),
                        WisataCard(
                          imageUrl: 'assets/images/beratan.png',
                          title: 'Danau Beratan',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvMRWTGtqJXGGaCHg1s_ughBqwhqxKv1R7Pw&s',
                          title: 'The Blooms Garden',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCE5g-h-yDlVFKnn1yNPIj3fUDoiN9ZD-V8zeysUU27a6hn3ESE4b0Z_N9u9uzMYSnEyk&usqp=CAU',
                          title: 'The Silas',
                        ),
                      ],
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
                      children: const [
                        WisataCard(
                          imageUrl: 'assets/images/beratan.png',
                          title: 'Hotel De Danau Lake View',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://cf2.bstatic.com/xdata/images/hotel/max1280x900/335858204.jpg?k=5f6312589836fe276b5c2cdfb87998b6054a7018a59d4ce4a4e3ca1d9c00d548&o=&hp=1',
                          title: 'Villa Sinta',
                        ),
                        WisataCard(
                          imageUrl: 'assets/images/beratan.png',
                          title: 'CLV Hotel & Villa',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://cf.bstatic.com/xdata/images/hotel/max1024x768/432052930.jpg?k=f7a7b48e87279dbc36822bc186d7d19c4c0867421aa1e72cfc0bed1898b727fb&o=&hp=1',
                          title: 'Diamond Glamping Bedugul',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/0e/d5/34/img20170728175103-01.jpg?w=700&h=-1&s=1',
                          title: 'Enjung Beji Resort',
                        ),
                      ],
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
                      children: const [
                        WisataCard(
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpyWgTHCmZBIbI4jUf8sNRKFGP3QeMzhJB-Q&s',
                          title: 'Desa Wisata Pinge',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://awsimages.detik.net.id/community/media/visual/2023/09/25/menyusuri-desa-penglipuran-bali-yang-dinobatkan-terbersih-di-dunia-3_169.jpeg?w=600&q=90',
                          title: 'Desa Wisata Penglipuran',
                        ),
                        WisataCard(
                          imageUrl: 'assets/images/ubud.png',
                          title: 'Desa Wisata Penarungan',
                        ),
                        WisataCard(
                          imageUrl: 'assets/images/kuta.png',
                          title: 'Desa Wisata Petang',
                        ),
                        WisataCard(
                          imageUrl:
                              'https://awsimages.detik.net.id/community/media/visual/2022/11/13/desa-wisata-tenganan-pegringsingan-yang-terletak-di-kecamatan-manggis-kabupaten-karangasem-foto-i-wayan-selamat-juniasa.jpeg?w=600&q=90',
                          title: 'Desa Wisata Tenganan',
                        ),
                      ],
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

void launchMaps() async {
  String googleMapsUrl = 'https://maps.app.goo.gl/xGL3vky1GxuW2a7Y9';

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    throw 'Could not launch $googleMapsUrl';
  }
}

class WisataCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const WisataCard({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class BarisInfoKontak extends StatelessWidget {
  final IconData icon;
  final String text;

  const BarisInfoKontak({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
