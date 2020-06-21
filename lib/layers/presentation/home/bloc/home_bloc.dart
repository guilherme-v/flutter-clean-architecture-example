import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_all_characters.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllCharacters getAllCharacters;

  HomeBloc({@required this.getAllCharacters});

  @override
  HomeState get initialState => Initial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadButtonClickEvent) {
      yield* _showLoadingAndFetchCharacters();
    }
  }

  Stream<HomeState> _showLoadingAndFetchCharacters() async* {
    // Show loading
    yield Loading();

    // Fetch the list
    final result = await getAllCharacters();

    // Handle success or error
    yield result.fold(
      (e) => Error(""),
      (list) => Success(characterList: list),
    );
  }
}
