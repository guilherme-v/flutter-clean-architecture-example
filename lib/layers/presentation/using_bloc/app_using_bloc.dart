import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character_page/view/character_page.dart';

class AppUsingBloc extends StatelessWidget {
  const AppUsingBloc({super.key, required this.getAllCharacters});

  final GetAllCharacters getAllCharacters;

  @override
  Widget build(BuildContext context) {
    // - Provides UseCases down to the widget tree using Bloc's D.I widget
    // - Later we'll use it to instantiate each BLOC (if needed)
    // - BLOC and Cubits use the same set of widgets
    return RepositoryProvider.value(
      value: getAllCharacters,
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
