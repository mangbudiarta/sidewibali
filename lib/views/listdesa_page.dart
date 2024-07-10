import 'package:flutter/material.dart';
import 'package:sidewibali/models/desa.dart';
import 'package:sidewibali/views/detaildesa_page.dart';

class DesaWisataPage extends StatefulWidget {
  @override
  _DesaWisataPageState createState() => _DesaWisataPageState();
}

class _DesaWisataPageState extends State<DesaWisataPage> {
  String selectedCategory = 'Semua';
  String selectedKabupaten = 'Badung';
  String searchQuery = '';

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

  List<Map<String, dynamic>> destinations = [
    {
      'id': 1,
      'gambar': 'assets/images/beratan.png',
      'nama': 'Desa Wisata Candikuning',
      'kabupaten': 'Tabanan',
      'deskripsi': 'deskripsi desa beratan',
      'alamat': 'Candikuning, Tabanan',
      'kategori': 'Maju'
    },
    {
      'id': 2,
      'gambar': 'assets/images/ubud.png',
      'nama': 'Desa Wisata Ubud',
      'kabupaten': 'Gianyar',
      'deskripsi': 'deskripsi desa ubud',
      'alamat': 'Ubud, Gianyar',
      'kategori': 'Mandiri'
    },
  ];

  List<DesaWisata> get desaWisataList {
    return destinations.map((destination) {
      return DesaWisata(
        id: destination['id'],
        gambar: destination['gambar'],
        nama: destination['nama'],
        deskripsi: destination['deskripsi'],
        kabupaten: destination['kabupaten'],
        alamat: destination['alamat'],
        kategori: destination['kategori'],
      );
    }).toList();
  }

  List<DesaWisata> get filteredDesaWisata {
    return desaWisataList.where((desa) {
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
        title: Text(
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
            // Filter Berdasarkan Kategori
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category),
                      labelStyle: TextStyle(color: Colors.black),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Color.fromARGB(255, 172, 241, 244),
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
            // Dropdown saat kabupaten dipilih
            if (selectedCategory == 'Kabupaten')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
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
              child: ListView.builder(
                itemCount: filteredDesaWisata.length,
                itemBuilder: (context, index) {
                  return _buildDestinationCard(filteredDesaWisata[index]);
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                desa.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
