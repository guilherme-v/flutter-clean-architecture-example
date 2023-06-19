part of 'character_page_bloc.dart';

sealed class CharacterPageEvent extends Equatable {
  const CharacterPageEvent();

  @override
  List<Object?> get props => [];
}

final class FetchNextPageEvent extends CharacterPageEvent {
  const FetchNextPageEvent();
}
