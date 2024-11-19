import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoldenTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String? hintText;

  const GoldenTextField({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.hintText,
  });

  @override
  State<GoldenTextField> createState() => _GoldenTextFieldState();
}

class _GoldenTextFieldState extends State<GoldenTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      cursorColor: goldenColor,
      style: GoogleFonts.montserrat(
        color: Colors.black,
      ),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hintText, // Add hintText
        hintStyle: GoogleFonts.montserrat(
          // Style the hint text
          color: Colors.grey, // Example hint color
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: goldenColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: goldenColor),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: goldenColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
