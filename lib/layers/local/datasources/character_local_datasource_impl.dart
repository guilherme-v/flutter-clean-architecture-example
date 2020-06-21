import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/character_local_datasource.dart';
import '../../data/models/character_data.dart';

const CACHED_CHARACTER_LIST = 'CACHED_CHARACTER_LIST';

class CharacterLocalDatasourceImpl implements CharacterLocalDatasource {
  final SharedPreferences sharedPreferences;

  CharacterLocalDatasourceImpl({@required this.sharedPreferences});

  @override
  Future<List<CharacterData>> cacheCharacterList(List<CharacterData> list) {
    final jsonList = list.map((c) => json.encode(c.toJson())).toList();
    sharedPreferences.setStringList(CACHED_CHARACTER_LIST, jsonList);
    return Future.value(list);
  }

  @override
  Future<List<CharacterData>> getAllCharacters() {
    final jsonList = sharedPreferences.getStringList(CACHED_CHARACTER_LIST);
    if (jsonList != null) {
      return Future.value(
          jsonList.map((j) => CharacterData.fromJson(json.decode(j))).toList());
    } else {
      return Future.value(List<CharacterData>(0));
    }
  }
}
