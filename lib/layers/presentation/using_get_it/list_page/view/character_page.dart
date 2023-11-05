import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_header.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_loading.dart';
import 'package:rickmorty/layers/presentation/using_get_it/details_page/view/character_details_page.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/controller/character_page_controller.dart';

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
    final hasEnded = watchX((CharacterPageController s) => s.hasReachedEnd);

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
                    CharacterListItem(item: item, onTap: _goToDetails),
                  ],
                )
              : CharacterListItem(item: item, onTap: _goToDetails);
        },
      ),
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
