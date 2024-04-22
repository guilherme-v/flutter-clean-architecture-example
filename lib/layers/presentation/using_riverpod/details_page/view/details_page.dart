import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/details_page/notifier/details_page_notifier.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class DetailsPage extends ConsumerWidget {
  const DetailsPage({super.key, required this.character});

  final Character character;

  static Route<void> route({required Character character}) {
    return MaterialPageRoute(
      builder: (context) {
        return DetailsPage(character: character);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(detailsPageProvider).character = character;
    return const CharacterDetailsView();
  }
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class CharacterDetailsView extends StatelessWidget {
  const CharacterDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: const Text('Details'),
      ),
      body: const _Content(),
    );
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
class _Content extends ConsumerWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final character = ref.read(detailsPageProvider).character!;

    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }
}
