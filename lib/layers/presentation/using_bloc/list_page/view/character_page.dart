import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_header.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item_loading.dart';
import 'package:rickmorty/layers/presentation/using_bloc/details_page/view/character_details_page.dart';
import 'package:rickmorty/layers/presentation/using_bloc/list_page/bloc/character_page_bloc.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterPageBloc(
        getAllCharacters: context.read<GetAllCharacters>(),
      )..add(const FetchNextPageEvent()),
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
    final status = context.select((CharacterPageBloc b) => b.state.status);
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

  CharacterPageBloc get pageBloc => context.read<CharacterPageBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext ctx) {
    final list = ctx.select((CharacterPageBloc b) => b.state.characters);
    final hasEnded = ctx.select((CharacterPageBloc b) => b.state.hasReachedEnd);

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
      pageBloc.add(const FetchNextPageEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
