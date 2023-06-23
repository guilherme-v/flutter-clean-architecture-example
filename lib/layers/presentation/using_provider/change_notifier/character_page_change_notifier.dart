import 'package:flutter/material.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

enum CharacterPageStatus { initial, loading, success, failed }

class CharacterPageChangeNotifier extends ChangeNotifier {
  CharacterPageChangeNotifier({
    required GetAllCharacters getAllCharacters,
  }) : _getAllCharacters = getAllCharacters;

  final GetAllCharacters _getAllCharacters;

  var _status = CharacterPageStatus.initial;
  get status => _status;

  final _characters = <Character>[];
  get characters => List.unmodifiable(_characters);

  int _currentPage = 1;
  get currentPage => _currentPage;

  var _hasReachedEnd = false;
  get hasReachedEnd => _hasReachedEnd;

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
