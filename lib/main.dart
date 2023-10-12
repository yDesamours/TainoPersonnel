import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/data/database.dart';
import 'package:tainopersonnel/src/pages/app_page.dart';
import 'package:tainopersonnel/src/pages/connection_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 40,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'arial',
              fontSize: 30,
            )),
        colorScheme: ColorScheme.fromSeed(
          background: const Color.fromARGB(255, 222, 225, 240),
          seedColor: const Color.fromARGB(255, 28, 51, 177),
        ),
      ),
      home: FutureBuilder(
        future: TainoPersonnelDatabase.getUser(),
        builder: (context, snapshot) => ChangeNotifierProvider(
          create: (context) => AppState(snapshot.data),
          child: const SafeArea(
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
