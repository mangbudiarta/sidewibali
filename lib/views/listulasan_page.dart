import 'package:flutter/material.dart';

class UlasanPage extends StatefulWidget {
  @override
  _UlasanPageState createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  List<String> filters = ['Semua', '⭐1', '⭐2', '⭐3', '⭐4', '⭐5'];

  List<Map<String, dynamic>> destinations = [
    {
      'image': 'assets/images/beratan.png',
      'name': 'Kebun Raya Bedugul',
      'location': 'Desa Wisata Candikuning',
      'rating': 5,
      'reviews': 20
    },
    {
      'image': 'assets/images/ubud.png',
      'name': 'Puri Ubud',
      'location': 'Desa Wisata Ubud',
      'rating': 4.7,
      'reviews': 26
    },
    {
      'image': 'assets/images/beratan.png',
      'name': 'Wisata Tracking',
      'location': 'Desa Wisata Taro',
      'rating': 4.2,
      'reviews': 40
    },
  ];

  List<Map<String, dynamic>> getFilteredDestinations() {
    List<Map<String, dynamic>> filteredDestinations = destinations;

    if (selectedFilter != 'Semua') {
      int selectedRating = int.parse(selectedFilter.substring(1));
      filteredDestinations = filteredDestinations
          .where(
              (destination) => destination['rating'].floor() == selectedRating)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredDestinations = filteredDestinations
          .where((destination) =>
              destination['name']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              destination['location']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredDestinations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan',
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
            // Filter Berdasarkan Bintang
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      labelStyle: TextStyle(color: Colors.black),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Color.fromARGB(255, 172, 241, 244),
                      selected: selectedFilter == filter,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedFilter = selected ? filter : selectedFilter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),

            Expanded(
              child: ListView(
                children: getFilteredDestinations().map((destination) {
                  return _buildDestinationCard(
                    destination['image'],
                    destination['name'],
                    destination['location'],
                    destination['rating'],
                    destination['reviews'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(String imageUrl, String name, String location,
      double rating, int reviews) {
    return Padding(
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('$rating'),
                ],
              ),
              Text('$reviews Reviews'),
            ],
          ),
        ),
      ),
    );
  }
}
