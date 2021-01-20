import 'package:flutter/foundation.dart';

import 'view_data.dart';

class ViewDataNotifier<T> extends ValueNotifier<ViewData<T>> {
  ViewDataNotifier(T value) : super(ViewData(value));

  setLoading(bool newValue) {
    if (value.isLoading == newValue) return;
    value = value.copyWith(isLoading: newValue);
    notifyListeners();
  }

  setError(Exception newValue) {
    if (value.error == newValue) return;
    value = value.copyWith(error: newValue);
    notifyListeners();
  }

  setData(T newValue) {
    if (value.data == newValue) return;
    value = value.copyWith(data: newValue);
    notifyListeners();
  }
}
