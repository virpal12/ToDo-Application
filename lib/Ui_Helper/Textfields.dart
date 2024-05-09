import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Costum {
  static textField(String? text, TextEditingController? Controller,
      TextInputType? keyboardType) {
    return TextField(
      style: TextStyle(backgroundColor: Colors.white),
      controller: Controller,
      cursorColor: Colors.black,
      autofocus: true,
      cursorRadius: Radius.elliptical(1, 1),
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        hintText: text,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue, width: 1),
        ),
      ),
    );
  }
}
