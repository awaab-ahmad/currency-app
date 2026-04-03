import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text gText(String s, Color c, double sz, FontWeight fw) {
  return Text(s, style: GoogleFonts.poppins(
    color: c, 
    fontSize: sz, 
    fontWeight: fw
  ));
}

// making the style of the label and hint text and simple text for TextField

TextStyle textFieldStyle(Color c, double sz) {
  return GoogleFonts.poppins(
    color: c,
    fontSize: sz,
    fontWeight: FontWeight.w600,
  );
}