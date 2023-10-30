// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  void Function()? onTap;
  Widget? icon, subTitle;
  Text title;
  TextStyle? textTheme;
  double padding;

  MyTile({
    super.key,
    this.onTap,
    required this.title,
    this.subTitle,
    this.icon,
    this.textTheme,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon!,
            Expanded(
              child: ListTile(
                onTap: onTap,
                selectedTileColor: theme.primaryColor,
                title: title,
                subtitle: subTitle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
