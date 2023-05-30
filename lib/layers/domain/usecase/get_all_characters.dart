import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';

class GetAllCharacters {

  Future<List<Character>> call() async {
    final list = await CharacterRepositoryImpl().getCharacters();
    return list;
  }
}
