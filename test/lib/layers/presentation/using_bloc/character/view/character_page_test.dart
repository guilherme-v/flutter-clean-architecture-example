import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/bloc/character_bloc.dart';
import 'package:rickmorty/layers/presentation/using_bloc/character/view/character_page.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

class CharacterBlocMock extends MockBloc<CharacterEvent, CharacterState>
    implements CharacterBloc {}

void main() {
  group('CharacterPage', () {
    late GetAllCharacters getAllCharactersMock;
    late CharacterBloc blocMock;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      blocMock = CharacterBlocMock();

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

    testWidgets('renders a grid of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');
      when(() => blocMock.state).thenReturn(
        CharacterState(
          currentPage: 2,
          status: CharacterStatus.success,
          hasReachedEnd: false,
          characters: [...characterList1, ...characterList2],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: blocMock,
          child: const CharacterView(),
        ),
        getAllCharacters: getAllCharactersMock,
      );

      expect(find.byKey(key), findsOneWidget);
      final list = [...characterList1, ...characterList2];
      expectLater(find.byType(CharacterCard), findsNWidgets(list.length));
    });
  });
}
