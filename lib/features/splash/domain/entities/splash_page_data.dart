import 'package:equatable/equatable.dart';

class SplashPageData extends Equatable {
  final String title;
  final String subTitle;
  final String logoPath;
  final String academicIntegrityText;

  const SplashPageData({
    required this.title,
    required this.subTitle,
    required this.logoPath,
    required this.academicIntegrityText,
  });

  @override
  List<Object?> get props => [title, subTitle, logoPath, academicIntegrityText];
}
