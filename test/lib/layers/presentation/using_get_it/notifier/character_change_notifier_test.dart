import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickmorty/layers/presentation/using_get_it/change_notifier/character_change_notifier.dart';

import '../../../../../fixtures/fixtures.dart';
import '../../helper/pump_app.dart';

void main() {
  late CharacterChangeNotifier characterChangeNotifier;

  setUp(() {
    final mock =  GetAllCharactersMock();
    when(() => mock.call(page: any(named: 'page')))
        .thenAnswer((_) async => [...characterList1, ...characterList2]);

    characterChangeNotifier = CharacterChangeNotifier(
      getAllCharacters: mock,
    );
  });

  // test('adding item increases total cost', () {
  //   final cart = CartModel();
  //   final startingPrice = cart.totalPrice;
  //   var i = 0;
  //   cart.addListener(() {
  //     expect(cart.totalPrice, greaterThan(startingPrice));
  //     i++;
  //   });
  //   cart.add(Item('Dash'));
  //   expect(i, 1);
  // });

  test('fetchNextPage updates status to loading and notifies listeners',
      () async {
    expect(characterChangeNotifier.status.value, CharacterStatus.initial);
    var loaded = false;
    var success = false;
    var list = [];

    characterChangeNotifier.addListener(() {
      if (characterChangeNotifier.status.value == CharacterStatus.loading) {
        loaded = true;
      }
      if (characterChangeNotifier.status.value == CharacterStatus.success) {
        success = true;
        list = characterChangeNotifier.characters.value;
      }
    });

    await characterChangeNotifier.fetchNextPage();
    expect(loaded, true);
    expect(success, true);
    expect(list.length, [...characterList1, ...characterList2].length);
  });

  test('fetchNextPage fetches characters and updates state', () async {
    characterChangeNotifier.currentPage.value = 1;

    await characterChangeNotifier.fetchNextPage();

    expect(characterChangeNotifier.currentPage.value, 2);
    expect(characterChangeNotifier.status.value, CharacterStatus.success);
    expect(characterChangeNotifier.characters.value, isNotEmpty);
    expect(characterChangeNotifier.hasReachedEnd.value, isFalse);
  });

  test('fetchNextPage does not fetch if hasReachedEnd is true', () async {
    characterChangeNotifier.hasReachedEnd.value = true;

    await characterChangeNotifier.fetchNextPage();

    expect(characterChangeNotifier.currentPage.value, 1);
    expect(characterChangeNotifier.status.value, CharacterStatus.initial);
    expect(characterChangeNotifier.characters.value, isEmpty);
  });
}
