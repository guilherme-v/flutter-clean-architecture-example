import 'package:flutter/material.dart';

class LitImage extends StatelessWidget {
  const LitImage({
    super.key,
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
    required this.fit,
    required this.scale,
  });

  final Color color;
  final String imgSrc;
  final double lightAmt;
  final BoxFit fit;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return Image.asset(
      imgSrc,
      color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
      colorBlendMode: BlendMode.modulate,
      fit: fit,
      scale: scale,
    );
  }
}
