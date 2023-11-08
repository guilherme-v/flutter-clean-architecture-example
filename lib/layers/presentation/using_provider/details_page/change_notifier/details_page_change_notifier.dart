import 'package:flutter/foundation.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';

class DetailsPageChangeNotifier extends ChangeNotifier {
  DetailsPageChangeNotifier({required this.character});

  final Character character;
}
