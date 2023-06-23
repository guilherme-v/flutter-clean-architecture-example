import 'package:flutter/material.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/theme.dart';
import 'package:rickmorty/layers/presentation/using_bloc/app_using_bloc.dart';
import 'package:rickmorty/layers/presentation/using_cubit/app_using_cubit.dart';
import 'package:rickmorty/layers/presentation/using_get_it/app_using_get_it.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:rickmorty/layers/presentation/using_mobx/app_using_mobx.dart';
import 'package:rickmorty/layers/presentation/using_provider/app_using_provider.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/app_using_riverpod.dart';
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
  late StateManagementOptions _currentOption;
  late GetAllCharacters _getAllCharacters;

  @override
  void initState() {
    super.initState();
    _currentOption = StateManagementOptions.bloc;

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
      home: Builder(
        builder: (context) {
          final textTheme = Theme.of(context)
              .textTheme
              .apply(displayColor: Theme.of(context).colorScheme.onSurface);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              title: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _getTitle(_currentOption),
                  style: textTheme.headlineSmall,
                ),
              ),
              actions: [
                PopupMenuButton<StateManagementOptions>(
                  itemBuilder: (context) => [
                    _createMenuEntry(
                      StateManagementOptions.bloc,
                      'Bloc',
                    ),
                    _createMenuEntry(
                      StateManagementOptions.cubit,
                      'Cubit',
                    ),
                    _createMenuEntry(
                      StateManagementOptions.mobX,
                      'MobX',
                    ),
                    _createMenuEntry(
                      StateManagementOptions.getIt,
                      'GetIT',
                    ),
                    _createMenuEntry(
                      StateManagementOptions.provider,
                      'Provider',
                    ),
                    _createMenuEntry(
                      StateManagementOptions.riverpod,
                      'Riverpod',
                    ),
                  ],
                  onSelected: (value) {
                    setState(() {
                      _currentOption = value;
                    });
                  },
                ),
              ],
            ),
            body: _getBody(_currentOption, _getAllCharacters),
          );
        },
      ),
    );
  }

  String _getTitle(StateManagementOptions option) {
    switch (option) {
      case (StateManagementOptions.bloc):
        return 'Rick & Morty - BLOC';
      case (StateManagementOptions.cubit):
        return 'Rick & Morty - Cubit';
      case (StateManagementOptions.mobX):
        return 'Rick & Morty - Mobx';
      case (StateManagementOptions.getIt):
        return 'Rick & Morty - GetIt';
      case (StateManagementOptions.provider):
        return 'Rick & Morty - Provider';
      case (StateManagementOptions.riverpod):
        return 'Rick & Morty - Riverpod';
      default:
        return 'Invalid option';
    }
  }

  Widget _getBody(
    StateManagementOptions option,
    GetAllCharacters getAllCharacters,
  ) {
    switch (option) {
      case (StateManagementOptions.bloc):
        return AppUsingBloc(getAllCharacters: getAllCharacters);
      case (StateManagementOptions.cubit):
        return AppUsingCubit(getAllCharacters: getAllCharacters);
      case (StateManagementOptions.mobX):
        return AppUsingMobX(getAllCharacters: getAllCharacters);
      case (StateManagementOptions.getIt):
        return const AppUsingGetIt();
      case (StateManagementOptions.provider):
        return AppUsingProvider(getAllCharacters: getAllCharacters);
      case (StateManagementOptions.riverpod):
        return const AppUsingRiverpod();
      default:
        return Container();
    }
  }

  PopupMenuItem<StateManagementOptions> _createMenuEntry(
    StateManagementOptions option,
    String text,
  ) {
    final isSelected = _currentOption == option;
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return PopupMenuItem<StateManagementOptions>(
      value: option,
      child: Text(
        isSelected ? 'using $text' : 'use $text',
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}
