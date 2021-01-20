import 'package:flutter/foundation.dart';

import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_all_characters.dart';
import '../view_data/view_data_notifier.dart';

class HomeController {
  final GetAllCharacters _getAllCharacters;

  HomeController({
    @required GetAllCharacters getAllCharacters,
  }) : this._getAllCharacters = getAllCharacters;

  // Wrap this is one Single class
  final listNotifier = ViewDataNotifier<List<Character>>(null);

  Future<void> loadAllCharacters() async {
    listNotifier.setLoading(true);

    final result = await _getAllCharacters();
    result.fold(
      (e) => {},
      (list) => listNotifier.setData(list),
    );

    listNotifier.setLoading(false);
  }

  void dispose() {
    listNotifier.dispose();
  }
}
