import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/notifier/character_page_state.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/providers.dart';

import '../../shared/character_card.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CharacterView();
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends ConsumerStatefulWidget {
  const CharacterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CharacterViewState();
}

class _CharacterViewState extends ConsumerState<CharacterView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(characterPageStateProvider.notifier).fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterPageStateProvider);

    return state.status == CharacterPageStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : _Content(
            list: state.characters,
            hasReachedEnd: state.hasReachedEnd,
          );
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends ConsumerStatefulWidget {
  const _Content({
    super.key,
    required this.list,
    required this.hasReachedEnd,
  });

  final List<Character> list;
  final bool hasReachedEnd;

  @override
  ConsumerState<_Content> createState() => __ContentState();
}

class __ContentState extends ConsumerState<_Content> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.list;
    final end = widget.hasReachedEnd;

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
      ref.read(characterPageStateProvider.notifier).fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
