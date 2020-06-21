import 'package:dartz/dartz.dart';

import '../../../commons/errors/failure.dart';
import '../../../layers/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<Character>>> getAllCharacters();
}
