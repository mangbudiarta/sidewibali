class DesaWisata {
  final int id;
  final String gambar;
  final String nama;
  final String kabupaten;
  final String deskripsi;
  final String alamat;
  final String kategori;

  DesaWisata({
    required this.id,
    required this.gambar,
    required this.nama,
    required this.kabupaten,
    required this.deskripsi,
    required this.alamat,
    required this.kategori,
  });

  // Add a factory constructor to convert JSON to DesaWisata object
  factory DesaWisata.fromJson(Map<String, dynamic> json) {
    return DesaWisata(
      id: json['id'],
      gambar: json['gambar'],
      nama: json['nama'],
      kabupaten: json['kabupaten'],
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      kategori: json['kategori'],
    );
  }
}
