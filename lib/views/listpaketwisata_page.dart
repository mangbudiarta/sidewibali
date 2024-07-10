import 'package:flutter/material.dart';
import 'package:sidewibali/models/paketwisata.dart';
import 'package:sidewibali/models/produk.dart';
import 'package:sidewibali/models/desa.dart';
import 'package:sidewibali/views/detailproduk_page.dart';

class PaketWisataPage extends StatefulWidget {
  @override
  _PaketWisataPageState createState() => _PaketWisataPageState();
}

List<PaketWisata> dummyPaketWisata = [
  PaketWisata(
    nama: 'Paket Premium',
    harga: 100000,
    deskripsi:
        'Paket yang cocok untuk pengalaman wisata yang berkualitas dengan pelayanan terbaik.',
    id_desawisata: '1',
    gambar: 'assets/images/produk.png',
  ),
  PaketWisata(
    nama: 'Paket Keluarga',
    harga: 50000,
    deskripsi:
        'Paket yang cocok untuk pengalaman wisata yang bersama keluarga dengan harga spesial.',
    id_desawisata: '2',
    gambar: 'assets/images/produk.png',
  ),
  PaketWisata(
    nama: 'Paket Hari Raya',
    harga: 20000,
    deskripsi: 'Paket yang cocok untuk pengalaman wisata saat hari raya.',
    id_desawisata: '3',
    gambar: 'assets/images/produk.png',
  ),
];

List<DesaWisata> dummyDesaWisata = [
  DesaWisata(
    id: 1,
    nama: 'Desa Beraban',
    alamat: 'Beraban, Tabanan',
    gambar: 'assets/images/kuta.png',
    deskripsi: 'deskripsi desa beraban',
    kategori: 'berkembang',
    kabupaten: 'Tabanan',
  ),
  DesaWisata(
    id: 2,
    nama: 'Desa Ubud',
    alamat: 'Ubud, Gianyar',
    gambar: 'assets/images/ubud.png',
    deskripsi: 'deskripsi desa ubud',
    kategori: 'maju',
    kabupaten: 'Gianyar',
  ),
  DesaWisata(
    id: 3,
    nama: 'Desa Candikuning',
    alamat: 'Candikuning, Tabanan',
    gambar: 'assets/images/beratan.png',
    deskripsi: 'deskripsi desa candikuning',
    kategori: 'mandiri',
    kabupaten: 'Tabanan',
  ),
];

class _PaketWisataPageState extends State<PaketWisataPage> {
  String searchQuery = '';

  List<PaketWisata> get filteredPaketWisata {
    return dummyPaketWisata.where((paketWisata) {
      return paketWisata.nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  String getDesaNama(int id) {
    return dummyDesaWisata.firstWhere((desa) => desa.id == id).nama;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paket Wisata',
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
                decoration: InputDecoration(
                  hintText: 'Cari',
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
                itemCount: filteredPaketWisata.length,
                itemBuilder: (context, index) {
                  var paketWisata = filteredPaketWisata[index];
                  return CardPaketWisata(
                    paketWisata: paketWisata,
                    getDesaNama: getDesaNama,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduk(
                            produk: Produk(
                              nama: paketWisata.nama,
                              harga: paketWisata.harga,
                              deskripsi: paketWisata.deskripsi,
                              id_desawisata:
                                  paketWisata.id_desawisata.toString(),
                              gambar: paketWisata.gambar,
                            ),
                          ),
                        ),
                      );
                    },
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

class CardPaketWisata extends StatelessWidget {
  final PaketWisata paketWisata;
  final String Function(int) getDesaNama;
  final VoidCallback onTap;

  CardPaketWisata({
    required this.paketWisata,
    required this.getDesaNama,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
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
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                paketWisata.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(paketWisata.nama),
            subtitle: Row(
              children: [
                Text(getDesaNama(int.parse(paketWisata.id_desawisata))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
