import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_cubit/list_page/cubit/character_page_cubit.dart';
import 'package:test/test.dart';

void main() {
  group('CharacterPageState', () {
    test('copyWith creates a new instance with the provided values', () {
      final state = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final newState = state.copyWith(
        status: CharacterPageStatus.success,
        characters: [Character(id: 2, name: 'Jane')],
        hasReachedEnd: false,
        currentPage: 3,
      );

      expect(newState.status, equals(CharacterPageStatus.success));
      expect(newState.characters.length, equals(1));
      expect(newState.characters[0].id, equals(2));
      expect(newState.characters[0].name, equals('Jane'));
      expect(newState.hasReachedEnd, equals(false));
      expect(newState.currentPage, equals(3));
    });

    test('copyWith maintains unchanged values', () {
      final state = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final newState = state.copyWith(status: CharacterPageStatus.success);

      expect(newState.status, equals(CharacterPageStatus.success));
      expect(newState.characters, equals(state.characters));
      expect(newState.hasReachedEnd, equals(state.hasReachedEnd));
      expect(newState.currentPage, equals(state.currentPage));
    });

    test('props returns a list of the object properties', () {
      final state = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final props = state.props;

      expect(props.length, equals(4));
      expect(props[0], equals(CharacterPageStatus.loading));
      expect(props[1], equals(state.characters));
      expect(props[2], equals(true));
      expect(props[3], equals(2));
    });

    test('equivalent instances have the same props', () {
      final state1 = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final state2 = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      expect(state1.props, equals(state2.props));
    });

    test('distinct instances have different props', () {
      final state1 = CharacterPageState(
        status: CharacterPageStatus.loading,
        characters: [Character(id: 1, name: 'John')],
        hasReachedEnd: true,
        currentPage: 2,
      );

      final state2 = CharacterPageState(
        status: CharacterPageStatus.success,
        characters: [Character(id: 2, name: 'Jane')],
        hasReachedEnd: false,
        currentPage: 3,
      );

      expect(state1.props, isNot(equals(state2.props)));
    });
  });
}
