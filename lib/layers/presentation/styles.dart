import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Colors
// -----------------------------------------------------------------------------
abstract class AppColors {
  static const normalColors = [
    Color(0xFF71FDBF),
    Color(0xFFCE33FF),
    normalRed,
  ];

  static const emitColors = [
    emitGreen,
    Color(0xFF00FFFF),
    Color(0xFFFF993E),
  ];

  static const emitGreen = Color(0xFF96FF33);
  static const normalRed = Color(0xFFFF5033);
}

// -----------------------------------------------------------------------------
// Typography
// -----------------------------------------------------------------------------
class TextStyles {
  static const _font1 = TextStyle(fontFamily: 'Exo', color: Colors.white);

  static TextStyle get h1 => _font1.copyWith(
        fontSize: 24,
        letterSpacing: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get h2 => h1.copyWith(
        fontSize: 16,
        letterSpacing: 0,
      );

  static TextStyle get h3 => h1.copyWith(
        fontSize: 12,
        letterSpacing: 1,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get body => _font1.copyWith(
        fontSize: 10,
      );

  static TextStyle get btn => _font1.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 10,
      );
}
