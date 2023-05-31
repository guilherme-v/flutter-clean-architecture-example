import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';

class GetAllCharacters {
  Future<List<Character>> call({int page = 0}) async {
    final list = await CharacterRepositoryImpl().getCharacters(page: page);
    return list;
  }
}
