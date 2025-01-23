import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

ThemeData theme({bool isDarkTheme = false}) => ThemeData.from(
      colorScheme: _lightColorScheme,
    ).copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 22.sp,
        ),
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

  static TextStyle subtitleTextStyle({
    Color? color,
    bool isUnderlined = false,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: Constants.textSizeM,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: color ?? _lightColorScheme.onSurface,
        decoration: isUnderlined ? TextDecoration.underline : null,
        decorationColor: _lightColorScheme.primary,
        decorationThickness: 2,
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

  static TextStyle customTextStyle({
    Color? color,
    double? fontSize,
    bool isBold = false,
    bool isUnderlined = false,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize ?? Constants.textSizeS,
      fontStyle: FontStyle.normal,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      color: color ?? _lightColorScheme.onSurface,
      decoration: isUnderlined ? TextDecoration.underline : null,
      decorationColor: _lightColorScheme.primary,
      decorationThickness: 1,
    );
  }

  static errorTextStyle({double? fontSize}) => GoogleFonts.montserrat(
        fontSize: fontSize ?? Constants.textSizeS,
        fontStyle: FontStyle.normal,
        color: _lightColorScheme.error,
      );
}
