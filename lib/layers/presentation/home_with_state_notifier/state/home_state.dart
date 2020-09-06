import '../../../domain/entities/character.dart';

class HomeState {
  final bool isLoading;
  final List<Character> charactersList;
  final String errorMessage;

  HomeState({
    this.isLoading = false,
    List<Character> charactersList,
    this.errorMessage = '',
  }) : this.charactersList = charactersList;

  HomeState copyWith({
    bool isLoading,
    List<Character> charactersList,
    String errorMessage,
  }) {
    // final list = List.of(charactersList);
    final l = charactersList;
    final a = HomeState(
      isLoading: isLoading ?? this.isLoading,
      charactersList: charactersList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
    return a;
  }
}
