// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    super.key,
    required this.canPress,
    required this.loginFunction,
    required this.icon,
  });

  final bool canPress;
  final Function() loginFunction;
  Widget icon;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.canPress
          ? () async {
              setState(() {
                isLoading = true;
              });
              await widget.loginFunction();
              setState(() {
                isLoading = false;
              });
            }
          : null,
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(200, 33, 150, 243),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : widget.icon,
    );
  }
}
