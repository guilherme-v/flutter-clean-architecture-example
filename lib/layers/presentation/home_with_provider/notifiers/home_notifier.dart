import 'package:flutter/foundation.dart';

import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_all_characters.dart';

class HomeNotifier with ChangeNotifier {
  final GetAllCharacters _getAllCharacters;

  HomeNotifier({
    @required GetAllCharacters getAllCharacters,
  }) : _getAllCharacters = getAllCharacters;

  bool isLoading = false;
  List<Character> charactersList;
  String error;

  Future<void> loadAllCharacters() async {
    // show loading
    isLoading = true;
    notifyListeners();

    // Fetch the list
    final result = await _getAllCharacters();

    // Handle success or error
    result.fold(
      (e) {
        error = "fail";
        isLoading = false;
      },
      (list) {
        charactersList = list;
        isLoading = false;
      },
    );

    // notify UI
    notifyListeners();
  }
}
