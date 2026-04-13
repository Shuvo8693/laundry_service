import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String get message;
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  final String? _message;

  ServerFailure([this._message]);

  @override
  String get message => _message ?? 'Server failure occurred';
}

class NetworkFailure extends Failure {
  final String? _message;

  NetworkFailure([this._message]);

  @override
  String get message => _message ?? 'Network failure occurred';
}

class CacheFailure extends Failure {
  final String? _message;

  CacheFailure([this._message]);

  @override
  String get message => _message ?? 'Cache failure occurred';
}
