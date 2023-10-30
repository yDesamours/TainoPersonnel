import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    debugShowCheckedModeBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "TainoPersonnel",
      style: TextStyle(
          fontSize: 46, color: Colors.blue, fontWeight: FontWeight.w900),
    );
  }
}
