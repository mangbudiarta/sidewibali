import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/utils/colors.dart';
import 'package:sidewibali/views/login_page.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/models/ulasan_model.dart';

class FormUlasan extends StatefulWidget {
  final Destinasi destinasi;

  const FormUlasan({Key? key, required this.destinasi}) : super(key: key);

  @override
  _FormUlasanState createState() => _FormUlasanState();
}

class _FormUlasanState extends State<FormUlasan> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  late String _token;
  late int _idAkun;

  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  Future<void> _cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? id = prefs.getInt('userId');

    if (token == null || token.isEmpty || id == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } else {
      setState(() {
        _token = token;
        _idAkun = id;
      });
    }
  }

  Future<void> _submitReview() async {
    final reviewText = _reviewController.text.trim();

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap beri rating terlebih dahulu.')),
      );
      return;
    }

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ulasan tidak boleh kosong.')),
      );
      return;
    }

    if (reviewText.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ulasan harus terdiri dari minimal 5 karakter.')),
      );
      return;
    }

    final review = ReviewDestinasi(
      id: 0,
      idAkun: _idAkun,
      idDestinasiwisata: widget.destinasi.id,
      rating: _rating,
      review: reviewText,
      setujui: false,
    );

    try {
      await ApiService().addReview(review, _token);
      setState(() {
        _reviewController.clear();
        _rating = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: const Text('Beri Ulasan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.destinasi.nama,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Ulasan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Simpan Ulasan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
