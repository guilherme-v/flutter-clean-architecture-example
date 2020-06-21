import 'package:clean_arch_flutter/layers/data/models/character_data.dart';
import 'package:clean_arch_flutter/layers/network/datasources/character_network_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../test_resources/fixtures/fixture_reader.dart';

class HttpClientMock extends Mock implements http.Client {}

main() {
  CharacterNetworkDatasourceImpl datasource;
  http.Client httpClientMock;

  setUp(() {
    httpClientMock = HttpClientMock();
    datasource = CharacterNetworkDatasourceImpl(client: httpClientMock);
  });

  void setUpMockHttpClientSuccess200() {
    when(httpClientMock.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('all_characters.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(httpClientMock.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  test(
    'It should call the right endpoint when asking for all characters',
    () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      await datasource.getAllCharacters();

      // assert
      verify(httpClientMock.get(
        "https://rickandmortyapi.com/api/character/",
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    },
  );

  test(
    'should return List<CharacterData> when the response code is 200 (success)',
    () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await datasource.getAllCharacters();
      // assert
      expect(result, isA<List<CharacterData>>());
    },
  );
}
