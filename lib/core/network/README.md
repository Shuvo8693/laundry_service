# Network Module

A robust, type-safe network calling implementation for Flutter applications using Dio, GetIt, and functional error handling with Dartz.

## Architecture

The network module follows Clean Architecture principles and consists of:

### Core Components

1. **NetworkCaller** - Abstract interface defining the contract for HTTP requests
2. **DioNetworkCallExecutor** - Concrete implementation using Dio HTTP client
3. **JsonSerializer** - Utility for JSON encoding/decoding
4. **NetworkErrorConverter** - Interface for converting exceptions to domain failures
5. **ConnectionError** - Custom exception for connectivity issues

### Key Features

- ✅ **Type-safe requests** with generic response deserialization
- ✅ **Functional error handling** using Either<Failure, Success> pattern
- ✅ **Connectivity checking** before making network calls
- ✅ **Dependency injection** ready (GetIt)
- ✅ **Clean Architecture** compliant
- ✅ **Extensible** - easy to add new HTTP methods or customize behavior
- ✅ **JSON serialization** utilities
- ✅ **Custom error conversion** for domain-specific error handling

## Setup

### 1. Register Dependencies in injection_container.dart

```dart
import 'package:e_laundry/core/network/network.dart';

Future<void> setUpNetworkExecutor() async {
  // Register Dio instance
  di.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    ),
  );

  // Register JSON Serializer
  di.registerSingleton<JsonSerializer>(JsonSerializer());

  // Register Error Converter
  di.registerFactory<NetworkErrorConverter<Failure>>(() => ErrorConverter());

  // Register NetworkCaller
  di.registerLazySingleton<NetworkCaller>(
    () => DioNetworkCallExecutor(
      errorConverter: di<NetworkErrorConverter<Failure>>(),
      dio: di<Dio>(),
      dioSerializer: di<JsonSerializer>(),
      connectivityResult: SessionData.connectivityResult,
    ),
  );
}
```

### 2. Initialize Session Data

```dart
await SessionData.start();
```

## Usage

### Basic GET Request

```dart
class UserRepository {
  final NetworkCaller networkCaller;

  UserRepository({required this.networkCaller});

  Future<Either<Failure, User>> getUser(String userId) async {
    final result = await networkCaller.get<User>(
      url: '/users/$userId',
      responseDeserializer: (data) {
        if (data is Map<String, dynamic>) {
          return User.fromJson(data);
        }
        throw Exception('Invalid response format');
      },
    );

    return result;
  }
}
```

### POST Request with Body

```dart
Future<Either<Failure, User>> createUser(CreateUserRequest request) async {
  final result = await networkCaller.post<User>(
    url: '/users',
    body: request.toJson(),
    headers: {'Content-Type': 'application/json'},
    responseDeserializer: (data) {
      if (data is Map<String, dynamic>) {
        return User.fromJson(data);
      }
      throw Exception('Invalid response format');
    },
  );

  return result;
}
```

### PUT, PATCH, DELETE Requests

```dart
// PUT request
final result = await networkCaller.put<void>(
  url: '/users/$userId',
  body: updateData.toJson(),
);

// PATCH request
final result = await networkCaller.patch<void>(
  url: '/users/$userId',
  body: partialUpdate.toJson(),
);

// DELETE request
final result = await networkCaller.delete<void>(
  url: '/users/$userId',
);
```

### Using in Bloc/Cubit

```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  Future<void> loadUser(String userId) async {
    emit(UserLoading());

    final result = await repository.getUser(userId);

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }
}
```

### Handling Query Parameters

```dart
final result = await networkCaller.get<List<Item>>(
  url: '/items',
  queryParameters: {
    'page': 1,
    'limit': 20,
    'sort': 'created_at',
  },
  responseDeserializer: (data) {
    if (data is List) {
      return data.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  },
);
```

### Custom Headers

```dart
final result = await networkCaller.get<User>(
  url: '/profile',
  headers: {
    'Authorization': 'Bearer ${userToken}',
    'Accept-Language': 'en',
  },
  responseDeserializer: (data) => User.fromJson(data as Map<String, dynamic>),
);
```

## Error Handling

The network module provides comprehensive error handling through the `NetworkErrorConverter` interface.

### Creating Custom Error Converter

```dart
class CustomErrorConverter implements NetworkErrorConverter<Failure> {
  @override
  Failure convert(Exception exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          return NetworkFailure('Connection timeout. Please check your internet.');
        case DioExceptionType.badResponse:
          final statusCode = exception.response?.statusCode;
          if (statusCode == 401) {
            return AuthenticationFailure('Session expired');
          }
          return ServerFailure('Server error: $statusCode');
        default:
          return NetworkFailure('Network error occurred');
      }
    }
    return ServerFailure('Unexpected error: ${exception.toString()}');
  }
}
```

### Failure Types

The module supports different types of failures:

- `ServerFailure` - Server-side errors (5xx responses)
- `NetworkFailure` - Network connectivity issues
- `CacheFailure` - Local cache errors
- Custom failures - Create your own by extending `Failure`

## Response Handling

### NetworkResponse Structure

```dart
class NetworkResponse<T> {
  final int statusCode;      // HTTP status code
  final T? data;             // Deserialized response data
  final Map<String, String> headers;  // Response headers
  final dynamic rawResponse; // Raw response data
}
```

### Checking Response Success

```dart
final result = await networkCaller.get<User>(url: '/users/1');

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (response) {
    if (response.isSuccess) {
      print('Success: ${response.data}');
    } else {
      print('HTTP ${response.statusCode}');
    }
  },
);
```

## JSON Serialization

### Using JsonSerializer

```dart
final serializer = JsonSerializer();

// Encode to JSON
final jsonString = serializer.encode({'name': 'John', 'age': 30});

// Decode from JSON
final map = serializer.decode(jsonString);

// Safe deserialization
final safeMap = serializer.tryDeserialize(jsonString);
```

## Connectivity Checking

The network caller automatically checks connectivity before making requests:

```dart
// SessionData manages connectivity state
class SessionData {
  static ConnectivityResult connectivityResult = ConnectivityResult.none;
  
  static Future<void> start() async {
    final results = await Connectivity().checkConnectivity();
    connectivityResult = results.isNotEmpty ? results.first : ConnectivityResult.none;
  }
}
```

## Best Practices

1. **Always use dependency injection** - Register NetworkCaller in your DI container
2. **Handle errors properly** - Use Either pattern to handle both success and failure cases
3. **Provide deserializers** - Always provide response deserializers for type safety
4. **Use custom failures** - Create domain-specific failure types for better error handling
5. **Test your repositories** - Mock NetworkCaller in unit tests
6. **Add logging** - Use Dio interceptors for request/response logging in debug mode

## Testing

### Mock NetworkCaller for Tests

```dart
class MockNetworkCaller implements NetworkCaller {
  @override
  Future<Either<Failure, NetworkResponse<T>>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) async {
    // Return mock success response
    return Right(
      NetworkResponse<T>(
        statusCode: 200,
        data: {'id': 1, 'name': 'Test'} as T,
      ),
    );
  }

  // Implement other methods...
}
```

## File Structure

```
lib/core/network/
├── network_caller.dart           # Abstract NetworkCaller interface
├── dio_network_call_executor.dart # Dio implementation
├── network.dart                  # Barrel file for exports
└── network_caller_example.dart   # Usage examples
```

## Dependencies

- `dio: ^5.4.3+1` - HTTP client
- `dartz: ^0.10.1` - Functional programming (Either type)
- `get_it: ^8.2.0` - Dependency injection
- `connectivity_plus: ^6.1.5` - Network connectivity checking
- `equatable: ^2.0.5` - Value equality

## Migration from Other Network Solutions

If you're migrating from other network packages:

1. Replace your HTTP client calls with NetworkCaller methods
2. Implement NetworkErrorConverter for your error types
3. Update repository layer to use Either<Failure, Response> pattern
4. Register dependencies in injection container

## Contributing

Feel free to extend this module with:
- Request caching
- Request retry logic
- Request queuing
- Offline mode support
- Request interceptors
- Response validators

## License

MIT License
