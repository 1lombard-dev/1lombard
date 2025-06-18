import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lombard/src/core/theme/resources.dart';


class LombardText extends StatelessWidget {
  const LombardText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.black,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.textOverFlow,
  });
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final TextOverflow? textOverFlow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverFlow,
      textAlign: textAlign,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
      ),
    );
  }
}
