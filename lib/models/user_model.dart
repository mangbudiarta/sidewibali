class User {
  final String nama;
  final String email;
  final String password;
  final String noTelp;
  final String? foto;
  final String role;

  User({
    required this.nama,
    required this.email,
    required this.password,
    required this.noTelp,
    this.foto,
    this.role = 'USER',
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'no_telp': noTelp,
      'foto': foto,
      'role': role,
    };
  }
}
