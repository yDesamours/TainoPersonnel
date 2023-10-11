// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  bool selected;
  void Function()? onTap;
  IconData? icon;
  ThemeData? theme;
  TextTheme? textTheme;
  int index;
  String title;
  Color? Function(int) color;

  MyTile({
    super.key,
    required this.selected,
    this.onTap,
    required this.color,
    this.theme,
    required this.index,
    this.title = '',
    this.icon,
  }) : textTheme = theme?.textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        selected: selected,
        onTap: onTap,
        selectedTileColor: theme?.primaryColor,
        title: Text(
          title,
          style: textTheme?.bodySmall,
        ),
        leading: Icon(
          icon,
          color: color(index),
        ),
      ),
    );
  }
}
