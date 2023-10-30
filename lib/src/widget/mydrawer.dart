// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
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
    Language language = context.watch<AppLanguage>().language;
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
              SizedBox(
                height: 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                  ),
                  child: DrawerHeader(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: MyTile(
                      icon: Logo(
                        content: tenant.logo,
                        alt: tenant.name,
                      ),
                      title: Text(
                        tenant.name,
                        style: textTheme.bodyLarge!
                            .copyWith(color: theme.colorScheme.secondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subTitle: Text(
                        "${user.firstname} ${user.lastname}",
                        style: textTheme.bodyMedium!
                            .copyWith(color: theme.colorScheme.secondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      padding: 2.0,
                    ),
                  ),
                ),
              ),
              MyTile(
                title: Text(
                  language.report,
                  style: theme.textTheme.bodySmall,
                ),
                icon: const Icon(
                  Icons.note,
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
            ]),
          ),
          const Divider(
            thickness: 2.0,
          ),
          MyTile(
            title: Text(
              language.settings,
              style: theme.textTheme.bodySmall,
            ),
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
