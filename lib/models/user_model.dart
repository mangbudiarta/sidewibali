class User {
  final String nama;
  final String email;
  final String password;
  final String no_telp;
  final String? foto;
  final String role;

  User({
    required this.nama,
    required this.email,
    required this.password,
    required this.no_telp,
    this.foto,
    this.role = 'USER',
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'no_telp': no_telp,
      'foto': foto,
      'role': role,
    };
  }
}
