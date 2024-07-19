import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/paketwisata_model.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/views/listdesa_page.dart';
import 'package:sidewibali/views/listdestinasi_page.dart';
import 'package:sidewibali/views/listpaketwisata_page.dart';
import 'package:sidewibali/views/listproduk_page.dart';
import 'package:sidewibali/views/listulasan_page.dart';
import 'package:sidewibali/views/listberita_page.dart';
import 'package:sidewibali/views/listakomodasi_page.dart';
import 'package:sidewibali/widgets/recommendation_card.dart';
import 'package:sidewibali/views/favorite_page.dart';
import 'package:sidewibali/views/notification_page.dart';
import 'package:sidewibali/views/profile_page.dart';
import 'package:sidewibali/views/website_page.dart';
import 'package:sidewibali/widgets/menu_item.dart';
import 'package:sidewibali/views/detailpaketwisata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// class PaketWisata {
//   final String gambar;
//   final String nama;
//   final int harga;

//   PaketWisata({
//     required this.gambar,
//     required this.nama,
//     required this.harga,
//   });
// }

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Destinasi> _recommendedPlaces = [];
  List<PaketWisata> _paketWisataList = [];
  List<String> _carouselImages = [];

  Map<int, String> kategoriMap = {
    1: 'Budaya',
    2: 'Alam',
    3: 'Religi',
  };

  Map<int, String> desaMap = {
    1: 'Desa Candikuning',
    2: 'Desa Ubud',
    3: 'Desa Kuta',
  };

  List<String> dummyCarouselImages = [
    'assets/images/beratan.png',
    'assets/images/kuta.png',
    'assets/images/ubud.png',
  ];

  List<Destinasi> dummyRecommendedPlaces = [
    Destinasi(
      gambar: 'assets/images/beratan.png',
      nama: 'Danau Beratan',
      deskripsi:
          'Danau beratan merupakan sebuah destinasi yang ada di desa candikuning. Destinasi ini sering dikunjungi wisatawan',
      id_kategoridestinasi: 3,
      id_desawisata: 1,
    ),
    Destinasi(
      gambar: 'assets/images/ubud.png',
      nama: 'Puri Ubud',
      deskripsi:
          'Puri Ubud merupakan sebuah tempat yang terkenal di Ubud hingga dunia. Puri Ubud merupakan tempat tinggal dari Raja Ubud',
      id_kategoridestinasi: 1,
      id_desawisata: 2,
    ),
    Destinasi(
      gambar: 'assets/images/kuta.png',
      nama: 'Kuta',
      deskripsi: 'Pantai terkenal dengan ombak dan kehidupan malamnya.',
      id_kategoridestinasi: 2,
      id_desawisata: 3,
    ),
  ];

  List<PaketWisata> dummyPaketWisataList = [
    PaketWisata(
      nama: 'Paket Premium',
      harga: 100000,
      deskripsi:
          'Paket yang cocok untuk pengalaman wisata yang berkualitas dengan pelayanan terbaik.',
      id_desawisata: '1',
      gambar: 'assets/images/produk.png',
    ),
    PaketWisata(
      nama: 'Paket Keluarga',
      harga: 50000,
      deskripsi:
          'Paket yang cocok untuk pengalaman wisata yang bersama keluarga dengan harga spesial.',
      id_desawisata: '2',
      gambar: 'assets/images/produk.png',
    ),
    PaketWisata(
      nama: 'Paket Hari Raya',
      harga: 20000,
      deskripsi: 'Paket yang cocok untuk pengalaman wisata saat hari raya.',
      id_desawisata: '3',
      gambar: 'assets/images/produk.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carouselImages = dummyCarouselImages;
    _recommendedPlaces = dummyRecommendedPlaces;
    _paketWisataList = dummyPaketWisataList;
  }

  static List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    FavoritePage(),
    NotificationPage(),
    ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.06),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo_text_max.png',
                  height: screenSize.height * 0.04,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final _homePageState = context.findAncestorStateOfType<_HomePageState>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.07,
              vertical: screenSize.height * 0.02,
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                height: screenSize.height * 0.25,
                autoPlay: true,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
              ),
              items: _homePageState!._carouselImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: screenSize.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(i),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.07,
              vertical: screenSize.height * 0.01,
            ),
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                MenuItem('Desa Wisata', 'assets/icons/desawisata.png',
                    DesaWisataPage()),
                MenuItem(
                    'Destinasi', 'assets/icons/destinasi.png', DestinasiPage()),
                MenuItem('Paket Wisata', 'assets/icons/paketwisata.png',
                    PaketWisataPage()),
                MenuItem(
                    'Akomodasi', 'assets/icons/akomodasi.png', AkomodasiPage()),
                MenuItem('Produk', 'assets/icons/oleholeh.png', ProdukPage()),
                MenuItem('Ulasan', 'assets/icons/ulasan.png', UlasanPage()),
                MenuItem('Website', 'assets/icons/web.png', WebsitePage()),
                MenuItem('Berita', 'assets/icons/berita.png', BeritaPage()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenSize.width * 0.05,
              screenSize.height * 0.01,
              screenSize.width * 0.05,
              screenSize.height * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rekomendasi Destinasi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Column(
                  children: _homePageState._recommendedPlaces.map((place) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailDestinasi(
                              destinasi: place,
                            ),
                          ),
                        );
                      },
                      child: RecommendationCard(
                        gambar: place.gambar,
                        nama: place.nama,
                        id_desawisata:
                            _homePageState.desaMap[place.id_desawisata] ??
                                'Unknown',
                      ),
                    );
                  }).toList(),
                ),
                const Text(
                  'Paket Wisata',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Column(
                  children: _homePageState._paketWisataList.map((paket) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPaketwisata(
                              paketWisata: paket,
                            ),
                          ),
                        );
                      },
                      child: PaketWisataCard(
                        gambar: paket.gambar,
                        nama: paket.nama,
                        harga: paket.harga,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaketWisataCard extends StatelessWidget {
  final String gambar;
  final String nama;
  final int harga;

  const PaketWisataCard({
    required this.gambar,
    required this.nama,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                gambar,
                width: screenSize.width * 0.3,
                height: screenSize.height * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenSize.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'Rp ${harga.toString()}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
