import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_header.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_loading.dart';
import 'package:rickmorty/layers/presentation/using_provider/details_page/view/character_details_page.dart';
import 'package:rickmorty/layers/presentation/using_provider/list_page/change_notifier/character_page_change_notifier.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final useCase = context.read<GetAllCharacters>();
    return ChangeNotifierProvider(
      create: (_) => CharacterPageChangeNotifier(getAllCharacters: useCase),
      child: const CharacterView(),
    );
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterPageChangeNotifier>().fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((CharacterPageChangeNotifier c) => c.status);
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
    final list =
        context.select((CharacterPageChangeNotifier b) => b.characters);
    final hasEnded =
        context.select((CharacterPageChangeNotifier b) => b.hasReachedEnd);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        key: const ValueKey('character_page_list_key'),
        controller: _scrollController,
        itemCount: hasEnded ? list.length : list.length + 1,
        itemBuilder: (context, index) {
          if (index >= list.length) {
            return !hasEnded
                ? const CharacterListItemLoading()
                : const SizedBox();
          }
          final item = list[index];
          return index == 0
              ? Column(
                  children: [
                    const CharacterListItemHeader(titleText: 'All Characters'),
                    CharacterListItem(item: item, onTap: _goToDetailsPage),
                  ],
                )
              : CharacterListItem(item: item, onTap: _goToDetailsPage);
        },
      ),
    );
  }

  void _goToDetailsPage(Character character) {
    final route = CharacterDetailsPage.route(character: character);
    Navigator.of(context).push(route);
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
      context.read<CharacterPageChangeNotifier>().fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
