import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../commons/errors/failure.dart';
import '../../../layers/domain/entities/character.dart';
import '../repositories/character_repository.dart';

class GetAllCharacters {
  final CharacterRepository charactersRepository;

  GetAllCharacters({@required this.charactersRepository});

  Future<Either<Failure, List<Character>>> call() async {
    return charactersRepository.getAllCharacters();
  }
}
