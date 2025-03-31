class Result<T> {
  Result({this.data, this.error});
  final T? data;
  final String? error;

  bool get isSuccess => data != null;
}
