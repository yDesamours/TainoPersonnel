import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/state.dart';

class ConnectionStateShower extends StatelessWidget {
  const ConnectionStateShower({super.key});

  @override
  Widget build(BuildContext context) {
    Language language = context.watch<AppLanguage>().language;
    ConnectivityState connection = context.watch<ConnectivityState>();
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return connection.isOnline != true
        ? Container(
            color: theme.colorScheme.error,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              language.offline,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ))
        : Container();
  }
}
