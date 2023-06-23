import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/shared/character_card.dart';
import 'package:rickmorty/layers/presentation/using_bloc/bloc/character_page_bloc.dart';
import 'package:rickmorty/layers/presentation/using_bloc/view/character_page.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

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
      await tester.pumpApp(
        const CharacterPage(),
        getAllCharacters: getAllCharactersMock,
      );
      // WidgetsBinding.instance.addPostFrameCallback((_) { ...
      // https://github.com/flutter/flutter/issues/11181
      await tester.pumpAndSettle(const Duration(seconds: 1));

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
      expectLater(find.byType(CharacterCard), findsNWidgets(list.length));
    });
  });
}
