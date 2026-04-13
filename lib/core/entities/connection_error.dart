/// Represents different types of connection errors
enum ConnectionErrorType {
  /// No internet connection available
  noInternet,
}

/// Exception representing a connection error
class ConnectionError implements Exception {
  /// The type of connection error
  final ConnectionErrorType type;

  /// Optional message describing the error
  final String? message;

  const ConnectionError({
    required this.type,
    this.message,
  });

  @override
  String toString() {
    switch (type) {
      case ConnectionErrorType.noInternet:
        return message ?? 'No internet connection';
    }
  }
}
