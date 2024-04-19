// ignore_for_file: avoid_print

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
      final Response<Map<String, dynamic>> response = await dio
          .get('https://rickandmortyapi.com/api/character/?page=$page');
      print('page');
      final l = (response.data!['results'] as List<dynamic>)
          .map((e) => CharacterDto.fromMap(e))
          .toList();
      return l;
    } on DioException catch (e) {
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
        print(e);
      }
    }

    return [];
  }
}
