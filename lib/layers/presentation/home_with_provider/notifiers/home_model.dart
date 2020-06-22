import '../../../domain/entities/character.dart';

class HomeModel {
  bool isLoading;
  List<Character> charactersList;
  String error;

  HomeModel({
    this.isLoading,
    this.charactersList,
    this.error,
  });

  HomeModel copyWith({
    bool isLoading,
    List<Character> charactersList,
    String error,
  }) {
    return HomeModel(
      isLoading: isLoading ?? this.isLoading,
      charactersList: charactersList ?? this.charactersList,
      error: error ?? this.error,
    );
  }
}
