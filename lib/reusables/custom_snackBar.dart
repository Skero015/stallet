import 'package:flutter/material.dart';

SnackBar CustomSnackBar (Color textColor, Color? bgColor, String content, String label, VoidCallback onPressed) {
  return SnackBar(
    content: Text(content),
    action: SnackBarAction(
      label: label,
      textColor: textColor,
      onPressed: onPressed,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    backgroundColor: bgColor,
  );
}