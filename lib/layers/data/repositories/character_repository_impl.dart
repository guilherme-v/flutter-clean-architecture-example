import 'package:dartz/dartz.dart';

import '../../../commons/errors/failure.dart';
import '../../../commons/network/network_info.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_network_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final NetworkInfo networkInfo;
  final CharacterLocalDatasource localDatasource;
  final CharacterNetworkDatasource networkDatasource;

  CharacterRepositoryImpl({
    this.networkInfo,
    this.localDatasource,
    this.networkDatasource,
  });

  @override
  Future<Either<Failure, List<Character>>> getAllCharacters() async {
    return await networkInfo.isConnected
        ? _getAllCharactersFromNetwork()
        : _getAllCharactersFromLocalCache();
  }

  Future<Either<Failure, List<Character>>>
      _getAllCharactersFromNetwork() async {
    try {
      final allCharactersList = await networkDatasource.getAllCharacters();
      await localDatasource.cacheCharacterList(allCharactersList);
      return Right(allCharactersList);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<Failure, List<Character>>>
      _getAllCharactersFromLocalCache() async {
    try {
      final allCharactersList = await localDatasource.getAllCharacters();
      return Right(allCharactersList);
    } catch (e) {
      return Left(e);
    }
  }
}
