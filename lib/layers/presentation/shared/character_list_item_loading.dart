import 'package:flutter/material.dart';

class CharacterListItemLoading extends StatelessWidget {
  const CharacterListItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
