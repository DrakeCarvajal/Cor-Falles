import 'package:flutter/material.dart';

class EventCardMock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  // ✅ NUEVO: altura opcional (para ListView)
  final double? height;

  const EventCardMock({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final card = InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.black12,
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.25), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 54,
                width: double.infinity,
                color: const Color(0xFF0B4DB3),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // ✅ Si height viene definido, acotamos el tamaño (ideal para ListView)
    if (height != null) {
      return SizedBox(height: height, child: card);
    }
    return card;
  }
}
