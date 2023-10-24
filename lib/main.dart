import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/operation/operation.dart';
import 'package:tainopersonnel/src/pages/home.dart';
import 'package:tainopersonnel/src/pages/connection_page.dart';
import 'package:tainopersonnel/src/pages/startup.dart';

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
      builder: (context, snapshot) => ChangeNotifierProvider<AppState>(
        create: (context) => AppState.fromMemory(snapshot.data!),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            primaryColorLight: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 40,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'arial',
                fontSize: 30,
              ),
              bodySmall: TextStyle(
                fontFamily: 'arial',
                fontSize: 17,
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
              background: const Color.fromARGB(255, 222, 225, 240),
              seedColor: const Color.fromARGB(255, 28, 51, 177),
            ),
          ),
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
