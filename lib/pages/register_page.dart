import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';
import '../widgets/input_field.dart';

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
  final locationC = TextEditingController();

  bool _hidePassword = true;
  bool _hidePassword2 = true;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    pass2C.dispose();
    userC.dispose();
    locationC.dispose();
    super.dispose();
  }

  void _submit() {
    final auth = AuthScope.of(context);
    final error = auth.register(
      email: emailC.text,
      password: passC.text,
      password2: pass2C.text,
      username: userC.text,
      location: locationC.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);
    const red = Color(0xFF8B0000);
    const softCard = Color(0xFFFFFBF5);
    const accent = Color(0xFFFF6B5C);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: red,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: softCard,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 44,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Crea tu cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: red,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Regístrate para acceder al mapa, calendario y gestión de eventos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.72),
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      hint: 'Correo electrónico*',
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      hint: 'Contraseña*',
                      controller: passC,
                      obscure: _hidePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      hint: 'Repetir contraseña*',
                      controller: pass2C,
                      obscure: _hidePassword2,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _hidePassword2 = !_hidePassword2;
                          });
                        },
                        icon: Icon(
                          _hidePassword2
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      hint: 'Nombre de usuario*',
                      controller: userC,
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      hint: 'Ubicación*',
                      controller: locationC,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _submit,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Registrarte',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
