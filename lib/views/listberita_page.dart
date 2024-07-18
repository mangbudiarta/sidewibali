import 'package:flutter/material.dart';

class Berita {
  final String judul;
  final String isi_berita;
  final String gambar;
  final int id_desawisata;
  final DateTime timestamp;

  Berita({
    required this.judul,
    required this.isi_berita,
    required this.gambar,
    required this.id_desawisata,
    required this.timestamp,
  });
}

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  List<Berita> dummyBerita = [
    Berita(
      judul:
          '19 Festival Akan Digelar Di Bali Pada Agustus 2024, Termasuk Rare Angon Kite Festival',
      isi_berita:
          'Pada Agustus 2024, Bali akan menjadi tuan rumah bagi 19 festival menarik yang menampilkan kekayaan budaya, seni, dan tradisi pulau ini...',
      gambar: 'assets/images/news.png',
      id_desawisata: 1,
      timestamp: DateTime(2024, 7, 10),
    ),
    Berita(
      judul: 'Pembukaan Festival Budaya',
      isi_berita:
          'Pada Agustus 2024, Bali akan menyelenggarakan 19 festival budaya yang luar biasa...',
      gambar: 'assets/images/news.png',
      id_desawisata: 2,
      timestamp: DateTime(2024, 7, 8),
    ),
    Berita(
      judul: 'Festival Lomba Tari Bali',
      isi_berita:
          'Pada Agustus 2024, Bali akan menggelar 19 festival budaya yang meriah...',
      gambar: 'assets/images/news.png',
      id_desawisata: 3,
      timestamp: DateTime(2024, 7, 9),
    ),
  ];

  final Map<int, String> desaMap = {
    1: 'Desa Bedugul',
    2: 'Desa Ubud',
    3: 'Desa Kuta'
  };

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    var filteredList = dummyBerita
        .where((berita) =>
            berita.judul.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Sort the filtered list by timestamp in descending order
    filteredList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Berita',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak Pencarian
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Cari Berita',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var berita = filteredList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBerita(
                            berita: berita,
                            desaMap: desaMap,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                berita.gambar,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  berita.judul.length > 50
                                      ? '${berita.judul.substring(0, 50)}...'
                                      : berita.judul,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailBerita extends StatelessWidget {
  final Berita berita;
  final Map<int, String> desaMap;

  const DetailBerita({super.key, required this.berita, required this.desaMap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(berita.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(berita.gambar),
            const SizedBox(height: 16.0),
            Text(
              berita.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Desa: ${desaMap[berita.id_desawisata]}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              berita.isi_berita,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
