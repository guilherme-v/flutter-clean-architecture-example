import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixtures.dart';

class MockApi extends Mock implements Api {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late CharacterRepositoryImpl characterRepository;
  late MockApi mockApi;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockApi = MockApi();
    mockLocalStorage = MockLocalStorage();
    characterRepository = CharacterRepositoryImpl(
      api: mockApi,
      localStorage: mockLocalStorage,
    );
  });

  group('CharacterRepositoryImpl', () {
    test('getCharacters should return cached characters if available',
        () async {
      const page = 0;
      final cachedCharacters = characterList1;
      when(() => mockLocalStorage.loadCharactersPage(page: page))
          .thenReturn(cachedCharacters);

      final result = await characterRepository.getCharacters(page: page);

      expect(result, equals(cachedCharacters));

      verify(() => mockLocalStorage.loadCharactersPage(page: page)).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
      verifyZeroInteractions(mockApi);
    });

    test(
        'getCharacters should fetch characters from API and save to local storage',
        () async {
      const page = 1;
      final apiCharacters = characterList2;
      when(() => mockLocalStorage.loadCharactersPage(page: page))
          .thenReturn([]);
      when(() => mockApi.loadCharacters(page: page))
          .thenAnswer((_) async => apiCharacters);
      when(
        () => mockLocalStorage.saveCharactersPage(
          page: page,
          list: apiCharacters,
        ),
      ).thenAnswer((_) async => true);

      final result = await characterRepository.getCharacters(page: page);

      expect(result, equals(apiCharacters));
      verify(() => mockLocalStorage.loadCharactersPage(page: page)).called(1);
      verify(() => mockApi.loadCharacters(page: page)).called(1);
      verify(
        () => mockLocalStorage.saveCharactersPage(
          page: page,
          list: apiCharacters,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
      verifyNoMoreInteractions(mockApi);
    });
  });
}
