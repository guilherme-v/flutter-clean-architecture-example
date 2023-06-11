import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/repository/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final Api _api;
  final LocalStorage _localStorage;

  CharacterRepositoryImpl({
    required Api api,
    required LocalStorage localStorage,
  })  : _api = api,
        _localStorage = localStorage;

  @override
  Future<List<Character>> getCharacters({int page = 0}) async {
    final cachedList = _localStorage.loadCharactersPage(page: page);
    if (cachedList.isNotEmpty) {
      return cachedList;
    }

    final fetchedList = await _api.loadCharacters(page: page);
    await _localStorage.saveCharactersPage(page: page, list: fetchedList);
    return fetchedList;
  }
}
