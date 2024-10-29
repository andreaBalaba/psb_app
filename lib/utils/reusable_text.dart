import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({
    super.key,
    required this.text,
    this.size = 15,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black,
    this.align,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.wordSpacing,
    this.foreground, TextDecoration? decoration, // New foreground parameter
  });

  final String text;
  final double? size;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;
  final Paint? foreground; // New parameter for custom Paint effects

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        color: foreground == null ? color : null, // Use color if no foreground
        height: height,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        foreground: foreground, // Apply foreground Paint if provided
      ),
    );
  }
}
