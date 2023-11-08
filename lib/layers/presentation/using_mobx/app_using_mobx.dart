import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

import 'package:rickmorty/layers/presentation/using_mobx/list_page/view/character_page.dart';

class AppUsingMobX extends StatelessWidget {
  const AppUsingMobX({super.key, required this.getAllCharacters});

  final GetAllCharacters getAllCharacters;

  @override
  Widget build(BuildContext context) {
    //
    // It Provides UseCases down to the widget tree using Bloc's D.I widget.
    //
    // MobX doesn't have a widget that allow us to provide dependencies,
    // because of that it's hard to decouple things properly when using it.
    // E.g.: Inject dependencies in Store's constructors.
    //
    // MobX recommendation is to use 'Provider':
    // https://mobx.netlify.app/guides/stores#the-triad-of-widget---store---service
    // But here we've used Bloc's Repository widget
    //
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
