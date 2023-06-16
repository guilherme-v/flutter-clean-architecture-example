import 'package:flutter/foundation.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

enum CharacterStatus { initial, loading, success, failed }

class CharacterChangeNotifier extends ChangeNotifier {
  CharacterChangeNotifier({
    required GetAllCharacters getAllCharacters,
  }) : _getAllCharacters = getAllCharacters;

  final GetAllCharacters _getAllCharacters;

  final status = ValueNotifier(CharacterStatus.initial);
  final characters = ValueNotifier(<Character>[]);
  final currentPage = ValueNotifier(1);
  final hasReachedEnd = ValueNotifier(false);

  Future<void> fetchNextPage() async {
    if (hasReachedEnd.value) return;

    status.value = CharacterStatus.loading;
    notifyListeners();

    final list = await _getAllCharacters(page: currentPage.value);
    currentPage.value = currentPage.value + 1;
    characters.value = characters.value..addAll(list);
    status.value = CharacterStatus.success;
    hasReachedEnd.value = list.isEmpty;
    notifyListeners();
  }
}
