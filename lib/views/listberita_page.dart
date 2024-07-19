import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidewibali/models/berita_model.dart';
import 'detailberita_page.dart';

class BeritaPage extends StatefulWidget {
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
        title: Text(
          'Berita',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                decoration: InputDecoration(
                  hintText: 'Cari Berita',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
                              offset: Offset(0, 3),
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
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      berita.judul.length > 50
                                          ? '${berita.judul.substring(0, 50)}...'
                                          : berita.judul,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(berita.timestamp),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
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
