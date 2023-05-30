import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/repository/character_repository.dart';
import 'package:dio/dio.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final dio = Dio();

  void request() async {}

  @override
  Future<List<Character>> getCharacters({int page = 0}) async {
    Response response;
    response =
        await dio.get('https://rickandmortyapi.com/api/character/?page=2');
    print(response.data.toString());
    final l = (response.data['results'] as List).map((e) => Character.fromJson(e)).toList();
    return l;
  }
}

void main() async {
  final a = CharacterRepositoryImpl();
  final l = await a.getCharacters();
  print(l);
}