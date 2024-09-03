import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      color: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFF8B8B8B),
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFF8B8B8B),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ).displaySmall);
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge: TextStyle(
      color: kTextColor,
    ),
    bodyMedium: TextStyle(
      color: kTextColor,
    ),
  );
}
