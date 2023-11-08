// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterPageStore on CharacterPageStoreBase, Store {
  late final _$_contentStatusAtom =
      Atom(name: 'CharacterPageStoreBase._contentStatus', context: context);

  CharacterPageStatus get contentStatus {
    _$_contentStatusAtom.reportRead();
    return super._contentStatus;
  }

  @override
  CharacterPageStatus get _contentStatus => contentStatus;

  @override
  set _contentStatus(CharacterPageStatus value) {
    _$_contentStatusAtom.reportWrite(value, super._contentStatus, () {
      super._contentStatus = value;
    });
  }

  late final _$_currentPageAtom =
      Atom(name: 'CharacterPageStoreBase._currentPage', context: context);

  int get currentPage {
    _$_currentPageAtom.reportRead();
    return super._currentPage;
  }

  @override
  int get _currentPage => currentPage;

  @override
  set _currentPage(int value) {
    _$_currentPageAtom.reportWrite(value, super._currentPage, () {
      super._currentPage = value;
    });
  }

  late final _$_hasReachedEndAtom =
      Atom(name: 'CharacterPageStoreBase._hasReachedEnd', context: context);

  bool get hasReachedEnd {
    _$_hasReachedEndAtom.reportRead();
    return super._hasReachedEnd;
  }

  @override
  bool get _hasReachedEnd => hasReachedEnd;

  @override
  set _hasReachedEnd(bool value) {
    _$_hasReachedEndAtom.reportWrite(value, super._hasReachedEnd, () {
      super._hasReachedEnd = value;
    });
  }

  late final _$fetchNextPageAsyncAction =
      AsyncAction('CharacterPageStoreBase.fetchNextPage', context: context);

  @override
  Future<void> fetchNextPage() {
    return _$fetchNextPageAsyncAction.run(() => super.fetchNextPage());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
