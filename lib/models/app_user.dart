class AppUser {
  final String email;
  final String username;
  final String location;

  // SOLO demo: nunca se deben guardar passwords en texto plano en una aplicación real.
  final String password;
  final String role;

  AppUser({
    required this.email,
    required this.username,
    required this.location,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'location': location,
      'password': password,
      'role': role,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      password: (json['password'] ?? '').toString(),
      role: (json['role'] ?? 'usuario').toString(),
    );
  }
}
