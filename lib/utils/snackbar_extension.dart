
import 'package:flutter/material.dart';

extension ShowSnackbar on BuildContext {
   void showSnackbar({
    required String message,
    Color backgroundColor = Colors.white
   }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),        
    );
   }
}