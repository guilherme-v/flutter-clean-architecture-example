import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/using_bloc/list_page/bloc/character_page_bloc.dart';
import 'package:rickmorty/layers/presentation/using_bloc/list_page/view/character_page.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

class CharacterBlocMock extends MockBloc<CharacterPageEvent, CharacterPageState>
    implements CharacterPageBloc {}

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterPageBloc blocMock;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      blocMock = CharacterBlocMock();

      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);
    });

    testWidgets('renders CharacterView', (tester) async {
      try {
        await tester.pumpApp(
          const CharacterPage(),
          getAllCharacters: getAllCharactersMock,
        );
        await tester.pumpAndSettle();
      } catch (e) {
        // https://stackoverflow.com/questions/64231515/widget-test-testing-a-button-with-circularprogressindicator
      }

      expectLater(find.byType(CharacterView), findsOneWidget);
    });

    testWidgets('renders a grid of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');
      when(() => blocMock.state).thenReturn(
        CharacterPageState(
          currentPage: 2,
          status: CharacterPageStatus.success,
          hasReachedEnd: false,
          characters: [...characterList1, ...characterList2],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: blocMock,
          child: const CharacterView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
      final list = [...characterList1, ...characterList2];
      expectLater(find.byType(CharacterListItem), findsNWidgets(list.length));
    });
  });
}
