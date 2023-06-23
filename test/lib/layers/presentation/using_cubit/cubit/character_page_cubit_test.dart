import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_cubit/cubit/character_page_cubit.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

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

    group('.FetchNextPageEvent', () {
      blocTest<CharacterPageCubit, CharacterPageState>(
        'emits loading->success when FetchNextPageEvent is added and succeeds',
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
      );

      blocTest<CharacterPageCubit, CharacterPageState>(
        'emits a state with hasReachedEnd true when no items are available anymore',
        build: () => cubit,
        setUp: () {
          when(() => getAllCharactersMock(page: 1)).thenAnswer((_) async => []);
        },
        act: (cubit) => cubit.fetchNextPage(),
        expect: () => [
          const CharacterPageState(
            status: CharacterPageStatus.loading,
          ),
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
