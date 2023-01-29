import 'package:flutter/cupertino.dart';

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}

class ApdiColors {
  // Text Color
  static Color greyText = hexStringToColor("#94929C");
  static Color lightText = hexStringToColor("#F8F8F8");
  // BG Color
  static Color darkBackground = hexStringToColor("#1C1C1C");
  static Color darkerBackground = hexStringToColor("#121212");
  // point colors
  static Color pointGreen = hexStringToColor("#4CA98F");
  static Color pointOrange = hexStringToColor("#EF8632");
  static Color pointMint = hexStringToColor("#56BED2");
  static Color themeGreen = hexStringToColor("#57AD9E");
  static Color pointBlue = hexStringToColor("#4BA7F8");
  // representative colors
  static Color representBlue = hexStringToColor("#587CF7");
  // error colors
  static Color errorRed = hexStringToColor("#EB5545");
  // line color
  static Color lineGrey = hexStringToColor("#2C2C31");
}
