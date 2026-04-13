import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/splash/domain/entities/splash_page_data.dart';

abstract class SplashRepository {
  Future<Either<Failure, SplashPageData>> getSplashPageData();
}
