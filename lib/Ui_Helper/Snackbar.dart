import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class snackbar {
  static snack_bar (BuildContext context , String title, message, ContentType ? contentType) {
    final snackBar = SnackBar(

      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,color:Colors.teal,titleFontSize: 25,
        message: message,

        contentType: contentType!,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

}