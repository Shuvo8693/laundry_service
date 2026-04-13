/// Example usage of NetworkCaller
/// 
/// This file demonstrates how to use the NetworkCaller implementation
/// in your repositories or data sources.
library;

// import 'package:dartz/dartz.dart';
// import 'package:e_laundry/core/network/network_caller.dart';
// import 'package:e_laundry/core/error/failures.dart';
//
// /// Example repository using NetworkCaller
// class ExampleRepository {
//   final NetworkCaller networkCaller;
//
//   ExampleRepository({required this.networkCaller});
//
//   /// Example GET request
//   Future<Either<Failure, Map<String, dynamic>>> fetchData() async {
//     return await networkCaller.get<Map<String, dynamic>>(
//       url: 'https://api.example.com/data',
//       queryParameters: {'page': 1},
//       headers: {'Authorization': 'Bearer token'},
//       responseDeserializer: (data) {
//         if (data is Map<String, dynamic>) {
//           return data;
//         }
//         return <String, dynamic>{};
//       },
//     );
//   }
//
//   /// Example POST request
//   Future<Either<Failure, Map<String, dynamic>>> submitData(
//     Map<String, dynamic> body,
//   ) async {
//     return await networkCaller.post<Map<String, dynamic>>(
//       url: 'https://api.example.com/submit',
//       body: body,
//       headers: {
//         'Authorization': 'Bearer token',
//         'Content-Type': 'application/json',
//       },
//       responseDeserializer: (data) {
//         if (data is Map<String, dynamic>) {
//           return data;
//         }
//         return <String, dynamic>{};
//       },
//     );
//   }
//
//   /// Example with custom model deserialization
//   Future<Either<Failure, UserModel>> getUserProfile(String userId) async {
//     return await networkCaller.get<UserModel>(
//       url: 'https://api.example.com/users/$userId',
//       headers: {'Authorization': 'Bearer token'},
//       responseDeserializer: (data) {
//         if (data is Map<String, dynamic>) {
//           return UserModel.fromJson(data);
//         }
//         throw Exception('Invalid response format');
//       },
//     );
//   }
// }
//
// /// Example usage in a Cubit/Bloc
// class ExampleCubit extends Cubit<ExampleState> {
//   final ExampleRepository repository;
//
//   ExampleCubit({required this.repository}) : super(ExampleInitial());
//
//   Future<void> loadData() async {
//     emit(ExampleLoading());
//
//     final result = await repository.fetchData();
//
//     result.fold(
//       (failure) => emit(ExampleError(message: failure.message)),
//       (data) => emit(ExampleSuccess(data: data)),
//     );
//   }
// }
//
// /// Example with error handling
// class ResilientRepository {
//   final NetworkCaller networkCaller;
//
//   ResilientRepository({required this.networkCaller});
//
//   Future<Either<Failure, T>> safeCall<T>({
//     required Future<Either<Failure, NetworkResponse<T>>> Function() apiCall,
//     required T Function() defaultValue,
//   }) async {
//     try {
//       final result = await apiCall();
//       return result.fold(
//         (failure) {
//           // Log error, show snackbar, etc.
//           return Left(failure);
//         },
//         (response) {
//           if (response.isSuccess) {
//             return Right(response.data ?? defaultValue());
//           }
//           return Left(ServerFailure('Request failed with status: ${response.statusCode}'));
//         },
//       );
//     } catch (e) {
//       return Left(ServerFailure('Unexpected error: $e'));
//     }
//   }
//
//   Future<Either<Failure, List<Map<String, dynamic>>>> fetchList() async {
//     return await safeCall<List<Map<String, dynamic>>>(
//       apiCall: () => networkCaller.get<List<Map<String, dynamic>>>(
//         url: 'https://api.example.com/items',
//         responseDeserializer: (data) {
//           if (data is List) {
//             return data.whereType<Map<String, dynamic>>().toList();
//           }
//           return [];
//         },
//       ),
//       defaultValue: () => [],
//     );
//   }
// }
