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
      )..add(const LoadNextPageEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((HomeBloc b) => b.state.status);
    return status == HomeStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : const HomeViewContent();
  }
}

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({Key? key}) : super(key: key);

  @override
  State<HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((HomeBloc b) => b.state);
    final list = state.characters;

    return ListView.builder(
      controller: _scrollController,
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        return index < list.length
            ? Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(
                    child: Text(list[index].name ?? "no name"),
                  ),
                ),
              )
            : state.hasReachedEnd
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(child: CircularProgressIndicator()),
                  );
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HomeBloc>().add(const LoadNextPageEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
