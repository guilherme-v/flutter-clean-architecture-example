import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/shared/character_list_item.dart';
import 'package:rickmorty/layers/presentation/using_cubit/list_page/cubit/character_page_cubit.dart';
import 'package:rickmorty/layers/presentation/using_cubit/list_page/view/character_page.dart';

import '../../../../../../fixtures/fixtures.dart';
import '../../../helper/pump_app.dart';

class CharacterPageCubitMock extends MockCubit<CharacterPageState>
    implements CharacterPageCubit {}

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterPageCubit cubit;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      cubit = CharacterPageCubitMock();

      when(() => getAllCharactersMock.call(page: any(named: 'page')))
          .thenAnswer((_) async => [...characterList1, ...characterList2]);
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

    testWidgets('renders a list of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');
      when(() => cubit.state).thenReturn(
        CharacterPageState(
          currentPage: 2,
          status: CharacterPageStatus.success,
          hasReachedEnd: true,
          characters: [...characterList1, ...characterList2],
        ),
      );
      when(() => cubit.fetchNextPage()).thenAnswer((_) async => true);

      await tester.pumpApp(
        BlocProvider.value(
          value: cubit,
          child: const CharacterView(),
        ),
        getAllCharacters: getAllCharactersMock,
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(key), findsOneWidget);
      final list = [...characterList1, ...characterList2];
      expectLater(find.byType(CharacterListItem), findsNWidgets(list.length));
    });
  });
}
