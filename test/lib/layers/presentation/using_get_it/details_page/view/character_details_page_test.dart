import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickmorty/layers/presentation/using_get_it/details_page/controller/character_details_controller.dart';
import 'package:rickmorty/layers/presentation/using_get_it/details_page/view/character_details_page.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';

import '../../../../../../fixtures/fixtures.dart';

void main() {
  final character = characterList1.first;

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton(
      () => CharacterDetailsController()..character = character,
    );
  });

  testWidgets(
    'CharacterDetailsPage should renders correctly',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CharacterDetailsPage(),
        ),
      );

      // Find items on the page
      expect(find.text('Details'), findsOneWidget);
      expect(find.text(character.name!), findsOneWidget);
      expect(find.text('Origin: ${character.origin!.name}'), findsOneWidget);
      expect(find.text('Species: ${character.species}'), findsOneWidget);
      expect(find.text('Type: ${character.type}'), findsOneWidget);
      expect(find.text('Gender: ${character.gender}'), findsOneWidget);
      expect(
        find.text('Status: ${character.isAlive ? 'ALIVE!' : 'DEAD!'}'),
        findsOneWidget,
      );
      expect(
        find.text('Last location: ${character.location!.name}'),
        findsOneWidget,
      );
      expectLater(
        find.byType(EpisodeItem),
        findsNWidgets(character.episode!.length),
      );
    },
  );
}
