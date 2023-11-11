import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_cubit/details_page/cubit/character_details_cubit.dart';
import 'package:test/test.dart';

void main() {
  group('CharacterDetailsState', () {
    test('supports value equality', () {
      final character1 = Character(id: 1, name: 'Test Character');
      final character2 = Character(id: 1, name: 'Test Character');

      final state1 = CharacterDetailsState(character1);
      final state2 = CharacterDetailsState(character2);

      // Expect the states to be equal because their characters are equal
      expect(state1, equals(state2));
    });

    test('handles different characters', () {
      final character1 = Character(id: 1, name: 'Test Character');
      final character2 = Character(id: 2, name: 'Another Character');

      final state1 = CharacterDetailsState(character1);
      final state2 = CharacterDetailsState(character2);

      // Expect the states to be different because their characters are different
      expect(state1, isNot(equals(state2)));
    });
  });
}
