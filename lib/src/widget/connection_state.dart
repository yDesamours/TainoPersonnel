import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/state.dart';

class ConnectionStateShower extends StatelessWidget {
  const ConnectionStateShower({super.key});

  @override
  Widget build(BuildContext context) {
    Language language = context.watch<AppLanguage>().language;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Consumer<ConnectivityState>(
      builder: (context, myState, child) {
        if (!myState.isOnline) {
          return Container(
            color: theme.colorScheme.error,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              language.offline,
              style: textTheme.bodySmall,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
