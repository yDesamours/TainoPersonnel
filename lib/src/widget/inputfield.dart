import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  InputField({
    super.key,
    required this.usernameController,
    required this.labelText,
    this.obscureText = false,
    this.required = false,
    this.validator,
    this.icon,
  });

  final TextEditingController usernameController;
  final String labelText;
  final IconData? icon;
  final bool required;
  String? Function(String?)? validator;
  bool obscureText;
  TextStyle style = const TextStyle(
    color: Color.fromARGB(49, 1, 1, 26),
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      labelText: labelText,
      labelStyle: style,
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.only(left: 18.0),
      border: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(50, 0, 0, 128), width: 10.0),
        borderRadius: BorderRadius.zero,
      ),
    );

    return TextFormField(
        controller: usernameController,
        obscureText: obscureText,
        validator: validator,
        decoration: decoration,
        style: style);
  }
}
