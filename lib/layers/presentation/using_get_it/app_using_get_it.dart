import 'package:flutter/material.dart';
import 'package:rickmorty/layers/presentation/using_get_it/view/character_page.dart';

import '../shared/home_page.dart';

class AppUsingGetIt extends StatelessWidget {
  const AppUsingGetIt({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage(
      title: "Rick & Morty - GetIt",
      body: CharacterPage(),
    );
  }
}
