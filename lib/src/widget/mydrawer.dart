// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/model/tenant.dart';
import 'package:tainopersonnel/src/pages/reportpage.dart';
import 'package:tainopersonnel/src/widget/appbar.dart';
import 'package:tainopersonnel/src/widget/mytile.dart';

import '../model/user.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
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
            flex: 2,
            child: ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Color.alphaBlend(
                  theme.primaryColor,
                  Colors.deepPurpleAccent,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Logo(
                          content: tenant.logo,
                          alt: tenant.name,
                        ),
                        Expanded(
                          child: Text(
                            tenant.name,
                            style: textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        "${user.firstname} ${user.lastname}",
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              MyTile(
                title: "Report",
                icon: Icon(
                  Icons.note,
                  color: theme.primaryColor,
                ),
                onTap: () {
                  //  setSelected(1);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportPage()));
                },
              ),
              MyTile(
                title: "My time",
                textTheme: textTheme.bodySmall,
                icon: Icon(
                  Icons.calendar_month,
                  color: theme.primaryColor,
                ),
                onTap: () {
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
            icon: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
