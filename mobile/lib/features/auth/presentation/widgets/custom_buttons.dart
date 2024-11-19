import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.maxFinite,
    this.height = double.minPositive,
    this.backgroundColor = goldenColor, // Default to transparent
    this.textColor = Colors.white, // Default to black
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        textStyle: GoogleFonts.montserrat(
          fontSize: 15,
        ),
        minimumSize: Size(width, height),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: goldenColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(text),
      ),
    );
  }
}

class CustomButtonInverted extends CustomButton {
  const CustomButtonInverted({
    super.key,
    required super.text,
    required super.onPressed,
    super.width,
    super.height,
  }) : super(
          backgroundColor: Colors.white, // White background
          textColor: Colors.black, // Golden text color
        );
}
