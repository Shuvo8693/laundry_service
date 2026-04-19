import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/service_entity.dart';
import '../entities/cloth_item_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices();
  Future<Either<Failure, List<ClothItemEntity>>> getClothItems();
}
