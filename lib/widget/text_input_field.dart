import 'package:flutter/material.dart';
import 'package:songhogame/constants.dart';

class TextInputFeild extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isObscure;
  const TextInputFeild({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: Colors.blueAccent,
        ),
        labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
