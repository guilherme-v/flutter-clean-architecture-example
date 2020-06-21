import 'package:clean_arch_flutter/layers/domain/entities/character.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

class CharacterFakeFactory {
  static Character create({
    int id,
    String name,
    String status,
    String species,
    String image,
    String created,
  }) {
    return Character(
        id: id ?? faker.randomGenerator.integer(1000),
        name: name ?? faker.person.firstName(),
        status: status ?? faker.lorem.word(),
        species: species ?? faker.lorem.word(),
        image: image ?? faker.lorem.word(),
        created: created ?? DateTime.now().toUtc().toIso8601String());
  }

  static List<Character> createList({@required int size}) {
    List<Character> list = [];
    for (var i = 0; i < size; i++) {
      list.add(create());
    }
    return list;
  }
}
