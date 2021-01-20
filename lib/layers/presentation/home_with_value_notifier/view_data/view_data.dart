class ViewData<T> {
  final T data;
  final bool isLoading;
  final Exception error;

  const ViewData(
    this.data, {
    this.isLoading = false,
    this.error,
  });

  ViewData<T> copyWith({T data, bool isLoading, Exception error}) {
    if (_nothingHasChanged(data, isLoading, error)) return this;

    return ViewData(
      data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool _nothingHasChanged(data, bool isLoading, Exception error) {
    return (data == null || identical(data, this.data)) &&
        (isLoading == null || identical(isLoading, this.isLoading)) &&
        (error == null || identical(error, this.error));
  }
}
