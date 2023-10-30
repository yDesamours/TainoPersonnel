import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pvd;
import 'package:tainopersonnel/src/intl/intl.dart';

import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/operation/operation.dart';
import 'package:tainopersonnel/src/pages/home.dart';
import 'package:tainopersonnel/src/pages/connection_page.dart';
import 'package:tainopersonnel/src/pages/startup.dart';
import 'package:tainopersonnel/src/theme/theme.dart' as theme;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: launchApp(),
      builder: (ctx, snapshot) => pvd.MultiProvider(
        providers: [
          pvd.ChangeNotifierProvider(
              create: (ctx) => AppState.fromMemory(snapshot.data!)),
          pvd.ChangeNotifierProvider(create: (ctx) => ConnectivityState()),
          pvd.ChangeNotifierProvider<AppLanguage>(
            create: (ctx) => AppLanguage(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Namer App',
          theme: theme.lightTheme,
          home: snapshot.connectionState == ConnectionState.waiting
              ? const StartUpPage()
              : const SafeArea(
                  child: MainPage(),
                ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();

    Widget page = state.user != null ? const AppPage() : const ConnectionPage();
    return page;
  }
}
