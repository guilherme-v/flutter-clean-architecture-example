import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../domain/usecases/get_all_characters.dart';
import 'home_state.dart';

class HomeStateNotifier extends StateNotifier<HomeState> {
  final GetAllCharacters getAllCharacters;

  HomeStateNotifier({
    @required this.getAllCharacters,
  }) : super(HomeState());

  void loadAllCharacters() async {
    state = state.copyWith(isLoading: true);

    // Fetch the list
    final result = await getAllCharacters();

    // Handle success or error
    result.fold(
      (e) {
        state = state.copyWith(errorMessage: 'fail', isLoading: false);
      },
      (list) {
        final copy = state.copyWith(charactersList: list, isLoading: false);
        state = copy;
      },
    );
  }
}
