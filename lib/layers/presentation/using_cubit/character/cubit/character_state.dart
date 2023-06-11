part of 'character_cubit.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState extends Equatable {
  const CharacterState({
    this.characters = const [],
    this.currentPage = 1,
    this.status = CharacterStatus.initial,
    this.hasReachedEnd = false,
  });

  final List<Character> characters;
  final int currentPage;
  final CharacterStatus status;
  final bool hasReachedEnd;

  CharacterState copyWith({
    List<Character>? characters,
    int? currentPage,
    CharacterStatus? status,
    bool? hasReachedEnd,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object> get props => [
        characters,
        currentPage,
        status,
        hasReachedEnd,
      ];
}
