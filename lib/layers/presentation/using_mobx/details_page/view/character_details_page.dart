import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_mobx/details_page/store/character_details_page_store.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({super.key, required this.store});

  final CharacterDetailsPageStore store;

  static Route<void> route({required Character character}) {
    return MaterialPageRoute(
      builder: (context) {
        return CharacterDetailsPage(
          store: CharacterDetailsPageStore(character: character),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => CharacterDetailsView(store: store);
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterDetailsView extends StatelessWidget {
  const CharacterDetailsView({super.key, required this.store});

  final CharacterDetailsPageStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: const Text('Details'),
      ),
      body: _Content(store: store),
    );
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends StatelessWidget {
  const _Content({super.key, required this.store});

  final CharacterDetailsPageStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Observer(
        builder: (BuildContext context) {
          final character = store.character;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: character.id!,
                child: CachedNetworkImage(
                  imageUrl: character.image!,
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        character.name ?? '',
                        style: textTheme.displaySmall!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${character.isAlive ? 'ALIVE!' : 'DEAD!!'}',
                        style: textTheme.titleMedium!.copyWith(
                          color: character.isAlive
                              ? Colors.lightGreen
                              : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Text(
                        'Origin: ${character.origin?.name ?? ''}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last location: ${character.location?.name ?? ''}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Species: ${character.species ?? ''}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type: ${character.type ?? '?'}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gender: ${character.gender ?? ''}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      // const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Episodes:',
                  style: textTheme.bodyLarge!.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: character.episode?.length ?? 0,
                  itemBuilder: (context, index) {
                    final ep = character.episode![index];
                    final name = ep.split('/').last;
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: colorScheme.surfaceVariant,
                        ),
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Text(
                            name,
                            style: textTheme.bodyLarge!.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
