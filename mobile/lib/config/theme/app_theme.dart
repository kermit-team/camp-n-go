import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme({bool isDarkTheme = false}) => ThemeData.from(
      colorScheme: lightColorScheme,
    ).copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );

TextStyle titleTextStyle() {
  return GoogleFonts.playfairDisplay(
    fontSize: Constants.textSizeL,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  );
}

TextStyle subtitleTextStyle() {
  return GoogleFonts.montserrat(
    fontSize: Constants.textSizeS,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  );
}

TextStyle mainTextStyle({Color? color}) {
  return GoogleFonts.montserrat(
    fontSize: Constants.textSizeS,
    fontStyle: FontStyle.normal,
    color: color ?? Colors.black,
  );
}

const goldenColor = Color(0xFFAE9560);

ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0XFFAE9560),
  onPrimary: Colors.white,
  secondary: Colors.white,
  onSecondary: Colors.black,
  tertiary: Color(0xFF6F84B5),
  onTertiary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
);
