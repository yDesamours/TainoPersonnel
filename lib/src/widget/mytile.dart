// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  void Function()? onTap;
  Widget? icon;
  String title;
  TextStyle? textTheme;

  MyTile({
    super.key,
    this.onTap,
    this.title = '',
    this.icon,
    this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: onTap,
        selectedTileColor: theme.primaryColor,
        title: Text(
          title,
          style: textTheme ?? theme.textTheme.bodySmall,
        ),
        leading: icon,
      ),
    );
  }
}
