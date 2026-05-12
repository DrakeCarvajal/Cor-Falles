class AppUser {
  final String email;
  final String username;
  final String location;

  // SOLO demo: nunca guardes passwords en texto plano en un proyecto real.
  final String password;
  final String role;

  AppUser({
    required this.email,
    required this.username,
    required this.location,
    required this.password,
    required this.role,
  });
}
