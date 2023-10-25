// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  void Function()? onTap;
  Widget? icon;
  String title, subTitle;
  TextStyle? textTheme;

  MyTile({
    super.key,
    this.onTap,
    this.title = '',
    this.subTitle = '',
    this.icon,
    this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<Text> children = [
      Text(
        title,
        style: textTheme ?? theme.textTheme.bodyMedium,
      ),
    ];

    if (subTitle.isNotEmpty) {
      children.add(Text(
        subTitle,
        style: theme.textTheme.bodyMedium,
      ));
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: onTap,
        selectedTileColor: theme.primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        leading: icon,
      ),
    );
  }
}
