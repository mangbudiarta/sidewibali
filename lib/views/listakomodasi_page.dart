import 'package:flutter/material.dart';
import 'package:sidewibali/models/akomodasi_model.dart';
import 'package:sidewibali/services/api_service.dart';
import 'package:sidewibali/views/detailakomodasi_page.dart';

class AkomodasiPage extends StatefulWidget {
  const AkomodasiPage({super.key});

  @override
  _AkomodasiPageState createState() => _AkomodasiPageState();
}

class _AkomodasiPageState extends State<AkomodasiPage> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  List<String> categories = ['Semua'];
  List<Akomodasi> accommodations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final apiService = ApiService();
      final fetchedAccommodations = await apiService.fetchAkomodasiList();

      // Extract unique categories
      final uniqueCategories = <String>{};
      for (var accommodation in fetchedAccommodations) {
        uniqueCategories.add(accommodation.kategori);
      }

      setState(() {
        accommodations = fetchedAccommodations;
        categories = ['Semua', ...uniqueCategories.toList()];
      });
    } catch (e) {
      // Handle error (e.g., show an alert)
      print('Error loading data: $e');
    }
  }

  List<Akomodasi> get filteredAccommodations {
    return accommodations.where((accommodation) {
      bool matchesCategory = selectedCategory == 'Semua' ||
          accommodation.kategori == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
          accommodation.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akomodasi',
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
                          selectedCategory = selected ? category : 'Semua';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Akomodasi>>(
                future: ApiService().fetchAkomodasiList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    accommodations = snapshot.data!;
                    return ListView.builder(
                      itemCount: filteredAccommodations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildAccommodationCard(
                            filteredAccommodations[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodationCard(Akomodasi accommodation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAkomodasi(
              akomodasi: accommodation,
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
              child: Image.network(
                "http://192.168.18.24:3000/resource/akomodasi/${accommodation.gambar}",
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
            title: Text(accommodation.nama),
            subtitle: Text(accommodation.kategori),
          ),
        ),
      ),
    );
  }
}
