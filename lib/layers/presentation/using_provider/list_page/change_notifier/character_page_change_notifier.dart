import 'package:flutter/material.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

enum CharacterPageStatus { initial, loading, success, failed }

class CharacterPageChangeNotifier extends ChangeNotifier {
  CharacterPageChangeNotifier({
    required GetAllCharacters getAllCharacters,
    List<Character>? characters,
    CharacterPageStatus? initialStatus,
    int? initialPage,
  })  : _getAllCharacters = getAllCharacters,
        _characters = characters ?? [],
        _status = initialStatus ?? CharacterPageStatus.initial,
        _currentPage = initialPage ?? 1;

  // ---------------------------------------------------------------------------
  // Use cases
  // ---------------------------------------------------------------------------
  final GetAllCharacters _getAllCharacters;

  // ---------------------------------------------------------------------------
  // Properties
  // ---------------------------------------------------------------------------
  CharacterPageStatus _status;
  CharacterPageStatus get status => _status;

  final List<Character> _characters;
  List<Character> get characters => List.unmodifiable(_characters);

  int _currentPage;
  int get currentPage => _currentPage;

  var _hasReachedEnd = false;
  bool get hasReachedEnd => _hasReachedEnd;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  Future<void> fetchNextPage() async {
    if (_hasReachedEnd) return;

    _status = CharacterPageStatus.loading;
    notifyListeners();

    final list = await _getAllCharacters(page: _currentPage);
    _currentPage++;
    _characters.addAll(list);
    _status = CharacterPageStatus.success;
    _hasReachedEnd = list.isEmpty;
    notifyListeners();
  }
}
