import 'package:clean_arch_flutter/commons/network/network_info.dart';
import 'package:clean_arch_flutter/layers/data/datasources/character_local_datasource.dart';
import 'package:clean_arch_flutter/layers/data/datasources/character_network_datasource.dart';
import 'package:clean_arch_flutter/layers/data/repositories/character_repository_impl.dart';
import 'package:clean_arch_flutter/layers/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_resources/fake/characters_data_fake_factory.dart';

class NetworkInfoMock extends Mock implements NetworkInfo {}

class CharacterLocalDatasourceMock extends Mock
    implements CharacterLocalDatasource {}

class CharacterNetworkDatasourceMock extends Mock
    implements CharacterNetworkDatasource {}

void main() {
  CharacterRepository characterRepository;
  NetworkInfo networkInfoMock;
  CharacterLocalDatasource localDatasource;
  CharacterNetworkDatasource networkDatasource;

  setUp(() {
    networkInfoMock = NetworkInfoMock();
    localDatasource = CharacterLocalDatasourceMock();
    networkDatasource = CharacterNetworkDatasourceMock();

    characterRepository = CharacterRepositoryImpl(
      networkInfo: networkInfoMock,
      localDatasource: localDatasource,
      networkDatasource: networkDatasource,
    );
  });

  final testCharacterData = CharacterDataFakeFactory.createList(size: 10);

  group('Given an Online Device', () {
    setUp(() {
      when(networkInfoMock.isConnected).thenAnswer((_) async => true);
    });

    test(
      'It should check when device is online',
      () async {
        // act
        await characterRepository.getAllCharacters();

        // assert
        verify(networkInfoMock.isConnected);
      },
    );

    test(
      'It should return network data when NetworkDatasorce returns sucessfully',
      () async {
        // arrange
        when(networkDatasource.getAllCharacters())
            .thenAnswer((_) async => testCharacterData);

        // act
        final result = await characterRepository.getAllCharacters();

        // assert
        expect(result, Right(testCharacterData));
        verify(networkDatasource.getAllCharacters());
      },
    );

    test(
      'It should update LocalCache when NetworkDatasorce returns sucessfully',
      () async {
        // arrange
        when(networkDatasource.getAllCharacters())
            .thenAnswer((_) async => testCharacterData);

        // act
        final result = await characterRepository.getAllCharacters();

        // assert
        expect(result, Right(testCharacterData));
        verify(networkDatasource.getAllCharacters());
        verify(localDatasource.cacheCharacterList(testCharacterData));
      },
    );
  });

  group('Given an Offline Device', () {
    setUp(() {
      when(networkInfoMock.isConnected).thenAnswer((_) async => false);
    });

    test(
      'It should return cached data when LocalDatasorce returns sucessfully',
      () async {
        // arrange
        when(localDatasource.getAllCharacters())
            .thenAnswer((_) async => testCharacterData);

        // act
        final result = await characterRepository.getAllCharacters();

        // assert
        expect(result, Right(testCharacterData));
        verify(localDatasource.getAllCharacters());
        verifyZeroInteractions(networkDatasource);
      },
    );
  });
}
