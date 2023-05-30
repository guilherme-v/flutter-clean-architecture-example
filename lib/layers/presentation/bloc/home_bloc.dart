import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.getAllCharacters,
  }) : super(const HomeState()) {
    on<HomeInitEvent>(_loadFirstPage);
  }

  final GetAllCharacters getAllCharacters;

  Future<void> _loadFirstPage(event, emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final list = await getAllCharacters();

    emit(state.copyWith(
      status: HomeStatus.success,
      characters: list,
    ));
  }
}
