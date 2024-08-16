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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pencarian
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
                style: const TextStyle(fontFamily: 'nunitoRegular'),
              ),
            ),
            const SizedBox(height: 16.0),
            // Kategori
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
            // Dropdown Kabupaten
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
                          child: Text(
                            value,
                            style: const TextStyle(fontFamily: 'nunitoRegular'),
                          ),
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
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3 / 4, // Adjust as needed
                      ),
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
                      "http://8.215.11.162:3000/resource/desawisata/${desa.gambar}",
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
                desa.nama,
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
                    desa.kabupaten,
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
