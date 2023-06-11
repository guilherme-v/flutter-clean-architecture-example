import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_cubit/cubit/character_cubit.dart';
import 'package:rickmorty/layers/presentation/using_cubit/view/character_page.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

class CharacterCubitMock extends MockCubit<CharacterState>
    implements CharacterCubit {}

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;
    late CharacterCubit cubit;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      cubit = CharacterCubitMock();

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
      // await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(CharacterView), findsOneWidget);
    });

    testWidgets('renders a grid of Characters widgets', (tester) async {
      const key = Key('character_page_list_key');
      when(() => cubit.state).thenReturn(
        CharacterState(
          currentPage: 2,
          status: CharacterStatus.success,
          hasReachedEnd: false,
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
      expectLater(find.byType(CharacterCard), findsNWidgets(list.length));
    });
  });
}
