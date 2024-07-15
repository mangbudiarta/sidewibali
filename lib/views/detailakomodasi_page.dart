import 'package:flutter/material.dart';
import 'package:sidewibali/models/akomodasi_model.dart';

class DetailAkomodasi extends StatelessWidget {
  final Akomodasi akomodasi;

  DetailAkomodasi({required this.akomodasi});

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
                  akomodasi.gambar,
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
                        Navigator.of(context).pop();
                      },
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
                          akomodasi.kategori,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    akomodasi.nama,
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
                        fetchNamaDesa(akomodasi.id_desawisata),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String fetchNamaDesa(int idDesa) {
    switch (idDesa) {
      case 1:
        return 'Desa Candikuning';
      case 2:
        return 'Desa Ubud';
      default:
        return 'Desa Tidak Diketahui';
    }
  }
}
