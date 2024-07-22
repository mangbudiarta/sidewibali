class Notifikasi {
  final int id;
  late final bool status;
  final String deskripsi;
  final int idAkun;
  final DateTime createdAt;

  Notifikasi({
    required this.id,
    required this.status,
    required this.deskripsi,
    required this.idAkun,
    required this.createdAt,
  });
  factory Notifikasi.fromJson(Map<String, dynamic> json) {
    return Notifikasi(
        id: json['id'],
        deskripsi: json['deskripsi'],
        status: json['status'] == 0,
        idAkun: json['id_akun'],
        createdAt: DateTime.parse(json['createdAt']));
  }
}
