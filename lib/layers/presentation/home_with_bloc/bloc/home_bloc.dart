import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/get_all_characters.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllCharacters getAllCharacters;

  HomeCubit({@required this.getAllCharacters}) : super(Initial());

  void showLoadingAndFetchCharacters() async {
    // Show loading
    emit(Loading());

    // Fetch the list
    final result = await getAllCharacters();

    // Handle success or error
    final updatedState = result.fold(
      (e) => Error(""),
      (list) => Success(characterList: list),
    );

    emit(updatedState);
  }
}
