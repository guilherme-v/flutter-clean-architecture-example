import '../models/character_data.dart';

abstract class CharacterLocalDatasource {
  /// Get the latest [List<CharacterData>] cached when internet was available
  ///
  /// Throws a [List<CharacterData>] if no cached data is present.
  Future<List<CharacterData>> getAllCharacters();

  /// Caches a [List<CharacterData>] cached when internet was available
  ///
  /// Throws a [List<CharacterData>] if no cached data is present.
  Future<List<CharacterData>> cacheCharacterList(List<CharacterData> list);
}
