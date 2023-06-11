import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/view/character_page.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

void main() {
  group('CharacterPage', () {
    late GetAllCharacters getAllCharactersMock;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);
    });

    testWidgets(
      'renders a CharacterView',
      (tester) async {
        await tester.pumpApp(
          const CharacterPage(),
          getAllCharacters: getAllCharactersMock,
        );
        expect(find.byType(CharacterView), findsOneWidget);
      },
    );
  });
}
