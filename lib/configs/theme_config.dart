import 'package:flutter/material.dart';

class ThemeConfig {
  static Color accentColor = const Color(0xff0ABAB5); // main theme color
  static Color accentDarkColor = const Color(0xff56DFCF); // deep theme color
  static Color splashBackground = const Color(0xffFFEDF3);
  static Color fontColor = const Color.fromRGBO(33, 43, 54, 1);
  static Color lightFontColor = const Color.fromRGBO(67, 78, 88, 1);

  //Optional color
  static Color secondaryColor = const Color.fromARGB(255, 5, 229, 233);

//   static Color accentColor=const Color.fromRGBO(78, 181, 41,1);// main theme color
//   static Color accentDarkColor=const Color.fromRGBO(18, 104, 13,1);// deep theme color
//   static Color splashBackground =const Color.fromRGBO(237, 248, 234, 1);
//   static Color fontColor=const Color.fromRGBO(33, 43, 54, 1);
//   static Color lightFontColor=const Color.fromRGBO(67, 78, 88, 1);

// //Optional Color
//   static Color secondaryColor=const Color.fromRGBO(255, 124, 8,1);

  //DO NOT TRY TO CHANGE THIS COLOR'S
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static Color noColor = const Color.fromRGBO(255, 255, 255, 0);
  static Color xxlightGrey = const Color.fromRGBO(243, 245, 247, 1.0);
  static Color xlightGrey = const Color.fromRGBO(239, 239, 239, 1);
  static Color lightGrey = const Color.fromRGBO(209, 209, 209, 1);
  static Color mediumGrey = const Color.fromRGBO(167, 175, 179, 1);
  static Color blueGrey = const Color.fromRGBO(168, 175, 179, 1);
  static Color grey = const Color.fromRGBO(153, 153, 153, 1);
  static Color darkGrey = const Color.fromRGBO(107, 115, 119, 1);
  static Color extraDarkGrey = const Color.fromRGBO(62, 68, 71, 1);
  static Color amberLight = const Color.fromRGBO(254, 234, 209, 1);
  static Color amberMedium = const Color.fromRGBO(254, 240, 215, 1);
  static Color amber = const Color.fromRGBO(255, 124, 8, 1);
  static Color amberShadow = const Color.fromRGBO(255, 168, 0, .4);
  static Color red = const Color.fromRGBO(236, 9, 44, 1);
  static Color green = Colors.green;
  static Color blue = Colors.blue;
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;

  static MaterialColor accentMaterialColor =
      MaterialColor(ThemeConfig.accentColor.value, {
    50: ThemeConfig.accentColor.withOpacity(0.05),
    100: ThemeConfig.accentColor.withOpacity(0.1),
    200: ThemeConfig.accentColor.withOpacity(0.2),
    300: ThemeConfig.accentColor.withOpacity(0.3),
    400: ThemeConfig.accentColor.withOpacity(0.4),
    500: ThemeConfig.accentColor.withOpacity(0.5),
    600: ThemeConfig.accentColor.withOpacity(0.6),
    700: ThemeConfig.accentColor.withOpacity(0.7),
    800: ThemeConfig.accentColor.withOpacity(0.8),
    900: ThemeConfig.accentColor.withOpacity(0.9),
  });
}
