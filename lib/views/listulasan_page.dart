import 'package:flutter/material.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/ulasan_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';

class UlasanPage extends StatefulWidget {
  const UlasanPage({super.key});

  @override
  _UlasanPageState createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  List<String> filters = ['Semua', '⭐1', '⭐2', '⭐3', '⭐4', '⭐5'];
  Map<int, String> desaMap = {};
  List<Destinasi> destinations = [];
  List<ReviewDestinasi> reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
    _fetchReviews();
    _fetchDesaNames();
  }

  Future<void> _fetchDestinations() async {
    final destinations = await ApiService.fetchDestinasi();
    setState(() {
      this.destinations = destinations;
    });
  }

  Future<void> _fetchReviews() async {
    final reviews = await ApiService.fetchReviewDestinasi();
    setState(() {
      this.reviews = reviews;
    });
  }

  Future<void> _fetchDesaNames() async {
    final apiService = ApiService();
    final desaWisataList = await apiService.fetchDesaWisataList();
    setState(() {
      desaMap = {for (var item in desaWisataList) item.id: item.nama};
    });
  }

  List<DestinasiUlasan> getGroupedReviews() {
    Map<int, List<ReviewDestinasi>> groupedReviews = {};

    for (var review in reviews) {
      if (groupedReviews.containsKey(review.idDestinasiwisata)) {
        groupedReviews[review.idDestinasiwisata]!.add(review);
      } else {
        groupedReviews[review.idDestinasiwisata] = [review];
      }
    }

    List<DestinasiUlasan> result = [];

    groupedReviews.forEach((idDestinasi, reviewList) {
      final destination = destinations.firstWhere(
        (dest) => dest.id == idDestinasi,
        orElse: () => Destinasi(
          id: 0,
          gambar: '',
          nama: 'Destinasi Tidak Diketahui',
          deskripsi: '',
          idKategoridestinasi: 0,
          idDesawisata: 0,
        ),
      );

      double averageRating =
          reviewList.map((review) => review.rating).reduce((a, b) => a + b) /
              reviewList.length;

      result.add(
        DestinasiUlasan(
          destinasi: destination,
          averageRating: averageRating,
          reviewCount: reviewList.length,
        ),
      );
    });

    return result;
  }

  List<DestinasiUlasan> getFilteredAndSearchedReviews() {
    List<DestinasiUlasan> groupedReviews = getGroupedReviews();

    // Filter berdasarkan rating bintang
    if (selectedFilter != 'Semua') {
      int starFilter = int.parse(selectedFilter.substring(1));
      groupedReviews = groupedReviews
          .where((destinasiUlasan) =>
              destinasiUlasan.averageRating.floor() == starFilter)
          .toList();
    }

    // Filter berdasarkan pencarian
    if (searchQuery.isNotEmpty) {
      groupedReviews = groupedReviews.where((destinasiUlasan) {
        return destinasiUlasan.destinasi.nama
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (desaMap[destinasiUlasan.destinasi.idDesawisata]
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    return groupedReviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ulasan',
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
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Filter Berdasarkan Bintang
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      labelStyle: const TextStyle(color: Colors.black),
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color.fromARGB(255, 172, 241, 244),
                      selected: selectedFilter == filter,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedFilter = selected ? filter : selectedFilter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),

            Expanded(
              child: getFilteredAndSearchedReviews().isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada ulasan yang sesuai',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView(
                      children: getFilteredAndSearchedReviews()
                          .map((destinasiUlasan) {
                        final destination = destinasiUlasan.destinasi;
                        final averageRating = destinasiUlasan.averageRating;
                        final reviewCount = destinasiUlasan.reviewCount;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailDestinasi(
                                  destinasi: destination,
                                ),
                              ),
                            );
                          },
                          child: _buildReviewCard(
                            destination.gambar,
                            destination.nama,
                            desaMap[destination.idDesawisata] ??
                                'Desa Tidak Diketahui',
                            averageRating,
                            reviewCount,
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String imageUrl, String name, String location,
      double averageRating, int reviewCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'http://8.215.11.162:3000/resource/destinasiwisata/${imageUrl}',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default_image.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(averageRating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 4),
              Text('$reviewCount ulasan'),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinasiUlasan {
  final Destinasi destinasi;
  final double averageRating;
  final int reviewCount;

  DestinasiUlasan({
    required this.destinasi,
    required this.averageRating,
    required this.reviewCount,
  });
}
