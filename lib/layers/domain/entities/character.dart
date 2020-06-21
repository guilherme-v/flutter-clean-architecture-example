import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String created;

  Character({
    @required this.id,
    @required this.name,
    @required this.status,
    @required this.species,
    @required this.image,
    @required this.created,
  });

  @override
  List<Object> get props => [id, name, status, species, image, created];
}
