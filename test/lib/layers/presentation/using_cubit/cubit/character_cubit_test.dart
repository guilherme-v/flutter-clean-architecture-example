import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_cubit/character/cubit/character_cubit.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

void main() {
  group('CharacterCubit', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterCubit cubit;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      cubit = CharacterCubit(getAllCharacters: getAllCharactersMock);
    });

    test('should have correct initial state', () {
      const expected = CharacterState(
        characters: [],
        currentPage: 1,
        status: CharacterStatus.initial,
        hasReachedEnd: false,
      );

      expect(
        CharacterCubit(getAllCharacters: getAllCharactersMock).state,
        expected,
      );
    });

    group('.FetchNextPageEvent', () {
      blocTest<CharacterCubit, CharacterState>(
        'emits loading->success when FetchNextPageEvent is added and succeeds',
        build: () => cubit,
        setUp: () {
          when(() => getAllCharactersMock(page: 1)).thenAnswer(
            (_) async => characterList1,
          );
        },
        act: (cubit) => cubit.fetchNextPage(),
        expect: () => [
          const CharacterState(
            status: CharacterStatus.loading,
          ),
          CharacterState(
            status: CharacterStatus.success,
            characters: characterList1,
            hasReachedEnd: false,
            currentPage: 2,
          ),
        ],
      );

      blocTest<CharacterCubit, CharacterState>(
        'emits a state with hasReachedEnd true when no items are available anymore',
        build: () => cubit,
        setUp: () {
          when(() => getAllCharactersMock(page: 1)).thenAnswer((_) async => []);
        },
        act: (cubit) => cubit.fetchNextPage(),
        expect: () => [
          const CharacterState(
            status: CharacterStatus.loading,
          ),
          const CharacterState(
            status: CharacterStatus.success,
            characters: [],
            hasReachedEnd: true,
            currentPage: 2,
          ),
        ],
      );
    });
  });
}
