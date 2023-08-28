part of 'character_page_bloc.dart';

enum CharacterPageStatus { initial, loading, success, failure }

class CharacterPageState extends Equatable {
  const CharacterPageState({
    this.status = CharacterPageStatus.initial,
    this.characters = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  final CharacterPageStatus status;
  final List<Character> characters;
  final bool hasReachedEnd;
  final int currentPage;

  CharacterPageState copyWith({
    CharacterPageStatus? status,
    List<Character>? characters,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return CharacterPageState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [
        status,
        characters,
        hasReachedEnd,
        currentPage,
      ];
}
