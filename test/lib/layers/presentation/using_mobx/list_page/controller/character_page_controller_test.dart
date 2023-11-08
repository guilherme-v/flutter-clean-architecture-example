import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_mobx/list_page/store/character_page_store.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  late CharacterPageStore store;
  late GetAllCharactersMock getAllCharactersMock;

  setUp(() {
    getAllCharactersMock = GetAllCharactersMock();
    store = CharacterPageStore(getAllCharacters: getAllCharactersMock);
  });

  test('fetchNextPage success', () async {
    // Mock the response of GetAllCharacters
    final mockCharacterList = [...characterList1, ...characterList2];
    when(() => getAllCharactersMock.call(page: any(named: 'page')))
        .thenAnswer((_) async => mockCharacterList);

    expect(store.contentStatus, equals(CharacterPageStatus.initial));

    // Call the method under test
    await store.fetchNextPage();

    // Verify the interactions and expected values
    expect(store.contentStatus, equals(CharacterPageStatus.success));
    expect(store.currentPage, equals(2));
    expect(store.charactersList, equals(mockCharacterList));
    expect(store.hasReachedEnd, isFalse);
  });

  test('fetchNextPage has reached end', () async {
    // Mock an empty response from GetAllCharacters
    when(() => getAllCharactersMock(page: any(named: 'page')))
        .thenAnswer((_) async => []);

    // Set hasReachedEnd to true to simulate the end of the list
    // controller.hasReachedEnd = true;

    expect(store.contentStatus, equals(CharacterPageStatus.initial));

    // Call the method under test
    await store.fetchNextPage();

    // Verify the interactions and expected values
    expect(store.contentStatus, equals(CharacterPageStatus.success));
    expect(store.currentPage, equals(2));
    expect(store.charactersList, isEmpty);
    expect(store.hasReachedEnd, isTrue);
  });
}
