import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidewibali/models/destinasi_model.dart';

class DetailDestinasi extends StatefulWidget {
  final Destinasi destinasi;

  DetailDestinasi({required this.destinasi});

  @override
  _DetailDestinasiState createState() => _DetailDestinasiState();
}

class _DetailDestinasiState extends State<DetailDestinasi> {
  int likeCount = 120;
  bool isLiked = false;

  final Map<int, String> categoryMap = {
    1: 'Destinasi Wisata Air',
    2: 'Destinasi Wisata Alam',
    3: 'Destinasi Wisata Rekreasi'
  };

  final Map<int, String> desaMap = {
    1: 'Desa Bedugul',
    2: 'Desa Ubud',
    3: 'Desa Kuta'
  };

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.destinasi.gambar,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
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
                      icon: Icon(Icons.arrow_back, color: Colors.black),
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
                        child: Text(
                          categoryMap[widget.destinasi.id_kategoridestinasi] ??
                              'Kategori Tidak Diketahui',
                        ),
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
                    widget.destinasi.nama,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        desaMap[widget.destinasi.id_desawisata] ??
                            'Desa Tidak Diketahui',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(widget.destinasi.deskripsi),
                  SizedBox(height: 16),
                  Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
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
                  SizedBox(height: 16),
                  Text(
                    'Ulasan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Review(
                    username: 'Agus Prianta',
                    rating: 4,
                    comment: 'Suasana yang sejuk dan indah',
                  ),
                  Review(
                    username: 'Dodek Alit',
                    rating: 5,
                    comment:
                        'Nyaman banget tempatnya, bagus untuk piknik keluarga, pokoknya rekomen banget',
                  ),
                  Review(
                    username: 'Ni Wayan Sari',
                    rating: 5,
                    comment: 'Tempat yang sangat nyaman untuk bersantai.',
                  ),
                  Review(
                    username: 'Made Sudana',
                    rating: 3,
                    comment: 'Cukup baik, tapi bisa lebih ditingkatkan lagi.',
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

class Review extends StatelessWidget {
  final String username;
  final int rating;
  final String comment;

  Review({required this.username, required this.rating, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/50'),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
