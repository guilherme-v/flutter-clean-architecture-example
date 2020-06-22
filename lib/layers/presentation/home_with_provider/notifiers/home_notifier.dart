import 'package:clean_arch_flutter/layers/domain/usecases/get_all_characters.dart';
import 'package:flutter/foundation.dart';

import 'home_model.dart';

class HomeNotifier with ChangeNotifier {
  final GetAllCharacters _getAllCharacters;

  HomeNotifier({
    @required GetAllCharacters getAllCharacters,
  }) : _getAllCharacters = getAllCharacters;

  // TODO: Remove model and use ChangeNotifer directly?
  var _model = HomeModel(isLoading: false, charactersList: null, error: null);
  HomeModel get homeModel => _model;

  Future<void> loadAllCharacters() async {
    // show loading
    _model = _model.copyWith(isLoading: true);
    notifyListeners();

    // Fetch the list
    final result = await _getAllCharacters();

    // Handle success or error
    result.fold(
      (e) => _model = _model.copyWith(error: "Fail", isLoading: false),
      (list) => _model = _model.copyWith(
        charactersList: list,
        isLoading: false,
      ),
    );

    // notify UI
    notifyListeners();
  }
}
