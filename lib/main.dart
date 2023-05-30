import 'package:flutter/material.dart';
import 'package:rickmorty/layers/presentation/bloc/app.dart';
import 'package:rickmorty/layers/presentation/theme.dart';

enum StateManagersOptions {
  bloc,
  cubit,
  provider,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StateManagersOptions _current;

  @override
  void initState() {
    super.initState();
    _current = StateManagersOptions.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: _current == StateManagersOptions.bloc
          ? const AppUsingBloc()
          : Container(),
    );
  }
}
