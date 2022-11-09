class ApiException implements Exception {
  final String _message;

  ApiException(this._message);

  @override
  String toString() {
    return _message;
  }
}
