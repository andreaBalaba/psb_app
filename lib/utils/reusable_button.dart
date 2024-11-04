import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psb_app/utils/global_variables.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double? horizontal;
  final double vertical;
  final Color? color;
  final Color fontColor;
  final double size;
  final double borderRadius;
  final FontWeight weight;
  final double borderWidth;
  final bool removePadding; // New parameter to control padding

  const ReusableButton({
    super.key,
    this.borderRadius = 0, // Set to zero for no rounded corners
    required this.text,
    this.horizontal,
    this.vertical = 0.0, // Default vertical padding set to zero
    this.color,
    this.onPressed,
    this.size = 20,
    this.weight = FontWeight.w600,
    this.borderWidth = 2,
    this.fontColor = AppColors.pWhiteColor, // Default font color as white
    this.removePadding = false, // Set default to false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: removePadding
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: horizontal ?? 20.0, vertical: vertical),
      child: SizedBox(
        width: double.infinity,
        height: removePadding ? null : 60.0, // Only set height when padding is not removed
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            backgroundColor: color ?? AppColors.pGreenColor,
            padding: EdgeInsets.zero, // Remove extra padding from ElevatedButton
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: weight,
              fontSize: size,
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
