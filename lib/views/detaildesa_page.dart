import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidewibali/models/desa.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailDesa extends StatefulWidget {
  final DesaWisata desa;

  DetailDesa({required this.desa});

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
    Clipboard.setData(ClipboardData(text: "Link berbagi: https://google.com"))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                Image.asset(
                  widget.desa.gambar,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        SizedBox(width: 4),
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
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(widget.desa.kategori),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: _share,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.desa.nama,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Kabupaten ${widget.desa.kabupaten}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: BarisInfoKontak(
                          icon: Icons.phone,
                          text: '083 123 123 123',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: BarisInfoKontak(
                          icon: Icons.email,
                          text: 'admin@candikuning.id',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: BarisInfoKontak(
                          icon: Icons.web,
                          text: 'candikuning.id',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: BarisInfoKontak(
                          icon: Icons.photo_camera,
                          text: '@desacandikuning',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.desa.deskripsi,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lokasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      launchMaps();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 2, 215, 208),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    child: Text('Buka Maps'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Destinasi Wisata',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
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
                  SizedBox(height: 16),
                  Text(
                    'Akomodasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
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
                  SizedBox(height: 16),
                  Text(
                    'Desa Wisata Lainnya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
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

  WisataCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
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
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BarisInfoKontak extends StatelessWidget {
  final IconData icon;
  final String text;

  BarisInfoKontak({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
