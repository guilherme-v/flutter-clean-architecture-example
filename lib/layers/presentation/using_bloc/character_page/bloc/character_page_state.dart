part of './character_page_bloc.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState extends Equatable {
  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  final CharacterStatus status;
  final List<Character> characters;
  final bool hasReachedEnd;
  final int currentPage;

  CharacterState copyWith({
    CharacterStatus? status,
    List<Character>? characters,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return CharacterState(
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
