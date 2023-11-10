import 'package:flutter/material.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/list_page/view/character_page.dart';

class AppUsingRiverpod extends StatelessWidget {
  const AppUsingRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    // In order to make Riverpod works correctly with the default
    // Material Widget's Navigator, we've moved the 'ProviderScope' to the
    // 'main.dart' file
    //
    // return const ProviderScope(child: AppView());
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
