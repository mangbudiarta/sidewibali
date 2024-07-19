class InformasiKontak {
  final String email;
  final String website;
  final String noTelp;
  final String instagram;
  final String facebook;
  final String noWa;

  InformasiKontak({
    required this.email,
    required this.website,
    required this.noTelp,
    required this.instagram,
    required this.facebook,
    required this.noWa,
  });

  factory InformasiKontak.fromJson(Map<String, dynamic> json) {
    return InformasiKontak(
      email: json['email'],
      website: json['website'],
      noTelp: json['no_telp'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      noWa: json['no_wa'],
    );
  }
}
