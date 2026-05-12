import 'package:flutter/material.dart';

import '../provider/auth_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idC = TextEditingController();
  final passC = TextEditingController();

  @override
  void dispose() {
    idC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputField(
                  hint: 'Correo electrónico o nombre de usuario',
                  controller: idC,
                ),
                const SizedBox(height: 12),
                InputField(hint: 'Contraseña', controller: passC, obscure: true),
                const SizedBox(height: 18),
                PrimaryButton(
                  text: 'Iniciar sesión',
                  color: const Color(0xFF00B050),
                  onTap: () {
                    final err = auth.login(identifier: idC.text, password: passC.text);
                    if (err != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(err)));
                      return;
                    }
                    Navigator.popUntil(context, (r) => r.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
