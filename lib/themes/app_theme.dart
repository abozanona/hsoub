import 'package:flutter/material.dart';

class AppTheme {
  static const int primary = 0xFFF5602A;
  static const int secondary = 0xFF848484;
  static const int normalText = 0xFF848484;
  static const int linkText = 0xFF8CCEE1;
  static const int backgroundColor = 0xFFEFEFEF;
  static const int colorVotePositive = 0xFF8CCEE1;
  static const int colorVoteNegative = 0xFFF5602A;
  static const double iconSize = 20;

  static TextStyle textStyle({
    Color color = const Color(normalText),
    double fontSize = 13,
    String fontFamily = 'cairo',
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      decoration: TextDecoration.none,
    );
  }
}
