import 'package:flutter/material.dart';

import 'package:tainopersonnel/src/widget/apptitle.dart';
import 'package:tainopersonnel/src/widget/loginform.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("imageSuits.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTitle(),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
