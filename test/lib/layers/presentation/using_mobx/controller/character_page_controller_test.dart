import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_mobx/controller/character_page_controller.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

void main() {
  late CharacterPageController controller;
  late GetAllCharactersMock getAllCharactersMock;

  setUp(() {
    getAllCharactersMock = GetAllCharactersMock();
    controller = CharacterPageController(getAllCharacters: getAllCharactersMock);
  });

  test('fetchNextPage success', () async {
    // Mock the response of GetAllCharacters
    final mockCharacterList = [...characterList1, ...characterList2];
    when(() => getAllCharactersMock.call(page: any(named: 'page')))
        .thenAnswer((_) async => mockCharacterList);

    expect(controller.contentStatus, equals(CharacterPageStatus.initial));

    // Call the method under test
    await controller.fetchNextPage();

    // Verify the interactions and expected values
    expect(controller.contentStatus, equals(CharacterPageStatus.success));
    expect(controller.currentPage, equals(2));
    expect(controller.charactersList, equals(mockCharacterList));
    expect(controller.hasReachedEnd, isFalse);
  });

  test('fetchNextPage has reached end', () async {
    // Mock an empty response from GetAllCharacters
    when(() => getAllCharactersMock(page: any(named: 'page')))
        .thenAnswer((_) async => []);

    // Set hasReachedEnd to true to simulate the end of the list
    // controller.hasReachedEnd = true;

    expect(controller.contentStatus, equals(CharacterPageStatus.initial));

    // Call the method under test
    await controller.fetchNextPage();

    // Verify the interactions and expected values
    expect(controller.contentStatus, equals(CharacterPageStatus.success));
    expect(controller.currentPage, equals(2));
    expect(controller.charactersList, isEmpty);
    expect(controller.hasReachedEnd, isTrue);
  });
}
