import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final yellow = const Color(0xFFF7D96B);
    final red = const Color(0xFF8B0000);

    return Scaffold(
      backgroundColor: yellow,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Bienvenido a Cor Falles',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        text: 'Registrarte',
                        color: red,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Iniciar Sesión',
                        color: red,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Iniciar Sesión con Google',
                        color: red,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Google Sign-In: pendiente (sin acción por ahora).'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tip: Usa demo@corfalles.app / 123456',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.local_fire_department,
                      size: 200,
                      color: Colors.redAccent.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
