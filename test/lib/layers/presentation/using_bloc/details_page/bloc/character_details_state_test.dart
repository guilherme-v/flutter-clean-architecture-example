import 'package:flutter_test/flutter_test.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_bloc/details_page/bloc/character_details_bloc.dart';

void main() {
  group('CharacterDetailsPAgeState', () {
    test('it should be able to create a new instance', () {
      final character = Character(id: 11);
      final state = CharacterDetailsState(character: character);
      expect(state.character, character);
    });

    test('equivalent instances have the same props', () {
      final state1 = CharacterDetailsState(
        character: Character(id: 1, name: 'John J'),
      );

      final state2 = CharacterDetailsState(
        character: Character(id: 1, name: 'John J'),
      );

      expect(state1, state2);
    });

    test('distinct instances have different props', () {
      final state1 = CharacterDetailsState(
        character: Character(id: 1, name: 'John J'),
      );

      final state2 = CharacterDetailsState(
        character: Character(id: 1, name: 'John M'),
      );

      expect(state1, isNot(equals(state2)));
    });
  });
}
