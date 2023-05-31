import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';

part 'home_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.getAllCharacters,
  }) : super(const HomeState()) {
    on<LoadNextPageEvent>(
      _loadNextPage,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final GetAllCharacters getAllCharacters;
  var _currentPage = 40;

  Future<void> _loadNextPage(event, emit) async {
    if (state.hasReachedEnd) return;

    emit(state.copyWith(status: HomeStatus.loading));

    print("FEEETCHING $_currentPage");

    final list = await getAllCharacters(page: _currentPage);

    Future.delayed(Duration(seconds: 1));

    emit(state.copyWith(
      status: HomeStatus.success,
      characters: List.of(state.characters)..addAll(list),
      hasReachedEnd: list.isEmpty,
    ));

    _currentPage++;
  }
}
