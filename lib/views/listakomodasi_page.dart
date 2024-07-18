import 'package:flutter/material.dart';
import 'package:sidewibali/models/akomodasi_model.dart';
import 'package:sidewibali/views/detailakomodasi_page.dart';

class AkomodasiPage extends StatefulWidget {
  const AkomodasiPage({super.key});

  @override
  _AkomodasiPageState createState() => _AkomodasiPageState();
}

class _AkomodasiPageState extends State<AkomodasiPage> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  List<String> categories = [
    'Semua',
    'Hotel',
    'Villa',
    'Glamping',
  ];

  List<Akomodasi> accommodations = [
    Akomodasi(
      gambar:
          'https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/10000224-3110x2074-FIT_AND_TRIM-932c024ef643cbc080303dec6762c32a.jpeg?_src=imagekit&tr=c-at_max,f-jpg,h-360,pr-true,q-100,w-640',
      nama: 'CLV Hotel And Villa',
      kategori: 'Hotel',
      id_desawisata: 1,
    ),
    Akomodasi(
      gambar:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/432052930.jpg?k=f7a7b48e87279dbc36822bc186d7d19c4c0867421aa1e72cfc0bed1898b727fb&o=&hp=1',
      nama: 'Diamond Glamping Bedugul',
      kategori: 'Glamping',
      id_desawisata: 2,
    ),
    Akomodasi(
      gambar:
          'https://cf2.bstatic.com/xdata/images/hotel/max1280x900/335858204.jpg?k=5f6312589836fe276b5c2cdfb87998b6054a7018a59d4ce4a4e3ca1d9c00d548&o=&hp=1',
      nama: 'Vila Sinta',
      kategori: 'Villa',
      id_desawisata: 1,
    ),
  ];

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
              child: ListView.builder(
                itemCount: filteredAccommodations.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildAccommodationCard(filteredAccommodations[index]);
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
                accommodation.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
