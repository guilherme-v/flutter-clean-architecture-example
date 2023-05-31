import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/repository/character_repository.dart';
import 'package:dio/dio.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final dio = Dio();

  void request() async {}

  @override
  Future<List<Character>> getCharacters({int page = 0}) async {
    try {
      Response response;
      response = await dio
          .get('https://rickandmortyapi.com/api/character/?page=$page');

      final l = (response.data['results'] as List)
          .map((e) => Character.fromJson(e))
          .toList();
      return l;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
  }
}

void main() async {
  final a = CharacterRepositoryImpl();
  final l = await a.getCharacters();
  print(l);
}
