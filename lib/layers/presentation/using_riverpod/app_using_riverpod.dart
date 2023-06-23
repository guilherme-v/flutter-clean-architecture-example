import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/view/character_page.dart';

import '../shared/home_page.dart';

class AppUsingRiverpod extends StatelessWidget {
  const AppUsingRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage(
      title: "Rick & Morty - Riverpod",
      body: CharacterPage(),
    );
  }
}
