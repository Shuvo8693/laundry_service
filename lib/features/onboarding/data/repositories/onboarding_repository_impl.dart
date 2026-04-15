import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/onboarding/data/datasources/mock_onboarding_datasource.dart';
import 'package:e_laundry/features/onboarding/domain/entities/onboarding_page_entity.dart';
import 'package:e_laundry/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final MockOnboardingDataSource mockDataSource;

  OnboardingRepositoryImpl({required this.mockDataSource});

  @override
  Future<Either<Failure, List<OnboardingPageEntity>>> getOnboardingPages() async {
    try {
      final pages = await mockDataSource.fetchOnboardingPages();
      return Right(pages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
