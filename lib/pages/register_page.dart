import 'package:flutter/material.dart';

import '../provider/auth_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();
  final userC = TextEditingController();
  final locC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    pass2C.dispose();
    userC.dispose();
    locC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Registro'),
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
                InputField(hint: 'Correo electrónico*', controller: emailC),
                const SizedBox(height: 12),
                InputField(hint: 'Contraseña*', controller: passC, obscure: true),
                const SizedBox(height: 12),
                InputField(
                    hint: 'Repetir contraseña*', controller: pass2C, obscure: true),
                const SizedBox(height: 12),
                InputField(hint: 'Nombre de usuario*', controller: userC),
                const SizedBox(height: 12),
                InputField(hint: 'Ubicación*', controller: locC),
                const SizedBox(height: 18),
                PrimaryButton(
                  text: 'Registrarse',
                  color: const Color(0xFF00B050),
                  onTap: () {
                    final err = auth.register(
                      email: emailC.text,
                      password: passC.text,
                      password2: pass2C.text,
                      username: userC.text,
                      location: locC.text,
                    );

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
