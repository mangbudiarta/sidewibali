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
      print('Error fetching Paket Wisata: $e');
    }
  }

  Future<void> _fetchDesaNames() async {
    try {
      final desaWisataList = await ApiService().fetchDesaWisataList();
      setState(() {
        desaMap = {for (var item in desaWisataList) item.id: item.nama};
      });
    } catch (e) {
      print('Error fetching Desa Names: $e');
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPaketWisata.length,
                      itemBuilder: (context, index) {
                        var paketWisata = filteredPaketWisata[index];
                        return CardPaketWisata(
                          paketWisata: paketWisata,
                          desaMap: desaMap,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPaketwisata(
                                    paketWisata: paketWisata,
                                    namadesa:
                                        desaMap[paketWisata.idDesawisata]),
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
  final VoidCallback onTap;
  final Map<int, String> desaMap;

  const CardPaketWisata({
    super.key,
    required this.paketWisata,
    required this.onTap,
    required this.desaMap,
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://192.168.43.155:3000/resource/desawisata/${paketWisata.gambar}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_image.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            title: Text(paketWisata.nama),
            subtitle: Row(
              children: [
                Text(desaMap[paketWisata.idDesawisata] ??
                    'Desa Tidak Diketahui'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
