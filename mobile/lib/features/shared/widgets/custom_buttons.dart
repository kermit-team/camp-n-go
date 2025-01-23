import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double width;
  final double height;
  final IconData? prefixIcon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.maxFinite,
    this.height = double.minPositive,
    this.prefixIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: GoogleFonts.montserrat(
          fontSize: Constants.textSizeS,
        ),
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      iconAlignment: IconAlignment.start,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: prefixIcon == null
            ? isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(text, style: AppTextStyles.mainTextStyle())
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    prefixIcon,
                    size: Constants.textSizeMS,
                  ),
                  SizedBox(width: Constants.spaceXS),
                  isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(text, style: AppTextStyles.mainTextStyle()),
                ],
              ),
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
    super.prefixIcon,
    super.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        textStyle: GoogleFonts.montserrat(
          fontSize: Constants.textSizeS,
        ),
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: prefixIcon == null
            ? isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Text(text, style: AppTextStyles.mainTextStyle())
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    prefixIcon,
                    size: Constants.textSizeMS,
                  ),
                  SizedBox(width: Constants.spaceXS),
                  isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Text(text, style: AppTextStyles.mainTextStyle()),
                ],
              ),
      ),
    );
  }
}
