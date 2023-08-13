class ServerException implements Exception {
  String? exceptionMessage;

  ServerException({
    this.exceptionMessage,
  });
  @override
  String toString() {
    Object? message = exceptionMessage;
    if (message == null) return "Exception";
    return "$message";
  }
}