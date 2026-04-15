import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/onboarding/domain/entities/onboarding_page_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<OnboardingPageEntity>>> getOnboardingPages();
}
