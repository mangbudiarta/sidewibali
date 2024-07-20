import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/views/listdesa_page.dart';
import 'package:sidewibali/views/listdestinasi_page.dart';
import 'package:sidewibali/views/listpaketwisata_page.dart';
import 'package:sidewibali/views/listproduk_page.dart';
import 'package:sidewibali/views/listulasan_page.dart';
import 'package:sidewibali/views/listberita_page.dart';
import 'package:sidewibali/views/listakomodasi_page.dart';
import 'package:sidewibali/views/login_page.dart';
import 'package:sidewibali/widgets/recommendation_card.dart';
import 'package:sidewibali/views/favorite_page.dart';
import 'package:sidewibali/views/notification_page.dart';
import 'package:sidewibali/views/profile_page.dart';
import 'package:sidewibali/views/website_page.dart';
import 'package:sidewibali/widgets/menu_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  int _selectedIndex = 0;
  List<Destinasi> _recommendedPlaces = [];
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
    'assets/images/kuta.png',
  ];

  List<Destinasi> dummyRecommendedPlaces = [
    Destinasi(
      id: 1,
      gambar: 'assets/images/beratan.png',
      nama: 'Danau Beratan',
      deskripsi:
          'Danau beratan merupakan sebuah destinasi yang ada di desa candikuning. Destinasi ini sering dikunjungi wisatawan',
      idKategoridestinasi: 3,
      idDesawisata: 1,
    ),
    Destinasi(
      id: 2,
      gambar: 'assets/images/ubud.png',
      nama: 'Puri Ubud',
      deskripsi:
          'Puri Ubud merupakan sebuah tempat yang terkenal di Ubud hingga dunia. Puri Ubud merupakan tempat tinggal dari Raja Ubud',
      idKategoridestinasi: 1,
      idDesawisata: 2,
    ),
    Destinasi(
      id: 3,
      gambar: 'assets/images/kuta.png',
      nama: 'Kuta',
      deskripsi: 'Pantai terkenal dengan ombak dan kehidupan malamnya.',
      idKategoridestinasi: 2,
      idDesawisata: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carouselImages = dummyCarouselImages;
    _recommendedPlaces = dummyRecommendedPlaces;
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    int? userId = preferences.getInt('userId');

    setState(() {
      if (token != null && userId != null) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    });
  }

  List<Widget> _widgetOptions() {
    if (isLoggedIn) {
      return <Widget>[
        const MainPage(),
        const FavoritePage(),
        const NotificationPage(),
        ProfilPage(),
      ];
    } else {
      return <Widget>[
        const MainPage(),
        const LoginView(),
        const LoginView(),
        const LoginView(),
      ];
    }
  }

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
      body: _widgetOptions().elementAt(_selectedIndex),
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
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final homePageState = context.findAncestorStateOfType<_HomePageState>();

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
              items: homePageState!._carouselImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: screenSize.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const [
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
              screenSize.width * 0.07,
              screenSize.height * 0.01,
              screenSize.width * 0.07,
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
                  children: homePageState._recommendedPlaces.map((place) {
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
                            homePageState.desaMap[place.idDesawisata] ??
                                'Unknown',
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
