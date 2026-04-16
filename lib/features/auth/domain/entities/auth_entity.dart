import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String token;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, phone, token];
}
