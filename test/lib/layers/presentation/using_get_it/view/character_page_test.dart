import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_get_it/change_notifier/character_change_notifier.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:rickmorty/layers/presentation/using_get_it/view/character_page.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;

    setUp(() async {
      getAllCharactersMock = GetAllCharactersMock();
      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);

      await getIt.reset();
      getIt.registerFactory<GetAllCharacters>(() => getAllCharactersMock);
      getIt.registerLazySingleton<CharacterChangeNotifier>(
        () => CharacterChangeNotifier(
          getAllCharacters: getIt(),
        ),
      );
    });

    testWidgets('renders a CharacterView', (tester) async {
      when(() => getAllCharactersMock(page: any(named: 'page'))).thenAnswer(
        (_) async => characterList1,
      );

      await tester.pumpApp(
        const CharacterPage(),
        getAllCharacters: getAllCharactersMock,
      );

      expect(find.byType(CharacterView), findsOneWidget);
    });

    testWidgets('renders a grid of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');
      final list = [...characterList1, ...characterList2];

      when(() => getAllCharactersMock(page: any(named: 'page'))).thenAnswer(
        (_) async => list,
      );

      await tester.pumpApp(
        const CharacterPage(),
        getAllCharacters: getAllCharactersMock,
      );

      await tester.pumpAndSettle();
      expect(find.byKey(key), findsOneWidget);
      expectLater(find.byType(CharacterCard), findsNWidgets(list.length));
    });
  });
}
