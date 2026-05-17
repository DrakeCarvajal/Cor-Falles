import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';
import '../widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idC = TextEditingController();
  final passC = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
    idC.dispose();
    passC.dispose();
    super.dispose();
  }

  void _submit() {
    final auth = AuthScope.of(context);
    final error = auth.login(
      identifier: idC.text,
      password: passC.text,
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
        title: const Text('Iniciar sesión'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
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
                        Icons.login,
                        size: 46,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Accede a tu cuenta',
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
                      'Introduce tu correo o nombre de usuario y tu contraseña.',
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
                      hint: 'Correo electrónico o nombre de usuario',
                      controller: idC,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      hint: 'Contraseña',
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
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: red.withOpacity(0.10),
                        ),
                      ),
                      child: const Text(
                        'También puedes entrar con:\nadmin - admin@corfalles.app / admin\ndemo - demo@corfalles.app / 123456',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
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
