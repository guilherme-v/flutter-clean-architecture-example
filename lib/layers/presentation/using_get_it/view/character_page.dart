import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rickmorty/layers/presentation/shared/character_card.dart';
import 'package:rickmorty/layers/presentation/using_get_it/controller/character_page_controller.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CharacterView();
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends StatefulWidget with GetItStatefulWidgetMixin {
  CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<CharacterPageController>().fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = watchX((CharacterPageController state) => state.status);
    return status == CharacterPageStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : _Content();
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends StatefulWidget with GetItStatefulWidgetMixin {
  _Content({super.key});

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> with GetItStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((CharacterPageController s) => s.characters);
    final end = watchX((CharacterPageController s) => s.hasReachedEnd);

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
      get<CharacterPageController>().fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
