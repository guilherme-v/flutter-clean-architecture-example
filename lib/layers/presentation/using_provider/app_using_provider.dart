import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_provider/list_page/view/character_page.dart';

class AppUsingProvider extends StatelessWidget {
  const AppUsingProvider({super.key, required this.getAllCharacters});

  final GetAllCharacters getAllCharacters;

  @override
  Widget build(BuildContext context) {
    // - Provides UseCases down to the widget tree using Bloc's D.I widget
    // - Later we'll use it to instantiate each Controller (if needed)
    return MultiProvider(
      providers: [
        Provider.value(value: getAllCharacters),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CharacterPage();
  }
}
