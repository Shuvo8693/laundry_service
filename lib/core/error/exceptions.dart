class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Exception occur'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache Exception occur'});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Network Exception occur'});
}
