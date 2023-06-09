import 'package:dio/dio.dart';
import 'package:rickmorty/layers/data/dto/character_dto.dart';

abstract class Api {
  Future<List<CharacterDto>> loadCharacters({int page = 0});
}

class ApiImpl implements Api {
  final dio = Dio();

  @override
  Future<List<CharacterDto>> loadCharacters({int page = 0}) async {
    try {
      Response response;
      response = await dio
          .get('https://rickandmortyapi.com/api/character/?page=$page');

      final l = (response.data['results'] as List)
          .map((e) => CharacterDto.fromMap(e))
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
