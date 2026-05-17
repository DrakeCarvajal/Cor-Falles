import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color _yellow = Color(0xFFF7D96B);
  static const Color _red = Color(0xFF8B0000);
  static const Color _softCard = Color(0xFFFFFBF5);
  static const Color _accent = Color(0xFFFF6B5C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final medium = constraints.maxWidth >= 700;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 11,
                              child: _buildAuthCard(context, compact: false),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 9,
                              child: _buildBrandPanel(),
                            ),
                          ],
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: medium ? 520 : 420,
                            ),
                            child: _buildAuthCard(
                              context,
                              compact: true,
                            ),
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context, {required bool compact}) {
    return Container(
      padding: EdgeInsets.all(compact ? 20 : 28),
      decoration: BoxDecoration(
        color: _softCard,
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
            width: compact ? 88 : 96,
            height: compact ? 88 : 96,
            decoration: BoxDecoration(
              color: _yellow,
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
              Icons.local_fire_department,
              size: 52,
              color: _accent,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Bienvenido a Cor Falles',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _red,
              fontSize: compact ? 28 : 34,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Accede o crea una cuenta para explorar eventos, mapa y calendario fallero.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.72),
              fontSize: compact ? 16 : 17,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 26),
          _WelcomeButton(
            text: 'Iniciar sesión',
            icon: Icons.login,
            backgroundColor: _red,
            foregroundColor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
          ),
          const SizedBox(height: 12),
          _WelcomeButton(
            text: 'Registrarte',
            icon: Icons.person_add_alt_1,
            backgroundColor: Colors.white,
            foregroundColor: _red,
            borderColor: _red.withOpacity(0.30),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
          ),
          const SizedBox(height: 12),
          _WelcomeButton(
            text: 'Continuar con Google',
            icon: Icons.account_circle_outlined,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            borderColor: Colors.black.withOpacity(0.12),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Google Sign-In: pendiente (sin acción por ahora).',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: _yellow.withOpacity(0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _red.withOpacity(0.10),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Cuentas de prueba',
                  style: TextStyle(
                    color: _red,
                    fontSize: compact ? 15 : 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'admin - admin@corfalles.app / admin \n demo - demo@corfalles.app / 123456',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _red.withOpacity(0.16),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: _yellow.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              size: 112,
              color: _accent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tu agenda fallera en una sola app',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _red,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Consulta eventos, ubícalos en el mapa, revisa el calendario y organiza tus planes durante las Fallas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.72),
              fontSize: 17,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: const [
              _InfoChip(icon: Icons.event, text: 'Eventos'),
              _InfoChip(icon: Icons.map, text: 'Mapa'),
              _InfoChip(icon: Icons.calendar_month, text: 'Calendario'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _WelcomeButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: backgroundColor == Colors.white ? 0 : 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.2)
                : BorderSide.none,
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Color(0xFF8B0000)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF8B0000),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
