import 'package:flutter_test/flutter_test.dart';
import 'package:rickmorty/layers/presentation/using_provider/details_page/change_notifier/character_details_change_notifier.dart';

import '../../../../../../fixtures/fixtures.dart';

void main() {
  group('CharacterDetailsChangeNotifier', () {
    test('initial state is correct', () {
      final c = characterList1.first;

      final notifier = CharacterDetailsChangeNotifier(character: c);

      expect(notifier.character, c);
    });
  });
}
