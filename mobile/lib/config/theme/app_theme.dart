import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0XFFAE9560),
  );
}

TextStyle titleTextStyle() {
  return GoogleFonts.playfairDisplay(
    fontSize: 40,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  );
}

TextStyle subtitleTextStyle() {
  return GoogleFonts.montserrat(
    fontSize: 15,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  );
}

const goldenColor = Color(0xFFAE9560);
