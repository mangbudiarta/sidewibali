import 'package:flutter/material.dart';
import 'package:sidewibali/models/produk_model.dart';
import 'package:sidewibali/models/desa_model.dart';
import 'package:sidewibali/views/detailproduk_page.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

List<Produk> dummyProduk = [
  Produk(
    nama: 'Patung Petani',
    harga: 10000,
    deskripsi:
        'Sebuah oleh-oleh khas yang menceritakan kehidupan masyarakat saat bertani',
    id_desawisata: '1',
    gambar: 'assets/images/produk.png',
  ),
  Produk(
    nama: 'Tas Bambu',
    harga: 50000,
    deskripsi:
        'Sebuah ole-oleh khas yang terbuat dari anyaman bambu ysng dibuat dengan tangan-tangan terampil',
    id_desawisata: '2',
    gambar: 'assets/images/produk.png',
  ),
  Produk(
    nama: 'Gerabah',
    harga: 20000,
    deskripsi:
        'Sebuah ole-oleh khas yang terbuat dari tanah liat ysng dibuat dengan tangan-tangan terampil',
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

class _ProdukPageState extends State<ProdukPage> {
  String searchQuery = '';

  List<Produk> get filteredProduk {
    return dummyProduk.where((produk) {
      return produk.nama.toLowerCase().contains(searchQuery.toLowerCase());
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
          'Produk',
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
                itemCount: filteredProduk.length,
                itemBuilder: (context, index) {
                  var produk = filteredProduk[index];
                  return CardProduk(
                    produk: produk,
                    getDesaNama: getDesaNama,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduk(
                            produk: produk,
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

class CardProduk extends StatelessWidget {
  final Produk produk;
  final String Function(int) getDesaNama;
  final VoidCallback onTap;

  CardProduk({
    required this.produk,
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
                produk.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(produk.nama),
            subtitle: Row(
              children: [
                Text(getDesaNama(int.parse(produk.id_desawisata))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
