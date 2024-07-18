import 'package:flutter/material.dart';
import 'package:sidewibali/views/detaildestinasi_page.dart';
import 'package:sidewibali/models/destinasi_model.dart';

class DestinasiPage extends StatefulWidget {
  const DestinasiPage({super.key});

  @override
  _SearchPageStateDestinasi createState() => _SearchPageStateDestinasi();
}

class _SearchPageStateDestinasi extends State<DestinasiPage> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  List<String> categories = [
    'Semua',
    'Destinasi Wisata Air',
    'Destinasi Wisata Alam',
    'Destinasi Wisata Rekreasi'
  ];

  Map<int, String> categoryMap = {
    1: 'Destinasi Wisata Air',
    2: 'Destinasi Wisata Alam',
    3: 'Destinasi Wisata Rekreasi'
  };

  Map<int, String> desaMap = {
    1: 'Desa Bedugul',
    2: 'Desa Ubud',
    3: 'Desa Kuta'
  };

  List<Destinasi> destinations = [
    Destinasi(
      gambar: 'assets/images/beratan.png',
      nama: 'Destinasi Wisata Ulun Danu Beratan',
      deskripsi: 'Deskripsi dari Destinasi Wisata Ulun Danu Beratan',
      id_kategoridestinasi: 1,
      id_desawisata: 1,
    ),
    Destinasi(
      gambar: 'assets/images/ubud.png',
      nama: 'Destinasi Wisata Budaya',
      deskripsi: 'Deskripsi dari Destinasi Wisata Budaya',
      id_kategoridestinasi: 2,
      id_desawisata: 2,
    ),
  ];

  List<Destinasi> get filteredDestinations {
    return destinations.where((destination) {
      bool matchesCategory = selectedCategory == 'Semua' ||
          categoryMap[destination.id_kategoridestinasi] == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
          destination.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinasi Wisata',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                      label: Text(category),
                      labelStyle: const TextStyle(color: Colors.black),
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color.fromARGB(255, 172, 241, 244),
                      selected: selectedCategory == category,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'All';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDestinations.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildDestinationCard(filteredDestinations[index]);
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              child: Image.asset(
                destination.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(destination.nama),
            subtitle: Row(
              children: [
                Text(
                  desaMap[destination.id_desawisata] ?? 'Desa Tidak Diketahui',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
