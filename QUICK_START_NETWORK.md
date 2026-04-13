# Quick Start Guide - NetworkCaller

## 🚀 Get Started in 3 Steps

### Step 1: Dependencies are Already Registered ✅

The NetworkCaller is already configured in `injection_container.dart`. Just make sure you initialize it:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize session data
  await SessionData.start();
  
  // Initialize DI (this registers NetworkCaller)
  await initDI(AppConfig.development());
  
  runApp(MyApp());
}
```

### Step 2: Inject NetworkCaller in Your Repository

```dart
import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/network/network_caller.dart';
import 'package:e_laundry/core/error/failures.dart';

class MyRepository {
  final NetworkCaller networkCaller;
  
  // Inject via constructor
  MyRepository({required this.networkCaller});
  
  // GET request example
  Future<Either<Failure, Map<String, dynamic>>> fetchData() async {
    return await networkCaller.get<Map<String, dynamic>>(
      url: 'https://api.example.com/data',
      responseDeserializer: (data) {
        return data as Map<String, dynamic>;
      },
    );
  }
  
  // POST request example
  Future<Either<Failure, Map<String, dynamic>>> submitData(
    Map<String, dynamic> body,
  ) async {
    return await networkCaller.post<Map<String, dynamic>>(
      url: 'https://api.example.com/submit',
      body: body,
      responseDeserializer: (data) {
        return data as Map<String, dynamic>;
      },
    );
  }
}
```

### Step 3: Use in Your Cubit/Bloc

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';

class MyCubit extends Cubit<MyState> {
  final MyRepository repository;
  
  MyCubit({required this.repository}) : super(MyInitial());
  
  Future<void> loadData() async {
    emit(MyLoading());
    
    final result = await repository.fetchData();
    
    // Handle result using Either pattern
    result.fold(
      (failure) {
        // Error case
        emit(MyError(message: failure.message));
      },
      (response) {
        // Success case
        if (response.isSuccess) {
          emit(MySuccess(data: response.data!));
        } else {
          emit(MyError(message: 'Request failed'));
        }
      },
    );
  }
}
```

## 📋 Common Patterns

### Pattern 1: With Custom Model

```dart
class UserRepository {
  final NetworkCaller networkCaller;
  
  UserRepository({required this.networkCaller});
  
  Future<Either<Failure, User>> getUser(String userId) async {
    final result = await networkCaller.get<User>(
      url: '/users/$userId',
      headers: {'Authorization': 'Bearer token'},
      responseDeserializer: (data) {
        if (data is Map<String, dynamic>) {
          return User.fromJson(data);
        }
        throw Exception('Invalid response');
      },
    );
    
    return result;
  }
}
```

### Pattern 2: With Query Parameters

```dart
Future<Either<Failure, List<Item>>> getItems({
  int page = 1,
  int limit = 20,
}) async {
  return await networkCaller.get<List<Item>>(
    url: '/items',
    queryParameters: {
      'page': page,
      'limit': limit,
      'sort': 'created_at',
    },
    responseDeserializer: (data) {
      if (data is List) {
        return data.map((item) => Item.fromJson(item)).toList();
      }
      return [];
    },
  );
}
```

### Pattern 3: Error Handling in UI

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        if (state is MyLoading) {
          return CircularProgressIndicator();
        } else if (state is MyError) {
          return Text('Error: ${state.message}');
        } else if (state is MySuccess) {
          return Text('Success: ${state.data}');
        }
        return Container();
      },
    );
  }
}
```

## 🎯 Key Points

1. **NetworkCaller returns `Either<Failure, NetworkResponse<T>>`**
   - Left = Failure (error)
   - Right = Success (response)

2. **Always provide a `responseDeserializer`**
   - Converts raw JSON to your type
   - Ensures type safety

3. **Use `fold()` to handle results**
   - First callback: error case
   - Second callback: success case

4. **Check `response.isSuccess`**
   - Verifies HTTP status code (200-299)

## 📦 What You Get

✅ Type-safe HTTP requests  
✅ Automatic error handling  
✅ Connectivity checking  
✅ JSON serialization  
✅ Clean architecture compliance  
✅ Easy testing with mocks  

## 🔍 Testing

```dart
// Mock NetworkCaller for tests
class MockNetworkCaller implements NetworkCaller {
  @override
  Future<Either<Failure, NetworkResponse<T>>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) async {
    return Right(
      NetworkResponse<T>(
        statusCode: 200,
        data: {'id': 1} as T,
      ),
    );
  }
  // ... implement other methods
}

// Use in tests
final mockCaller = MockNetworkCaller();
final repository = MyRepository(networkCaller: mockCaller);
```

## 📚 More Examples

See `lib/core/network/network_caller_example.dart` for detailed examples including:
- Advanced error handling
- Request retry logic
- Response validation
- Custom headers management

## 🆘 Troubleshooting

**Problem**: Getting type errors  
**Solution**: Make sure to provide `responseDeserializer` for all requests

**Problem**: Network not working  
**Solution**: Check `SessionData.start()` is called before network calls

**Problem**: Can't inject NetworkCaller  
**Solution**: Ensure `initDI()` is called in main()

## 🎉 You're Ready!

The NetworkCaller is now set up and ready to use. Start making type-safe, error-handled network requests in your app!
