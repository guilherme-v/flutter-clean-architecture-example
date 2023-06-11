import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/bloc/character_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('CharacterState', () {
    test('copyWith creates a new instance with the provided values', () {
      final state = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final newState = state.copyWith(
        status: CharacterStatus.success,
        characters: [Character(id: 2, name: 'Jane')],
        hasReachedEnd: false,
        currentPage: 3,
      );

      expect(newState.status, equals(CharacterStatus.success));
      expect(newState.characters.length, equals(1));
      expect(newState.characters[0].id, equals(2));
      expect(newState.characters[0].name, equals('Jane'));
      expect(newState.hasReachedEnd, equals(false));
      expect(newState.currentPage, equals(3));
    });

    test('copyWith maintains unchanged values', () {
      final state = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final newState = state.copyWith(status: CharacterStatus.success);

      expect(newState.status, equals(CharacterStatus.success));
      expect(newState.characters, equals(state.characters));
      expect(newState.hasReachedEnd, equals(state.hasReachedEnd));
      expect(newState.currentPage, equals(state.currentPage));
    });

    test('props returns a list of the object properties', () {
      final state = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final props = state.props;

      expect(props.length, equals(4));
      expect(props[0], equals(CharacterStatus.loading));
      expect(props[1], equals(state.characters));
      expect(props[2], equals(true));
      expect(props[3], equals(2));
    });

    test('equivalent instances have the same props', () {
      final state1 = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final state2 = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      expect(state1.props, equals(state2.props));
    });

    test('distinct instances have different props', () {
      final state1 = CharacterState(
        status: CharacterStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final state2 = CharacterState(
        status: CharacterStatus.success,
        characters: [Character(id: 2, name: 'Jane')],
        hasReachedEnd: false,
        currentPage: 3,
      );

      expect(state1.props, isNot(equals(state2.props)));
    });
  });
}
