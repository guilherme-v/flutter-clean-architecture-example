import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/bloc/home_bloc.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        getAllCharacters: context.read<GetAllCharacters>(),
      )..add(const HomeInitEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((HomeBloc b) => b.state.status);
    return status != HomeStatus.success
        ? const CircularProgressIndicator()
        : const HomeViewContent();
  }
}

class HomeViewContent extends StatelessWidget {
  const HomeViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = context.select((HomeBloc b) => b.state.characters);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: Text(list[index].name ?? "no name"),
            ),
          ),
        );
      },
    );
  }
}
