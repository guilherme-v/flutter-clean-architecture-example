import 'package:flutter/material.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/view/character_page.dart';

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
    return const CharacterPage();
  }
}
