import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';

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
