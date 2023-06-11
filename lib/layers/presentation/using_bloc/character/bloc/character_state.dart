part of './character_bloc.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState extends Equatable {
  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const [],
    this.hasReachedEnd = false,
  });

  final CharacterStatus status;
  final List<Character> characters;
  final bool hasReachedEnd;

  CharacterState copyWith({
    CharacterStatus? status,
    List<Character>? characters,
    bool? hasReachedEnd,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object> get props => [
        status,
        characters,
        hasReachedEnd,
      ];
}
