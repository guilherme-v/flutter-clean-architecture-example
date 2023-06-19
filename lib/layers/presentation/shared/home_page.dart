import 'package:flutter/material.dart';

import '../using_bloc/character_page/view/character_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: textTheme.headlineSmall,
          ),
        ),
      ),
      body: const CharacterPage(),
    );
  }
}
