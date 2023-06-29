import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/assets.dart';
import 'package:rickmorty/layers/presentation/styles.dart';
import 'package:rickmorty/layers/presentation/shared/ui_effects/lit_image.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
  });

  final Character character;

  static const receiveLightAmt = 0.4;
  static const emitLightAmt = 0.7;

  @override
  Widget build(BuildContext context) {
    const red = AppColors.normalRed;
    const green = AppColors.emitGreen;
    final alive = character.isAlive;

    return Card(
      color: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              decoration: BoxDecoration(
                color: alive ? green.withOpacity(0.32) : red.withOpacity(0.15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 112,
                    child: CachedNetworkImage(
                      imageUrl: character.image!,
                      fit: BoxFit.cover,
                      errorWidget: (ctx, url, err) => const Icon(Icons.error),
                      placeholder: (ctx, url) => const Icon(Icons.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _Name(character: character),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 7,
            child: _AliveOrDeadTag(alive: alive),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _Border(isAlive: alive, src: Asset.cardBorderTopLeft),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _Border(isAlive: alive, src: Asset.cardBorderTopRight),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _Border(isAlive: alive, src: Asset.cardBorderBottomLeft),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _Border(isAlive: alive, src: Asset.cardBorderBottomRight),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// _Name
// -----------------------------------------------------------------------------
class _Name extends StatelessWidget {
  const _Name({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 4,
          color: character.isAlive ? Colors.green : Colors.redAccent,
        ),
        const SizedBox(height: 2),
        Text(
          character.name ?? "no name",
          style: TextStyles.h3.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// _Border
// -----------------------------------------------------------------------------
class _Border extends StatelessWidget {
  const _Border({
    super.key,
    required this.isAlive,
    required this.src,
  });

  final bool isAlive;
  final String src;

  static const receiveLightAmt = 0.4;
  static const emitLightAmt = 0.7;

  @override
  Widget build(BuildContext context) {
    const red = AppColors.normalRed;
    const green = AppColors.emitGreen;

    return LitImage(
      color: isAlive ? green : red,
      imgSrc: src,
      lightAmt: isAlive ? emitLightAmt : receiveLightAmt,
      fit: BoxFit.contain,
      scale: 3.0,
    );
  }
}

// -----------------------------------------------------------------------------
// _AliveOrDeadTag
// -----------------------------------------------------------------------------
class _AliveOrDeadTag extends StatelessWidget {
  const _AliveOrDeadTag({
    super.key,
    required this.alive,
  });

  final bool alive;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.emitGreen;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        alive ? 'Alive' : 'Dead',
        style: TextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: alive ? green : Colors.redAccent,
        ),
      ),
    );
  }
}
