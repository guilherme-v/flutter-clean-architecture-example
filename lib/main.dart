import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/presentation/theme.dart';
import 'package:rickmorty/layers/presentation/using_get_it/app.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StateManagerOptions {
  bloc,
  cubit,
  provider,
  riverpod,
  getIt,
}

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  initializeGetIt();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StateManagerOptions _current;

  @override
  void initState() {
    super.initState();
    _current = StateManagerOptions.getIt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: _current == StateManagerOptions.getIt
          ? const AppUsingGetIt()
          : Container(),
    );
  }
}
