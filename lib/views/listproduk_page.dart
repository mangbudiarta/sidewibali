import 'package:flutter/material.dart';
import 'package:sidewibali/models/produk_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/views/detailproduk_page.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String searchQuery = '';
  List<Produk> produk = [];
  Map<int, String> desaMap = {};

  @override
  void initState() {
    super.initState();
    _fetchProduk();
    _fetchDesaNames();
  }

  Future<void> _fetchProduk() async {
    try {
      final produk = await ApiService.fetchProduk();
      setState(() {
        this.produk = produk;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchDesaNames() async {
    try {
      final desaWisataList = await ApiService().fetchDesaWisataList();
      setState(() {
        desaMap = {for (var item in desaWisataList) item.id: item.nama};
      });
    } catch (e) {
      print(e);
    }
  }

  List<Produk> get filteredProduk {
    return produk.where((produk) {
      return produk.nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produk',
          style: TextStyle(
            fontFamily: 'NunitoBold',
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: produk.isEmpty && desaMap.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                  Expanded(
                    child: filteredProduk.isEmpty
                        ? Center(
                            child: Text(
                            'Belum ada produk yang sesuai',
                            style: TextStyle(
                              fontFamily: 'NunitoRegular',
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Mengatur jumlah kolom grid
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio:
                                  3 / 4, // Mengatur rasio aspek item
                            ),
                            itemCount: filteredProduk.length,
                            itemBuilder: (context, index) {
                              var produk = filteredProduk[index];
                              return CardProduk(
                                produk: produk,
                                desaMap: desaMap,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProduk(
                                          produk: produk,
                                          namadesa:
                                              desaMap[produk.idDesawisata]),
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
  final VoidCallback onTap;
  final Map<int, String> desaMap;

  const CardProduk({
    super.key,
    required this.produk,
    required this.onTap,
    required this.desaMap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    "http://8.215.11.162:3000/resource/produk/${produk.gambar}",
                    width: 165,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default_image.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  produk.nama,
                  style: TextStyle(
                    fontFamily: 'NunitoSemiBold',
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      desaMap[produk.idDesawisata] ?? 'Desa Tidak Diketahui',
                      style: TextStyle(
                        fontFamily: 'NunitoRegular',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
