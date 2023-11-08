import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_header.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_loading.dart';
import 'package:rickmorty/layers/presentation/using_mobx/list_page/store/character_page_store.dart';

import 'package:rickmorty/layers/presentation/using_mobx/details_page/view/character_details_page.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    // We're creating an Store here and passing it manually as dependency to
    // constructors.
    //
    // A different option would be to use Provider to provide it down to the
    // widget tree. This approach is also suggested by the MobX's documentation
    //
    return CharacterView(
      store: CharacterPageStore(
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

  final CharacterPageStore store;

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

  final CharacterPageStore store;

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
        final hasEnded = widget.store.hasReachedEnd;

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
                        const CharacterListItemHeader(
                          titleText: 'All Characters',
                        ),
                        CharacterListItem(item: item, onTap: _goToDetails),
                      ],
                    )
                  : CharacterListItem(item: item, onTap: _goToDetails);
            },
          ),
        );
      },
    );
  }

  void _goToDetails(Character character) {
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
