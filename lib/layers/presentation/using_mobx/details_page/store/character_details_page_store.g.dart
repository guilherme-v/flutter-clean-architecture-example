// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_details_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterDetailsPageStore on CharacterDetailsPageStoreBase, Store {
  late final _$_characterAtom =
      Atom(name: 'CharacterDetailsPageStoreBase._character', context: context);

  Character get character {
    _$_characterAtom.reportRead();
    return super._character;
  }

  @override
  Character get _character => character;

  @override
  set _character(Character value) {
    _$_characterAtom.reportWrite(value, super._character, () {
      super._character = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
