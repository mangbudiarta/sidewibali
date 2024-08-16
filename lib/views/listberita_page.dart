import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidewibali/models/berita_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/detailberita_page.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  List<Berita> beritaList = [];
  String searchQuery = '';
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadBerita();
  }

  Future<void> _loadBerita() async {
    try {
      final berita = await ApiService.fetchBerita();
      setState(() {
        beritaList = berita;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var filteredList = beritaList
        .where((berita) =>
            berita.judul.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    filteredList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          'Berita',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'NunitoBold',
          ),
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
                style: const TextStyle(
                  fontFamily: 'NunitoRegular',
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari Berita',
                  hintStyle: TextStyle(
                    fontFamily: 'NunitoRegular',
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                      'Belum ada berita yang sesuai',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'NunitoRegular',
                      ),
                    ))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Dua kolom
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3 / 4, // Menyesuaikan proporsi card
                      ),
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
                          child: _buildBeritaCard(berita),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeritaCard(Berita berita) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "http://8.215.11.162:3000/resource/berita/${berita.gambar}",
                  height: 100,
                  width: 165,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              berita.judul.length > 50
                  ? '${berita.judul.substring(0, 50)}...'
                  : berita.judul,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSemiBold',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(berita.createdAt),
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontFamily: 'NunitoRegular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
