part of 'character_bloc.dart';

sealed class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

final class LoadNextPageEvent extends CharacterEvent {
  const LoadNextPageEvent();
}
