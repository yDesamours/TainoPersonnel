// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/class/api.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/class/user.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/widget/mytile.dart';

import '../utils/utils.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;

  const MyAppBar({Key? key, required this.theme}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();
    User user = state.user!;
    return AppBar(
      centerTitle: true,
      backgroundColor: theme.primaryColor,
      title: const Image(
        image: AssetImage("assets/tainopersonnel.png"),
        height: 40,
      ),
      actions: [
        PopupMenuButton<AppBarActions>(
          position: PopupMenuPosition.under,
          onSelected: (value) async {
            switch (value) {
              case AppBarActions.logout:
                if (await confirmationRequest(context)) {
                  API.logout(user.token);
                  operation.logout(user.token, state);
                }
              case AppBarActions.profile:
            }
          },
          child: Logo(content: '${user.firstname} ${user.lastname}'),
          itemBuilder: (context) => [
            PopupMenuItem<AppBarActions>(
              value: AppBarActions.profile,
              child: MyTile(
                title: "Profile",
                theme: theme,
                selected: false,
                color: (int _) => theme.primaryColor,
                index: 0,
                icon: Icons.person,
              ),
            ),
            PopupMenuItem<AppBarActions>(
              value: AppBarActions.logout,
              child: MyTile(
                title: "Log Out",
                theme: theme,
                selected: false,
                color: (int _) => theme.primaryColor,
                index: 0,
                icon: Icons.logout,
              ),
            )
          ],
        )
      ],
    );
  }
}

enum AppBarActions { profile, logout }

class Logo extends StatelessWidget {
  String content;
  String alt;
  bool image;
  Logo({super.key, content, this.image = false, this.alt = 'T'})
      : content = content ?? '';

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (content == '' || !image) {
      widget = DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              alt[0],
            ),
          ),
        ),
      );
    } else {
      List<int> imageBytes = base64.decode(content);
      widget = Image.memory(
        Uint8List.fromList(imageBytes),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: widget,
    );
  }
}
