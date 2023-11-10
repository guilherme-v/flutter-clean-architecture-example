part of 'character_details_bloc.dart';

class CharacterDetailsState with EquatableMixin {
  CharacterDetailsState({required this.character});

  final Character character;

  @override
  List<Object?> get props => [character];
}
