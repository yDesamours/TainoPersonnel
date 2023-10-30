import "package:flutter/material.dart";

import "package:tainopersonnel/src/widget/appbar.dart";
import 'package:tainopersonnel/src/widget/connection_state.dart';
import "package:tainopersonnel/src/widget/mydrawer.dart";

class AppPage extends StatefulWidget {
  const AppPage({super.key});
  @override
  State<AppPage> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  var selectedIndex = 0;
  late Color tileColor;

  void setSelected(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    tileColor = theme.primaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(theme: theme),
      drawer: const MyDrawer(),
      body: const Column(
        children: [
          ConnectionStateShower(),
        ],
      ),
    );
  }
}
