import 'package:clean_arch_flutter/commons/network/network_info.dart';
import 'package:clean_arch_flutter/layers/data/datasources/character_local_datasource.dart';
import 'package:clean_arch_flutter/layers/data/datasources/character_network_datasource.dart';
import 'package:clean_arch_flutter/layers/data/memory/in_memory_cache.dart';
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

class InMemoryCacheMock extends Mock implements InMemoryCache {}

CharacterRepository characterRepository;
NetworkInfoMock networkInfoMock;
CharacterLocalDatasourceMock localDatasource;
CharacterNetworkDatasourceMock networkDatasource;
InMemoryCacheMock inMemoryCache;
final testCharacterData = CharacterDataFakeFactory.createList(size: 10);

void main() {
  setUp(() {
    networkInfoMock = NetworkInfoMock();
    localDatasource = CharacterLocalDatasourceMock();
    networkDatasource = CharacterNetworkDatasourceMock();
    inMemoryCache = InMemoryCacheMock();

    characterRepository = CharacterRepositoryImpl(
      networkInfo: networkInfoMock,
      localDatasource: localDatasource,
      networkDatasource: networkDatasource,
      inMemoryCache: inMemoryCache,
    );
  });

  runOnlineScenarioTests();
  runOfflineScenarioTests();
}

void runOnlineScenarioTests() {
  group('Given an Online Device', () {
    setUp(() {
      when(networkInfoMock.isConnected).thenAnswer((_) async => true);
    });

    group('With an EMPTY Memory Cache', () {
      setUp(() {
        when(inMemoryCache.isNotEmpty).thenAnswer((_) => false);
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
        'It should fetch data from the network',
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
        'It should update Local Storage',
        () async {
          // arrange
          when(networkDatasource.getAllCharacters())
              .thenAnswer((_) async => testCharacterData);

          // act
          final result = await characterRepository.getAllCharacters();

          // assert
          expect(result, Right(testCharacterData));
          verify(localDatasource.cacheCharacterList(testCharacterData));
        },
      );

      test(
        'It should update inMemory Cache',
        () async {
          // arrange
          when(networkDatasource.getAllCharacters())
              .thenAnswer((_) async => testCharacterData);

          // act
          final result = await characterRepository.getAllCharacters();

          // assert
          verify(inMemoryCache.save(testCharacterData));
        },
      );
    });

    group('With a NOT EMPTY MemoryCache', () {
      setUp(() {
        when(inMemoryCache.isNotEmpty).thenAnswer((_) => true);
        when(inMemoryCache.getCachedValue())
            .thenAnswer((_) => testCharacterData);
      });

      test('It should use cache if not expired', () async {
        // arrange
        when(inMemoryCache.hasNotExpired).thenAnswer((_) => true);

        // act
        final result = await characterRepository.getAllCharacters();

        verifyZeroInteractions(networkDatasource);
        verifyZeroInteractions(localDatasource);
        verify(inMemoryCache.getCachedValue());
      });

      test('It should fetch new data if MemoryCache has expired', () async {
        // arrange
        when(inMemoryCache.hasNotExpired).thenAnswer((_) => false);
        when(networkDatasource.getAllCharacters())
            .thenAnswer((_) async => testCharacterData);

        // act
        final result = await characterRepository.getAllCharacters();

        expect(result, Right(testCharacterData));
        verify(networkDatasource.getAllCharacters());
        verify(localDatasource.cacheCharacterList(testCharacterData));
        verify(inMemoryCache.save(testCharacterData));
      });
    });
  });
}

void runOfflineScenarioTests() {
  group('Given an Offline Device', () {
    setUp(() {
      when(networkInfoMock.isConnected).thenAnswer((_) async => false);
    });

    group('With empty MemoryCache', () {
      setUp(() {
        when(inMemoryCache.isNotEmpty).thenAnswer((_) => false);
      });

      test(
        'It should return Local Storage data, and update MemoryCache',
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
  });
}
