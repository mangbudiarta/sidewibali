import 'package:flutter/material.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/models/destinasi_model.dart';
import 'package:sidewibali/services/api_service.dart';

class DestinasiPage extends StatefulWidget {
  const DestinasiPage({super.key});

  @override
  _DestinasiPageState createState() => _DestinasiPageState();
}

class _DestinasiPageState extends State<DestinasiPage> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  List<String> categories = ['Semua'];
  Map<int, String> categoryMap = {};
  Map<int, String> desaMap = {};
  List<Destinasi> destinations = [];

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
    _fetchDesaNames();
    _fetchCategories();
  }

  Future<void> _fetchDestinations() async {
    final destinations = await ApiService.fetchDestinasi();
    setState(() {
      this.destinations = destinations;
    });
  }

  Future<void> _fetchDesaNames() async {
    final apiService = ApiService();
    final desaWisataList = await apiService.fetchDesaWisataList();
    setState(() {
      desaMap = {for (var item in desaWisataList) item.id: item.nama};
    });
  }

  Future<void> _fetchCategories() async {
    final apiService = ApiService();
    final kategoriList = await apiService.fetchKategoriDestinasi();
    setState(() {
      categories = ['Semua'];
      categoryMap = {};
      for (var kategori in kategoriList) {
        categories.add(kategori.nama);
        categoryMap[kategori.id] = kategori.nama;
      }
    });
  }

  List<Destinasi> get filteredDestinations {
    return destinations.where((destination) {
      bool matchesCategory = selectedCategory == 'Semua' ||
          categoryMap[destination.idKategoridestinasi] == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
          destination.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Destinasi Wisata',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "nunitoBold",
          ),
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
            // Filter Berdasarkan Kategori
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        category,
                        style: const TextStyle(fontFamily: 'nunitoRegular'),
                      ),
                      labelStyle: const TextStyle(color: Colors.black),
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color.fromARGB(255, 172, 241, 244),
                      selected: selectedCategory == category,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'Semua';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: filteredDestinations.isEmpty
                  ? Center(
                      child: Text(
                      'Belum ada destinasi yang sesuai',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'nunitoRegular',
                      ),
                    ))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3 / 4, // Adjust as needed
                      ),
                      itemCount: filteredDestinations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildDestinationCard(
                            filteredDestinations[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(Destinasi destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDestinasi(
              destinasi: destination,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Image.network(
                      'http://8.215.11.162:3000/resource/destinasiwisata/${destination.gambar}',
                      height: 100,
                      width: 165,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default_image.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                destination.nama,
                style: const TextStyle(
                  fontFamily: 'nunitoSemiBold',
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
                    desaMap[destination.idDesawisata] ?? 'Desa Tidak Diketahui',
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
