import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/providers.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/list_page/view/character_page.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);
    });

    testWidgets('renders a CharacterView', (tester) async {
      when(() => getAllCharactersMock(page: any(named: 'page'))).thenAnswer(
        (_) async => characterList1,
      );

      await tester.pumpApp(
        ProviderScope(
          overrides: [
            getAllCharactersProvider
                .overrideWith((ref) => getAllCharactersMock),
          ],
          child: const CharacterPage(),
        ),
      );

      expect(find.byType(CharacterView), findsOneWidget);
    });
  });
}
