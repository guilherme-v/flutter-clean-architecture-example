import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/bloc/home_bloc.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        getAllCharacters: context.read<GetAllCharacters>(),
      )..add(const LoadNextPageEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((HomeBloc b) => b.state.status);
    return status == HomeStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : const HomeViewContent();
  }
}

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({Key? key}) : super(key: key);

  @override
  State<HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
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

    final textTheme = Theme.of(context).textTheme;

    // The displayColor is applied to displayLarge, displayMedium, displaySmall,
    // headlineLarge, headlineMedium, and bodySmall. The bodyColor is applied to
    // the remaining text styles.
    final textThemeDisplay =
        textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);

    final textThemeBody =
        textTheme.apply(bodyColor: Theme.of(context).colorScheme.surfaceTint);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust the number of columns here
          childAspectRatio: 1 / 1.42,
        ),
        controller: _scrollController,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          final char = list[index];
          return index < list.length
              ? Card(
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
                                  style: textTheme.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  char.location?.name ?? "no location",
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
                          style: textThemeBody.labelSmall,
                        ),
                      )
                    ],
                  ),
                )
              : state.hasReachedEnd
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: CircularProgressIndicator()),
                    );
        },
      ),
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
    if (_isBottom) context.read<HomeBloc>().add(const LoadNextPageEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
