import 'package:flutter/material.dart';
import 'package:sidewibali/models/berita.dart'; // Import model Berita
import 'detailberita_page.dart';

class BeritaPage extends StatefulWidget {
  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  List<Berita> dummyBerita = [
    Berita(
      judul:
          '19 Festival Akan Digelar Di Bali Pada Agustus 2024, Termasuk Rare Angon Kite Festival',
      isi_berita:
          'Pada Agustus 2024, Bali akan menjadi tuan rumah bagi 19 festival menarik yang menampilkan kekayaan budaya, seni, dan tradisi pulau ini. Salah satu festival yang paling dinantikan adalah Rare Angon Kite Festival, sebuah perayaan layang-layang tradisional Bali yang diadakan setiap tahun. Festival ini tidak hanya menampilkan layang-layang dengan berbagai bentuk dan ukuran, tetapi juga memperlihatkan keterampilan dan kreativitas para pembuat layang-layang lokal. Acara ini menarik perhatian baik penduduk setempat maupun wisatawan, memberikan kesempatan untuk menikmati suasana yang meriah dan keindahan langit Bali yang dihiasi layang-layang berwarna-warni. Selain Rare Angon Kite Festival, berbagai acara lainnya juga akan diadakan, menambah semarak bulan Agustus di Bali dan menawarkan pengalaman budaya yang tak terlupakan bagi semua pengunjung',
      gambar: 'assets/images/news.png',
      id_desawisata: 1,
    ),
    Berita(
      judul: 'Pembukaan Festival Budaya',
      isi_berita:
          'Pada Agustus 2024, Bali akan menyelenggarakan 19 festival budaya yang luar biasa, termasuk pembukaan Festival Budaya yang akan menjadi sorotan utama bulan tersebut. Acara ini akan menampilkan berbagai aspek seni dan tradisi Bali, dari tarian dan musik tradisional hingga pameran seni dan kerajinan tangan lokal. Festival Budaya ini bertujuan untuk merayakan dan melestarikan warisan budaya Bali, serta memberikan pengunjung kesempatan untuk merasakan kekayaan dan keragaman budaya pulau ini. Pembukaan festival ini akan menjadi momen istimewa yang tidak boleh dilewatkan, menandai awal dari rangkaian acara yang penuh warna dan energi di seluruh Bali sepanjang bulan Agustus.',
      gambar: 'assets/images/news.png',
      id_desawisata: 2,
    ),
    Berita(
      judul: 'Festival Lomba Tari Bali',
      isi_berita:
          'Pada Agustus 2024, Bali akan menggelar 19 festival budaya yang meriah, salah satunya adalah lomba tari Bali yang akan menjadi bagian dari rangkaian acara ini. Lomba tari Bali ini akan menampilkan berbagai jenis tarian tradisional Bali, seperti tari Legong, tari Kecak, tari Barong, dan tari Pendet. Peserta dari berbagai usia dan latar belakang akan menunjukkan keterampilan dan keindahan gerakan mereka dalam kompetisi yang penuh semangat dan antusiasme.',
      gambar: 'assets/images/news.png',
      id_desawisata: 3,
    ),
  ];

  final Map<int, String> desaMap = {
    1: 'Desa Bedugul',
    2: 'Desa Ubud',
    3: 'Desa Kuta'
  };

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var filteredList = dummyBerita
        .where((berita) =>
            berita.judul.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Berita',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                  hintText: 'Cari Berita',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var berita = filteredList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBerita(
                            berita: berita,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                              berita.gambar,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            berita.judul,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            desaMap[berita.id_desawisata] ??
                                'Desa Tidak Diketahui',
                          ),
                        ),
                      ),
                    ),
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
