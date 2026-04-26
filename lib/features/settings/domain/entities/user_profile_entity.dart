import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String gender;
  final String? profileImage;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.gender,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, phone, gender, profileImage];

  UserProfileEntity copyWith({
    String? name,
    String? phone,
    String? gender,
    String? profileImage,
  }) {
    return UserProfileEntity(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
