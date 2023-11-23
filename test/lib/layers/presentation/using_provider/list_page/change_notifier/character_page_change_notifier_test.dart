import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_provider/list_page/change_notifier/character_page_change_notifier.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  group('CharacterChangeNotifier', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterPageChangeNotifier characterChangeNotifier;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
    });

    test('fetchNextPage updates state correctly', () async {
      characterChangeNotifier = CharacterPageChangeNotifier(
        getAllCharacters: getAllCharactersMock,
      );

      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);

      // Set up the initial state
      expect(
        characterChangeNotifier.status,
        equals(CharacterPageStatus.initial),
      );

      // Set up the response from getAllCharacters
      final page = characterChangeNotifier.currentPage;

      await characterChangeNotifier.fetchNextPage();

      // Verify that the state is updated correctly
      expect(
        characterChangeNotifier.status,
        equals(CharacterPageStatus.success),
      );
      expect(characterChangeNotifier.currentPage, equals(page + 1));
      expect(
        characterChangeNotifier.characters,
        equals([
          ...[...characterList1, ...characterList2],
        ]),
      );
      expect(characterChangeNotifier.hasReachedEnd, equals(false));
    });

    test('fetchNextPage does not update state when hasReachedEnd is true',
        () async {
      // Set up the initial state with hasReachedEnd = true
      characterChangeNotifier = CharacterPageChangeNotifier(
        getAllCharacters: getAllCharactersMock,
      );

      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => []);

      // Call the fetchNextPage method
      await characterChangeNotifier.fetchNextPage();

      // Verify that the state remains unchanged
      expect(
        characterChangeNotifier.status,
        equals(CharacterPageStatus.success),
      );
      expect(characterChangeNotifier.currentPage, equals(2));
      expect(characterChangeNotifier.characters, isEmpty);
      expect(characterChangeNotifier.hasReachedEnd, equals(true));
    });
  });
}
