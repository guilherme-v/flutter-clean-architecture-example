import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/list_page/notifier/character_page_state.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/providers.dart';

final characterPageStateProvider =
    StateNotifierProvider<CharacterStateNotifier, CharacterPageState>(
  (ref) => CharacterStateNotifier(
    getAllCharacters: ref.read(getAllCharactersProvider),
  ),
);

class CharacterStateNotifier extends StateNotifier<CharacterPageState> {
  CharacterStateNotifier({
    required GetAllCharacters getAllCharacters,
  })  : _getAllCharacters = getAllCharacters,
        super(const CharacterPageState());

  final GetAllCharacters _getAllCharacters;

  Future<void> fetchNextPage() async {
    if (state.hasReachedEnd) return;

    state = state.copyWith(status: CharacterPageStatus.loading);

    final list = await _getAllCharacters(page: state.currentPage);
    state = state.copyWith(
      status: CharacterPageStatus.loading,
      currentPage: state.currentPage + 1,
      characters: List.of(state.characters)..addAll(list),
      hasReachedEnd: list.isEmpty,
    );
  }
}
