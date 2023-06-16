import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_get_it/change_notifier/character_change_notifier.dart';

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
      get<CharacterChangeNotifier>().fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = watchX((CharacterChangeNotifier state) => state.status);
    return status == CharacterStatus.initial
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
    List<Character> list = watchX(
      (CharacterChangeNotifier state) => state.characters,
    );
    bool end = watchX(
      (CharacterChangeNotifier state) => state.hasReachedEnd,
    );

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
      get<CharacterChangeNotifier>().fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

// -----------------------------------------------------------------------------
// Card
// -----------------------------------------------------------------------------
class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.char});

  final Character char;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // The displayColor is applied to displayLarge, displayMedium, displaySmall,
    // headlineLarge, headlineMedium, and bodySmall. The bodyColor is applied to
    // the remaining text styles.
    final textThemeDisplay = textTheme.apply(
      displayColor: Theme.of(context).colorScheme.onSurface,
    );

    final textThemeBody = textTheme.apply(
      bodyColor: Theme.of(context).colorScheme.surfaceTint,
    );

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: SizedBox(
                  height: 142,
                  child: CachedNetworkImage(
                    imageUrl: char.image!,
                    fit: BoxFit.cover,
                    errorWidget: (ctx, url, err) => const Icon(Icons.error),
                    placeholder: (ctx, url) => const Icon(Icons.image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      char.name ?? "no name",
                      style: textThemeDisplay.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      char.location?.name ?? "unknown",
                      style: textThemeDisplay.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Text(
              'read more',
              style: textThemeBody.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
