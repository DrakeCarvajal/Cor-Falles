import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class AuthController extends ChangeNotifier {
  static const String _usersKey = 'cor_falles_users';
  static const String _currentUserEmailKey = 'cor_falles_current_user_email';

  AppUser? currentUser;

  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  final List<AppUser> _users = [];

  AuthController() {
    _users.addAll(_defaultUsers());
    _loadFromPrefs();
  }

  List<AppUser> _defaultUsers() {
    return [
      AppUser(
        email: 'admin@corfalles.app',
        username: 'admin',
        location: 'Valencia',
        password: 'admin',
        role: 'organizador',
      ),
      AppUser(
        email: 'demo@corfalles.app',
        username: 'demo',
        location: 'Valencia',
        password: '123456',
        role: 'usuario',
      ),
    ];
  }

  bool get canCreateEvents {
    final role = currentUser?.role;
    return role == 'organizador' || role == 'admin';
  }

  bool emailExists(String email) =>
      _users.any((u) => u.email.toLowerCase() == email.toLowerCase());

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final rawUsers = prefs.getString(_usersKey);

      if (rawUsers != null && rawUsers.isNotEmpty) {
        final decoded = jsonDecode(rawUsers);

        if (decoded is List) {
          _users
            ..clear()
            ..addAll(
              decoded
                  .whereType<Map>()
                  .map((e) => AppUser.fromJson(Map<String, dynamic>.from(e))),
            );
        }
      }

      _ensureDefaultUsers();

      final savedCurrentEmail = prefs.getString(_currentUserEmailKey);
      if (savedCurrentEmail != null && savedCurrentEmail.isNotEmpty) {
        currentUser = _users.cast<AppUser?>().firstWhere(
              (u) => u?.email.toLowerCase() == savedCurrentEmail.toLowerCase(),
              orElse: () => null,
            );
      }
    } catch (_) {
      _users
        ..clear()
        ..addAll(_defaultUsers());
      currentUser = null;
      await _saveUsers();
      await _clearCurrentUser();
    }

    notifyListeners();
  }

  void _ensureDefaultUsers() {
    final defaults = _defaultUsers();

    for (final defaultUser in defaults) {
      final exists = _users.any(
        (u) => u.email.toLowerCase() == defaultUser.email.toLowerCase(),
      );

      if (!exists) {
        _users.add(defaultUser);
      }
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, raw);
  }

  Future<void> _saveCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (currentUser == null) {
      await prefs.remove(_currentUserEmailKey);
      return;
    }

    await prefs.setString(_currentUserEmailKey, currentUser!.email);
  }

  Future<void> _clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserEmailKey);
  }

  void _persistState() {
    _saveUsers();
    _saveCurrentUser();
  }

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

    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Introduce un correo válido.';
    }

    if (emailExists(email)) return 'Ese correo ya está registrado.';

    final newUser = AppUser(
      email: email.trim().toLowerCase(),
      username: username.trim(),
      location: location.trim(),
      password: password,
      role: 'usuario',
    );

    _users.add(newUser);
    currentUser = newUser;

    notifyListeners();
    _persistState();

    return null;
  }

  String? login({required String identifier, required String password}) {
    final id = identifier.trim().toLowerCase();

    if (id.isEmpty || password.isEmpty) {
      return 'Completa usuario y contraseña.';
    }

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
    _saveCurrentUser();

    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
    _clearCurrentUser();
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
