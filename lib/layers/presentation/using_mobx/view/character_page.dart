import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_mobx/controller/character_page_controller.dart';

import '../../shared/character_card.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CharacterView(
      store: CharacterPageController(
        getAllCharacters: context.read<GetAllCharacters>(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends StatefulWidget {
  const CharacterView({super.key, required this.store});

  final CharacterPageController store;

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.store.fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => widget.store.contentStatus == CharacterPageStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : _Content(store: widget.store),
    );
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends StatefulWidget {
  const _Content({super.key, required this.store});

  final CharacterPageController store;

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
    return Observer(
      builder: (context) {
        final list = widget.store.charactersList.toList();
        final end = widget.store.hasReachedEnd;

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
                    return CharacterCard(char: char);
                  }
                  return end
                      ? const SizedBox()
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
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
    if (_isBottom) {
      widget.store.fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
