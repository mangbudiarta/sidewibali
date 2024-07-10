import 'package:flutter/material.dart';
import 'package:sidewibali/models/paketwisata.dart';

class DetailPaketwisata extends StatelessWidget {
  final PaketWisata paketWisata;

  DetailPaketwisata({required this.paketWisata});

  final Map<int, String> desaMap = {
    1: 'Desa Bedugul',
    2: 'Desa Ubud',
    3: 'Desa Kuta',
  };

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
                  paketWisata.gambar,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 400,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        paketWisata.nama,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp${paketWisata.harga}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        desaMap[int.parse(paketWisata.id_desawisata)] ??
                            'Desa Tidak Diketahui',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    paketWisata.deskripsi,
                    style: TextStyle(fontSize: 16),
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
