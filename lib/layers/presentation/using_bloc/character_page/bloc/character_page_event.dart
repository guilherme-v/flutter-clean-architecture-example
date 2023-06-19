part of 'character_page_bloc.dart';

sealed class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

final class FetchNextPageEvent extends CharacterEvent {
  const FetchNextPageEvent();
}
