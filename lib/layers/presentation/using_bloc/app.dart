import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/theme.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/view/character_page.dart';
import 'package:rickmorty/main.dart';

class AppUsingBloc extends StatelessWidget {
  const AppUsingBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: GetAllCharacters(
        repository: CharacterRepositoryImpl(
          api: ApiImpl(),
          localStorage: LocalStorageImpl(sharedPreferences: sharedPref),
        ),
      ),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: const HomePage(title: "Rick & Morty"),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            widget.title,
            style: textTheme.headlineSmall,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Character',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_history),
            label: 'Location',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv),
            label: 'Episode',
          ),
        ],
      ),
      body: <Widget>[
        const CharacterPage(),
        // Container(
        //   color: Colors.red,
        // ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.orange,
        ),
      ][currentIndex],
    );
  }
}
