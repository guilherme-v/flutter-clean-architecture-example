import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit({
    required GetAllCharacters getAllCharacters,
  })  : _getAllCharacters = getAllCharacters,
        super(const CharacterState());

  final GetAllCharacters _getAllCharacters;

  Future<void> fetchNextPage() async {
    if (state.hasReachedEnd) return;

    emit(state.copyWith(status: CharacterStatus.loading));

    final list = await _getAllCharacters(page: state.currentPage);

    emit(state.copyWith(
      status: CharacterStatus.success,
      hasReachedEnd: list.isEmpty,
      currentPage: state.currentPage + 1,
      characters: List.of(state.characters)..addAll(list),
    ));
  }
}
