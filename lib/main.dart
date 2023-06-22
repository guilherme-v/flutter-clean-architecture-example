import 'package:flutter/material.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/theme.dart';
import 'package:rickmorty/layers/presentation/using_cubit/app_using_cubit.dart';
import 'package:rickmorty/layers/presentation/using_get_it/app_using_get_it.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StateManagementOptions {
  bloc,
  cubit,
  provider,
  riverpod,
  getIt,
  mobX,
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
  late StateManagementOptions _current;
  late GetAllCharacters _getAllCharacters;

  @override
  void initState() {
    super.initState();
    _current = StateManagementOptions.mobX;

    // Notice:
    //
    // Some state management packages are also D.I. (Dependency Injection)
    // solutions. To avoid polluting this example with unnecessary repetition,
    // we're creating the object instances here and passing them as parameters
    // to each state management's "root" widgets. Then we'll use the library's
    // specific D.I. widget to make the instance accessible to the rest of the
    // widget tree.
    //
    final api = ApiImpl();
    final localStorage = LocalStorageImpl(sharedPreferences: sharedPref);
    final repo = CharacterRepositoryImpl(api: api, localStorage: localStorage);

    _getAllCharacters = GetAllCharacters(repository: repo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: _current == StateManagementOptions.mobX
          // ? AppUsingCubit(getAllCharacters: _getAllCharacters)
          ? const AppUsingGetIt()
          : Container(),
    );
  }
}
