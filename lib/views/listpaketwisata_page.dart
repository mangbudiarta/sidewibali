import 'package:flutter/material.dart';
import 'package:sidewibali/models/paketwisata_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/views/detailpaketwisata_page.dart';

class PaketWisataPage extends StatefulWidget {
  const PaketWisataPage({super.key});

  @override
  _PaketWisataPageState createState() => _PaketWisataPageState();
}

class _PaketWisataPageState extends State<PaketWisataPage> {
  String searchQuery = '';
  List<PaketWisata> paketwisata = [];
  Map<int, String> desaMap = {};

  @override
  void initState() {
    super.initState();
    _fetchPaketWisata();
    _fetchDesaNames();
  }

  Future<void> _fetchPaketWisata() async {
    try {
      final paketwisata = await ApiService.fetchPaketWisata();
      setState(() {
        this.paketwisata = paketwisata;
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

  List<PaketWisata> get filteredPaketWisata {
    return paketwisata.where((paketWisata) {
      return paketWisata.nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paket Wisata',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "nunitoBold"),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: paketwisata.isEmpty && desaMap.isEmpty
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
                      style: const TextStyle(fontFamily: 'nunitoRegular'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: filteredPaketWisata.isEmpty
                        ? Center(
                            child: Text(
                            'Belum ada paket wisata yang sesuai',
                            style: TextStyle(
                                fontFamily: 'nunitoRegular',
                                fontSize: 16,
                                color: Colors.grey[600]),
                          ))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 3 / 4, // Adjust as needed
                            ),
                            itemCount: filteredPaketWisata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildPaketWisataCard(
                                  filteredPaketWisata[index]);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPaketWisataCard(PaketWisata paketWisata) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPaketwisata(
              paketWisata: paketWisata,
              namadesa:
                  desaMap[paketWisata.idDesawisata] ?? 'Desa Tidak Diketahui',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
                    "http://8.215.11.162:3000/resource/paketwisata/${paketWisata.gambar}",
                    height: 100,
                    width: 165,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default_image.png',
                        height: 100,
                        width: 165,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                paketWisata.nama,
                style: const TextStyle(
                  fontFamily: "nunitoSemiBold",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    desaMap[paketWisata.idDesawisata] ?? 'Desa Tidak Diketahui',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'nunitoRegular',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
