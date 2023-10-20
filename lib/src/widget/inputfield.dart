// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.obscureText = false,
      this.required = false,
      this.validator,
      this.icon,
      this.content = '',
      this.expands = false});

  final TextEditingController controller;
  String content = '';
  bool expands;
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
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: decoration,
      style: style,
      maxLines: expands ? double.maxFinite.floor() : 1,
    );
  }
}

class DateSelection extends StatelessWidget {
  DateSelection({
    super.key,
    required this.controller,
    this.labelText = '',
    this.date,
  });

  TextStyle style = const TextStyle(
    color: Color.fromARGB(49, 1, 1, 26),
    fontSize: 16,
  );

  final TextEditingController controller;
  String labelText;
  DateTime? date;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = picked.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      labelText: labelText,
      labelStyle: style,
      suffixIcon: IconButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shape: null),
        onPressed: () => _selectDate(context),
        icon: const Icon(Icons.calendar_today),
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
      controller: controller,
      decoration: decoration,
      style: style,
      readOnly: true,
    );
  }
}
