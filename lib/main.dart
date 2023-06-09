import 'package:flutter/material.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/presentation/bloc/app.dart';
import 'package:rickmorty/layers/presentation/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StateManagerOptions {
  bloc,
  cubit,
  provider,
}

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
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
    _current = StateManagerOptions.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: _current == StateManagerOptions.bloc
          ? const AppUsingBloc()
          : Container(),
    );
  }
}
