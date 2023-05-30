part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.characters = const [],
  });

  final HomeStatus status;
  final List<Character> characters;

  HomeState copyWith({
    HomeStatus? status,
    List<Character>? characters,
  }) {
    return HomeState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
    );
  }

  @override
  List<Object> get props => [
        status,
        characters,
      ];
}
