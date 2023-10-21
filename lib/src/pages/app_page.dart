import "package:flutter/material.dart";
import "package:tainopersonnel/src/pages/reportpage.dart";

import "package:tainopersonnel/src/widget/appbar.dart";
import "package:tainopersonnel/src/widget/mydrawer.dart";

class AppPage extends StatefulWidget {
  const AppPage({super.key});
  @override
  State<AppPage> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  var selectedIndex = 0;
  late Color tileColor;

  List<Widget> pages = const [
    Placeholder(color: Colors.white24),
    ReportPage(),
    Placeholder(color: Colors.purple),
    Placeholder(color: Colors.deepPurpleAccent)
  ];

  Color? tileChildColor(int selected) {
    return selected == selectedIndex ? Colors.white : tileColor;
  }

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
      drawer: MyDrawer(
          selectedIndex: selectedIndex,
          setSelected: setSelected,
          color: tileChildColor),
      body: pages[selectedIndex],
    );
  }
}
