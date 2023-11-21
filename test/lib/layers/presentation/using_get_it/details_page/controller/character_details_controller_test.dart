import 'package:flutter_test/flutter_test.dart';
import 'package:rickmorty/layers/presentation/using_get_it/details_page/controller/character_details_controller.dart';

import '../../../../../../fixtures/fixtures.dart';

void main() {
  late CharacterDetailsController controller;

  test('It should be able to create a new instance', () {
    final c = characterList1.first;
    controller = CharacterDetailsController()..character = c;
    expect(controller.character, c);
  });
}
