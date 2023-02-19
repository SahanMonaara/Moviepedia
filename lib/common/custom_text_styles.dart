import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// It's a class that contains static methods that return TextStyle objects
class CustomTextStyles {
  static TextStyle titleStyle() {
    return GoogleFonts.nunito(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  }

  static TextStyle movieTitle() {
    return GoogleFonts.nunito(
        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 30);
  }

  static TextStyle subTitleStyle() {
    return GoogleFonts.nunito(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle regularStyle() {
    return GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }
}
