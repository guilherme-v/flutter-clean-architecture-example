part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.characters = const [],
    this.hasReachedEnd = false,
  });

  final HomeStatus status;
  final List<Character> characters;
  final bool hasReachedEnd;

  HomeState copyWith({
    HomeStatus? status,
    List<Character>? characters,
    bool? hasReachedEnd,
  }) {
    return HomeState(
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
