import 'package:flutter/foundation.dart';

import '../../domain/entities/character.dart';

class CharacterData extends Character {
  CharacterData({
    @required id,
    @required name,
    @required status,
    @required species,
    @required image,
    @required created,
  }) : super(
          id: id,
          name: name,
          status: status,
          species: species,
          image: image,
          created: created,
        );

  factory CharacterData.fromJson(Map<String, dynamic> json) {
    return CharacterData(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'created': created
    };
  }
}
