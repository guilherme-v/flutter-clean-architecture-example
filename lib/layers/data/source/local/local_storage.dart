import 'package:rickmorty/layers/data/dto/character_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedCharacterListKey = 'CACHED_CHARACTER_LIST_PAGE';

abstract class LocalStorage {
  Future<bool> saveCharactersPage({
    required int page,
    required List<CharacterDto> list,
  });

  List<CharacterDto> loadCharactersPage({required int page});
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _sharedPref;

  LocalStorageImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPref = sharedPreferences;

  @override
  List<CharacterDto> loadCharactersPage({required int page}) {
    final key = _getKeyToPage(page);
    final jsonList = _sharedPref.getStringList(key);

    return jsonList != null
        ? jsonList.map((e) => CharacterDto.fromRawJson(e)).toList()
        : [];
  }

  @override
  saveCharactersPage({
    required int page,
    required List<CharacterDto> list,
  }) {
    final jsonList = list.map((e) => e.toRawJson()).toList();
    final key = _getKeyToPage(page);
    return _sharedPref.setStringList(key, jsonList);
  }

  String _getKeyToPage(int page) {
    return '${cachedCharacterListKey}_$page';
  }
}
