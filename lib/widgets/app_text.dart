import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontStyle? fontStyle;
  final TextOverflow? overFlow;
  final TextDecoration? textDecoration;
  const AppText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overFlow,
    this.textDecoration,
    this.fontStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
        decorationColor: color,
        fontStyle: fontStyle,
      ),
      maxLines: maxLines,
      overflow: overFlow,
      textAlign: textAlign,
    );
  }
}
