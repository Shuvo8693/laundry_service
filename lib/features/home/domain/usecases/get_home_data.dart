import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/home/domain/entities/home_entity.dart';
import 'package:e_laundry/features/home/domain/repositories/home_repository.dart';

class GetHomeData {
  final HomeRepository repository;

  GetHomeData(this.repository);

  Future<Either<Failure, HomeEntity>> call() async {
    return await repository.getHomeData();
  }
}
