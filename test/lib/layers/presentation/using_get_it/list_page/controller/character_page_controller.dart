import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/controller/character_page_controller.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  late CharacterPageController controller;

  setUp(() {
    final mock = GetAllCharactersMock();
    when(() => mock.call(page: any(named: 'page')))
        .thenAnswer((_) async => [...characterList1, ...characterList2]);

    controller = CharacterPageController(getAllCharacters: mock);
  });

  group('.fetchNextPage()', () {
    test('updates status to loading and notifies listeners', () async {
      var loadingHappened = false;

      // the 'loading' state happens between the method call and the final
      // state. That's the reason we use a listener to be sure it happened
      controller.status.addListener(() {
        if (controller.status.value == CharacterPageStatus.loading) {
          loadingHappened = true;
        }
      });

      expect(controller.status.value, CharacterPageStatus.initial);
      await controller.fetchNextPage();
      expect(loadingHappened, true);
    });

    test('fetches characters and updates state', () async {
      controller.currentPage.value = 1;

      await controller.fetchNextPage();

      expect(controller.currentPage.value, 2);
      expect(controller.status.value, CharacterPageStatus.success);
      expect(controller.characters.value, isNotEmpty);
      expect(controller.hasReachedEnd.value, isFalse);
    });

    test('fetchNextPage does not fetch if hasReachedEnd is true', () async {
      controller.hasReachedEnd.value = true;

      await controller.fetchNextPage();

      expect(controller.currentPage.value, 1);
      expect(controller.status.value, CharacterPageStatus.initial);
      expect(controller.characters.value, isEmpty);
    });
  });
}
