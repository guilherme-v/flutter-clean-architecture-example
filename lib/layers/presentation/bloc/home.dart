import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/bloc/home_bloc.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterPage extends StatelessWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        getAllCharacters: context.read<GetAllCharacters>(),
      )..add(const LoadNextPageEvent()),
      child: const CharacterView(),
    );
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterView extends StatelessWidget {
  const CharacterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((HomeBloc b) => b.state.status);
    return status == HomeStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : const _Content();
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends StatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
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
    final hasReachedEnd = state.hasReachedEnd;

    final length = hasReachedEnd
        ? list.length
        : list.length % 2 == 0
            ? list.length + 1
            : list.length + 2;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust the number of columns here
              childAspectRatio: 1 / 1.36,
            ),
            controller: _scrollController,
            itemCount: length,
            itemBuilder: (context, index) {
              if (index < list.length) {
                final char = list[index];
                return _CharacterCard(char: char);
              }
              return hasReachedEnd
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
      context.read<HomeBloc>().add(const LoadNextPageEvent());
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
class _CharacterCard extends StatelessWidget {
  const _CharacterCard({super.key, required this.char});

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
                  child: Image.network(
                    char.image!,
                    fit: BoxFit.cover,
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
                      style: textThemeDisplay.titleSmall,
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
