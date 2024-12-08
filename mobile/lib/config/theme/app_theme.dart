import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme({bool isDarkTheme = false}) => ThemeData.from(
      colorScheme: _lightColorScheme,
    ).copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );

const goldenColor = Color(0xFFAE9560);

ColorScheme _lightColorScheme = const ColorScheme(
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
  onSurfaceVariant: Colors.grey,
);

class AppTextStyles {
  //todo: dodać obsługę context i pobieranie na podstawie ustawienia urządzenia
  static TextStyle titleTextStyle() => GoogleFonts.playfairDisplay(
        fontSize: Constants.textSizeL,
        fontStyle: FontStyle.normal,
        color: _lightColorScheme.onSurface,
      );

  static TextStyle mainTextStyle() => GoogleFonts.montserrat(
        fontSize: Constants.textSizeS,
        fontStyle: FontStyle.normal,
      );

  static TextStyle hintTextStyle() => GoogleFonts.montserrat(
        fontSize: Constants.textSizeS,
        fontStyle: FontStyle.normal,
        color: _lightColorScheme.onSurfaceVariant,
      );

  static TextStyle customTextStyle({Color? color}) {
    return GoogleFonts.montserrat(
      fontSize: Constants.textSizeS,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }
}
