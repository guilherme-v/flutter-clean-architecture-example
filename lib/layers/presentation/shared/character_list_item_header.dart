import 'package:flutter/material.dart';

class CharacterListItemHeader extends StatelessWidget {
  const CharacterListItemHeader({
    super.key,
    required this.titleText,
  });

  final String titleText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Card(
          elevation: 0,
          color: cs.tertiaryContainer,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.person,
                    color: cs.onTertiaryContainer,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    titleText,
                    style: tt.titleMedium!.copyWith(
                      color: cs.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            height: 1,
            color: cs.tertiaryContainer,
          ),
        ),
      ],
    );
  }
}
