import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/models/ulasan_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/formulasan_page.dart';
import 'package:sidewibali/views/login_page.dart';

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
  final ApiService apiService = ApiService();
  int likeCount = 0;
  bool isLiked = false;
  String desaName = '';
  String categoryName = '';
  late Future<List<ReviewDestinasi>> futureReview;

  @override
  void initState() {
    super.initState();
    _fetchDesaAndCategoryNames();
    futureReview = ApiService().fetchReviewsDestinasi(widget.destinasi.id);
    _fetchDestinasiFavorit(widget.destinasi.id);
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId');

    if (token == null || token.isEmpty || userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
      return;
    }

    final List<int> favorites = await apiService.fetchMyDestinasiFavorite();
    if (favorites.contains(widget.destinasi.id)) {
      // Hapus dari favorite
      final int idFavorit =
          await ApiService().fetchIdByIdDestinasi(widget.destinasi.id);
      final isUnlike = await apiService.deleteDestinasiFavorite(idFavorit);
      if (isUnlike) {
        setState(() {
          isLiked = false;
          likeCount--;
        });
      } else {
        print("Gagal unlike");
      }
    } else {
      // Tambahkan ke favorite
      final isLike = await apiService.addDestinasiFavorite(widget.destinasi.id);
      if (isLike) {
        setState(() {
          isLiked = true;
          likeCount++;
        });
      } else {
        print("Gagal like");
      }
    }
  }

  Future<void> _fetchDestinasiFavorit(int idDestinasiWisata) async {
    try {
      final favorites = await apiService.fetchMyDestinasiFavorite();
      final favoritesDestinasi = await apiService.fetchAllDestinasiFavorite();

      int count =
          favoritesDestinasi.where((id) => id == idDestinasiWisata).length;

      if (favorites.contains(idDestinasiWisata)) {
        setState(() {
          isLiked = true;
          likeCount = count;
        });
      } else {
        setState(() {
          isLiked = false;
          likeCount = count;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDesaAndCategoryNames() async {
    final desaName =
        await ApiService().fetchNamaDesa(widget.destinasi.idDesawisata);
    final categoryName = await ApiService()
        .fetchKategoriDestinasiDetail(widget.destinasi.idKategoridestinasi);

    setState(() {
      this.desaName = desaName;
      this.categoryName = categoryName;
    });
  }

  Future<Map<String, dynamic>?> _getAccountDetails(int id_akun) async {
    try {
      final userDetails = await ApiService.fetchAkunDetail(id_akun);
      if (userDetails != null) {
        return userDetails;
      } else {
        throw Exception('User details are null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      return null;
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
                  'http://8.215.11.162:3000/resource/destinasiwisata/${widget.destinasi.gambar}',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      height: 400,
                      width: double.infinity,
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
                            onPressed: () {
                              _toggleFavorite();
                            }),
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
                  FutureBuilder<List<ReviewDestinasi>>(
                    future: futureReview,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('Belum ada ulasan');
                      } else {
                        final reviews = snapshot.data!;
                        double averageRating = reviews
                                .map((review) => review.rating)
                                .reduce((a, b) => a + b) /
                            reviews.length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return Icon(
                                    index < averageRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                                const SizedBox(width: 8),
                                Text(
                                    '${averageRating.toStringAsFixed(1)}/5 (${reviews.length} Penilaian)'),
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return FutureBuilder<Map<String, dynamic>?>(
                                  future: _getAccountDetails(review.idAkun),
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (userSnapshot.hasError) {
                                      return Text(
                                          'Error: ${userSnapshot.error}');
                                    } else if (!userSnapshot.hasData) {
                                      return const Text(
                                          'Akun tidak ditemukan.');
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
                                                                  FontWeight
                                                                      .bold)),
                                                      const SizedBox(width: 8),
                                                      Row(
                                                        children: List.generate(
                                                            5, (index) {
                                                          return Icon(
                                                            index <
                                                                    review
                                                                        .rating
                                                                ? Icons.star
                                                                : Icons
                                                                    .star_border,
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
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          foregroundColor: white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormUlasan(destinasi: widget.destinasi),
              ),
            );
          },
          child: const Icon(Icons.rate_review),
          shape: CircleBorder()),
    );
  }
}
