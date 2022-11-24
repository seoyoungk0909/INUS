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
  static Color darkText = hexStringToColor("#DBDBDB");
  static Color lightText = hexStringToColor("#F5F5F5");
  static Color greyText = hexStringToColor("#7B7D8D");
  // Background Colors
  static Color pageBackgroundDark = hexStringToColor("#121212");
  static Color ticketBackgroundDark = hexStringToColor("#181A20");
  static Color componentBackgroundDark = hexStringToColor("#1F1F1F");
  static Color componentBackgroundDarkblue = hexStringToColor("#181A20");
  // Accent Colors
  static Color accentBlue = hexStringToColor("#2E6CF6");
  static Color accentGreen = hexStringToColor("#5FCC8B");
  static Color accentOrange = hexStringToColor("#E05B33");
  // Button Colors
  static Color greenButtonColor = hexStringToColor("#5FCC8B");
  static Color orangeButtonColor = hexStringToColor("#EB4D3D");
  static Color redButtonColor = hexStringToColor("#EC7B66");
  static Color purpleButtonColor = hexStringToColor("#8851f6");
  static Color transparentButtonColor = hexStringToColor("00FFFFFF");
  // Etc.
  static Color lineColor = hexStringToColor("#343434");
}