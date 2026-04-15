import 'package:equatable/equatable.dart';

class OnboardingPageEntity extends Equatable {
  final String title;
  final String subtitle;
  final String iconPath;
  final String illustrationBackgroundColor;

  const OnboardingPageEntity({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.illustrationBackgroundColor,
  });

  @override
  List<Object?> get props => [title, subtitle, iconPath, illustrationBackgroundColor];
}
