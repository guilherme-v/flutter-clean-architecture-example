import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_bloc/details_page/bloc/character_details_bloc.dart';

// WIP !!

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({required this.character, super.key});

  final Character character;

  static Route<void> route({required Character character}) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (_) => CharacterDetailsBloc(character: character),
          child: CharacterDetailsPage(character: character),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CharacterDetailsView();
  }
}

// -----------------------------------------------------------------------------
// CharacterDetailsView
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
class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final character = context.select(
      (CharacterDetailsBloc b) => b.state.character,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CachedNetworkImage(
          imageUrl: character.image!,
          fit: BoxFit.cover,
          height: 360,
        ),
        Text(
          character.name ?? '',
          style: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
