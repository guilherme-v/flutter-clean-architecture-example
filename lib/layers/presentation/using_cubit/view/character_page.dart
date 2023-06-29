import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/shared/character_card.dart';
import 'package:rickmorty/layers/presentation/using_cubit/cubit/character_page_cubit.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterPageCubit(
        getAllCharacters: context.read<GetAllCharacters>(),
      )..fetchNextPage(),
      child: const CharacterView(),
    );
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends StatelessWidget {
  const CharacterView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((CharacterPageCubit c) => c.state.status);
    return status == CharacterPageStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : const _Content();
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends StatefulWidget {
  const _Content({super.key});

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final list = context.select((CharacterPageCubit b) => b.state.characters);
    final end = context.select((CharacterPageCubit b) => b.state.hasReachedEnd);

    final length = end
        ? list.length
        : list.length % 2 == 0
            ? list.length + 1
            : list.length + 2;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: GridView.builder(
            key: const Key('character_page_list_key'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust the number of columns here
              childAspectRatio: 1 / 1.36,
              crossAxisSpacing: 4,
            ),
            padding: const EdgeInsets.all(8),
            controller: _scrollController,
            itemCount: length,
            itemBuilder: (context, index) {
              if (index < list.length) {
                final char = list[index];
                return CharacterCard(character: char);
              }
              return end
                  ? const SizedBox()
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
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
    if (_isBottom) {
      context.read<CharacterPageCubit>().fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
