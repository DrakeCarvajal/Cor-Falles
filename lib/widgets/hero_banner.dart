import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  final double height;
  final String title;
  final String buttonText;
  final String imageUrl;
  final VoidCallback onPressed;

  const HeroBanner({
    super.key,
    required this.height,
    required this.title,
    required this.buttonText,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed, // ✅ clic en toda la tarjeta
          child: SizedBox(
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1E1E1E)),
                ),
                Container(color: Colors.black.withOpacity(0.35)),
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFD54F),
                      height: 0.95,
                      shadows: [
                        Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 0,
                            color: Color(0xFF8B0000)),
                        Shadow(
                            offset: Offset(-2, 2),
                            blurRadius: 0,
                            color: Color(0xFF8B0000)),
                        Shadow(
                            offset: Offset(2, -2),
                            blurRadius: 0,
                            color: Color(0xFF8B0000)),
                        Shadow(
                            offset: Offset(-2, -2),
                            blurRadius: 0,
                            color: Color(0xFF8B0000)),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B4DB3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onPressed, // ✅ botón también abre detalle
                      child: Text(
                        buttonText,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
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
