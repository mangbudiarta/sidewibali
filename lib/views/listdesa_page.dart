import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sidewibali/models/desawisata_model.dart';
import 'package:sidewibali/views/detaildesa_page.dart';
import 'package:sidewibali/services/api_service.dart';

class DesaWisataPage extends StatefulWidget {
  const DesaWisataPage({super.key});

  @override
  _DesaWisataPageState createState() => _DesaWisataPageState();
}

class _DesaWisataPageState extends State<DesaWisataPage> {
  String selectedCategory = 'Semua';
  String selectedKabupaten = 'Badung';
  String searchQuery = '';
  late Future<List<DesaWisata>> futureDesaWisataList;

  List<String> categories = [
    'Semua',
    'Rintisan',
    'Maju',
    'Berkembang',
    'Mandiri',
    'Kabupaten'
  ];

  List<String> kabupaten = [
    'Badung',
    'Bangli',
    'Buleleng',
    'Denpasar',
    'Gianyar',
    'Jembrana',
    'Karangasem',
    'Klungkung',
    'Tabanan'
  ];

  @override
  void initState() {
    super.initState();
    futureDesaWisataList = ApiService().fetchDesaWisataList();
  }

  List<DesaWisata> getFilteredDesaWisata(List<DesaWisata> desaList) {
    return desaList.where((desa) {
      bool matchesCategory = selectedCategory == 'Semua' ||
          (selectedCategory == 'Kabupaten'
              ? true
              : desa.kategori == selectedCategory);
      bool matchesKabupaten = selectedCategory == 'Kabupaten'
          ? desa.kabupaten == selectedKabupaten
          : true;
      bool matchesSearch = searchQuery.isEmpty
          ? true
          : desa.nama.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesKabupaten && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Desa Wisata',
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
            // Search Box
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
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Filter by Category
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
                          selectedCategory =
                              selected ? category : selectedCategory;
                          if (selectedCategory != 'Kabupaten') {
                            selectedKabupaten = 'Badung';
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            // Dropdown for Kabupaten selection
            if (selectedCategory == 'Kabupaten')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedKabupaten,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedKabupaten = newValue!;
                        });
                      },
                      items: kabupaten
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder<List<DesaWisata>>(
                future: futureDesaWisataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<DesaWisata> filteredDesaList =
                        getFilteredDesaWisata(snapshot.data ?? []);
                    return ListView.builder(
                      itemCount: filteredDesaList.length,
                      itemBuilder: (context, index) {
                        return _buildDestinationCard(filteredDesaList[index]);
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

  Widget _buildDestinationCard(DesaWisata desa) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDesa(
              desa: desa,
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
                "http://192.168.18.24:3000/resource/desawisata/${desa.gambar}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/default_image.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            title: Text(desa.nama),
            subtitle: Text(desa.kabupaten),
          ),
        ),
      ),
    );
  }
}
