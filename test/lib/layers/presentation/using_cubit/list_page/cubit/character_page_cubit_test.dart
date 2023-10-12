import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_cubit/list_page/cubit/character_page_cubit.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  group('CharacterPageCubit', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterPageCubit cubit;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      cubit = CharacterPageCubit(getAllCharacters: getAllCharactersMock);
    });

    test('should have correct initial state', () {
      const expected = CharacterPageState(
        characters: [],
        currentPage: 1,
        status: CharacterPageStatus.initial,
        hasReachedEnd: false,
      );

      expect(
        CharacterPageCubit(getAllCharacters: getAllCharactersMock).state,
        expected,
      );
    });

    group('.fetchNextPage()', () {
      blocTest<CharacterPageCubit, CharacterPageState>(
        'emits loading -> runs UseCase -> emits success with a list',
        build: () => cubit,
        setUp: () {
          when(() => getAllCharactersMock(page: 1)).thenAnswer(
            (_) async => characterList1,
          );
        },
        act: (cubit) => cubit.fetchNextPage(),
        expect: () => [
          const CharacterPageState(
            status: CharacterPageStatus.loading,
          ),
          CharacterPageState(
            status: CharacterPageStatus.success,
            characters: characterList1,
            hasReachedEnd: false,
            currentPage: 2,
          ),
        ],
        verify: (_) {
          verify(() => getAllCharactersMock.call(page: 1));
          verifyNoMoreInteractions(getAllCharactersMock);
        },
      );

      blocTest<CharacterPageCubit, CharacterPageState>(
        "emits a state with hasReachedEnd 'true' when there are no more items",
        build: () => cubit,
        setUp: () {
          when(() => getAllCharactersMock(page: 1)).thenAnswer((_) async => []);
        },
        act: (cubit) => cubit.fetchNextPage(),
        skip: 1, // skip 'loading'
        expect: () => [
          const CharacterPageState(
            status: CharacterPageStatus.success,
            characters: [],
            hasReachedEnd: true,
            currentPage: 2,
          ),
        ],
      );
    });
  });
}
