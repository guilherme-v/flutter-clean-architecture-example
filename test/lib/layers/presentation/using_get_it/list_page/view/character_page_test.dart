import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/controller/character_page_controller.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/view/character_page.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;

    setUp(() async {
      getAllCharactersMock = GetAllCharactersMock();
      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);

      await getIt.reset();
      getIt.registerFactory<GetAllCharacters>(() => getAllCharactersMock);
      getIt.registerLazySingleton<CharacterPageController>(
        () => CharacterPageController(getAllCharacters: getIt()),
      );
    });

    testWidgets('renders a CharacterView', (tester) async {
      await tester.pumpApp(
        const CharacterPage(),
        getAllCharacters: getAllCharactersMock,
      );

      expect(find.byType(CharacterView), findsOneWidget);
    });

    testWidgets('renders a list of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');

      await tester.pumpApp(
        const CharacterPage(),
        getAllCharacters: getAllCharactersMock,
      );
      getIt<CharacterPageController>().hasReachedEnd.value = true;

      await tester.pumpAndSettle();
      expect(find.byKey(key), findsOneWidget);
      expectLater(
        find.byType(CharacterListItem),
        findsNWidgets([...characterList1, ...characterList2].length),
      );
    });
  });
}
