import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/review_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailDestinasi extends StatefulWidget {
  final Destinasi destinasi;

  const DetailDestinasi({
    super.key,
    required this.destinasi,
  });

  @override
  _DetailDestinasiState createState() => _DetailDestinasiState();
}

class _DetailDestinasiState extends State<DetailDestinasi> {
  int likeCount = 120;
  bool isLiked = false;
  String desaName = '';
  String categoryName = '';
  late Future<List<ReviewDestinasi>> futureReview;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDesaAndCategoryNames();
    futureReview = ApiService().fetchReviewsDestinasi(widget.destinasi.id);
  }

  Future<void> _fetchDesaAndCategoryNames() async {
    final desaName =
        await ApiService().fetchNamaDesa(widget.destinasi.id_desawisata);
    final categoryName = await ApiService()
        .fetchKategoriDestinasiDetail(widget.destinasi.id_kategoridestinasi);

    setState(() {
      this.desaName = desaName;
      this.categoryName = categoryName;
    });
  }

  Future<Map<String, dynamic>?> _getAccountDetails(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      return await ApiService.getAccountDetails(userId, token);
    } else {
      print('Token tidak ditemukan');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.destinasi.gambar,
                  height: 400,
                  fit: BoxFit.cover,
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
                        child: Text(categoryName),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.destinasi.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        desaName,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.destinasi.deskripsi),
                  const SizedBox(height: 16),
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star_border, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('4/5 (49 Penilaian)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ulasan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<List<ReviewDestinasi>>(
                    future: futureReview,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Belum ada ulasan.');
                      } else {
                        final reviews = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return FutureBuilder<Map<String, dynamic>?>(
                              future: _getAccountDetails(
                                review.id_akun,
                              ), // ganti dengan id user dari review
                              builder: (context, userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return Text('Error: ${userSnapshot.error}');
                                } else if (!userSnapshot.hasData) {
                                  return const Text('Akun tidak ditemukan.');
                                } else {
                                  final user = userSnapshot.data!;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            user['foto'] ??
                                                'https://via.placeholder.com/50',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(user['nama'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(width: 8),
                                                  Row(
                                                    children: List.generate(5,
                                                        (index) {
                                                      return Icon(
                                                        index < review.rating
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(review.review),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
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
