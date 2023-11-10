import 'package:flutter_test/flutter_test.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/presentation/using_bloc/details_page/bloc/character_details_bloc.dart';

import '../../../../../../fixtures/fixtures.dart';

void main() {
  group('CharacterDetailsBloc', () {
    test('initial state is correct', () {
      Character c = characterList1.first;

      final expected = CharacterDetailsState(character: c);
      final initial = CharacterDetailsBloc(character: c).state;

      expect(initial, expected);
    });
  });
}
