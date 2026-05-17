import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget? errorFallback;

  const EventImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorFallback,
  });

  bool get _isBase64Image => imageUrl.startsWith('data:image');
  bool get _isAssetImage => imageUrl.startsWith('assets/');

  Uint8List? _decodeBase64Image() {
    try {
      final commaIndex = imageUrl.indexOf(',');
      if (commaIndex == -1) return null;
      final raw = imageUrl.substring(commaIndex + 1);
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallback = errorFallback ??
        Container(
          color: Colors.black12,
          child: const Center(
            child: Icon(Icons.image_not_supported),
          ),
        );

    if (_isAssetImage) {
      return Image.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    if (_isBase64Image) {
      final bytes = _decodeBase64Image();
      if (bytes == null) return fallback;

      return Image.memory(
        bytes,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
