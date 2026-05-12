import 'package:flutter/material.dart';

import '../models/app_user.dart';

class AuthController extends ChangeNotifier {
  AppUser? currentUser;

  final List<AppUser> _users = [];

  AuthController() {
    // Usuario de prueba
    _users.add(
      AppUser(
        email: 'demo@corfalles.app',
        username: 'demo',
        location: 'Valencia',
        password: '123456',
        role: 'organizador',
      ),
    );
  }

  bool get canCreateEvents {
    final role = currentUser?.role;
    return role == 'organizador' || role == 'admin';
  }

  bool emailExists(String email) =>
      _users.any((u) => u.email.toLowerCase() == email.toLowerCase());

  String? register({
    required String email,
    required String password,
    required String password2,
    required String username,
    required String location,
  }) {
    if (email.trim().isEmpty ||
        password.isEmpty ||
        password2.isEmpty ||
        username.trim().isEmpty ||
        location.trim().isEmpty) {
      return 'Completa todos los campos.';
    }
    if (password != password2) return 'Las contraseñas no coinciden.';
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (emailExists(email)) return 'Ese correo ya está registrado.';

    final newUser = AppUser(
      email: email.trim(),
      username: username.trim(),
      location: location.trim(),
      password: password,
      role: 'organizador',
    );

    _users.add(newUser);
    currentUser = newUser;
    notifyListeners();
    return null;
  }

  String? login({required String identifier, required String password}) {
    final id = identifier.trim().toLowerCase();

    final user = _users.cast<AppUser?>().firstWhere(
          (u) =>
              (u?.email.toLowerCase() == id) ||
              (u?.username.toLowerCase() == id),
          orElse: () => null,
        );

    if (user == null) return 'Usuario no encontrado.';
    if (user.password != password) return 'Contraseña incorrecta.';

    currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    return scope!.notifier!;
  }
}
