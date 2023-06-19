import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/bloc/character_page_bloc.dart';

import '../../../../../../fixtures/fixtures.dart';

class MockGetAllCharacters extends Mock implements GetAllCharacters {}

void main() {
  late CharacterBloc characterBloc;
  late GetAllCharacters getAllCharacters;

  setUp(() {
    getAllCharacters = MockGetAllCharacters();
    characterBloc = CharacterBloc(getAllCharacters: getAllCharacters);
  });

  group('CharacterBloc', () {
    test('initial state is correct', () {
      final initial = CharacterBloc(getAllCharacters: getAllCharacters).state;
      expect(initial, const CharacterState());
    });

    group('.FetchNextPageEvent', () {
      blocTest<CharacterBloc, CharacterState>(
        'emits loading->success when FetchNextPageEvent is added and succeeds',
        build: () => characterBloc,
        setUp: () {
          when(() => getAllCharacters(page: 1)).thenAnswer(
            (_) async => characterList1,
          );
        },
        act: (bloc) => bloc..add(const FetchNextPageEvent()),
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

      blocTest<CharacterBloc, CharacterState>(
        'emits a state with hasReachedEnd true when no items are available anymore',
        build: () => characterBloc,
        setUp: () {
          when(() => getAllCharacters(page: 1)).thenAnswer(
            (_) async => const [],
          );
        },
        act: (bloc) => bloc..add(const FetchNextPageEvent()),
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
