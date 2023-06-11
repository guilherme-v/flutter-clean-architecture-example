part of 'character_page_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadNextPageEvent extends HomeEvent {
  const LoadNextPageEvent();
}
