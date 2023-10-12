// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/class/tenant.dart';
import 'package:tainopersonnel/src/widget/mytile.dart';

import '../class/user.dart';

class MyDrawer extends StatelessWidget {
  int selectedIndex;
  void Function(int) setSelected;
  Color? Function(int) color;
  MyDrawer({
    super.key,
    required this.selectedIndex,
    required this.setSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    AppState state = context.watch<AppState>();
    User user = state.user!;
    Tenant tenant = state.tenant!;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tenant.name,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${user.firstname} ${user.lastname}",
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              MyTile(
                title: 'Home',
                selected: selectedIndex == 0,
                color: color,
                theme: theme,
                index: 0,
                icon: Icons.home,
                onTap: () {
                  setSelected(0);
                  Navigator.pop(context);
                },
              ),
              MyTile(
                title: "Report",
                selected: selectedIndex == 1,
                color: color,
                theme: theme,
                index: 1,
                icon: Icons.note,
                onTap: () {
                  setSelected(1);
                  Navigator.pop(context);
                },
              ),
              MyTile(
                title: "My time",
                selected: selectedIndex == 2,
                color: color,
                theme: theme,
                index: 2,
                icon: Icons.calendar_month,
                onTap: () {
                  setSelected(2);
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
          const Divider(
            thickness: 2.0,
          ),
          MyTile(
            title: "Settings",
            selected: selectedIndex == 3,
            color: color,
            theme: theme,
            index: 3,
            icon: Icons.settings,
            onTap: () {
              setSelected(3);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
