---
description: Convert HTML design to pixel-perfect Flutter UI with clean architecture
auto_execution_mode: 2
---

# HTML to Flutter UI Conversion Workflow

This workflow guides the conversion of HTML design files to Flutter UI with pixel-perfect
implementation following clean architecture principles.

## Prerequisites

- HTML design file available in `design_sources/` directory
- Use `fvm flutter` for all Flutter commands (never use `flutter` directly)

## Steps

### 1. Analyze HTML Design

- Read the HTML file carefully
- Extract color palette from Tailwind config
- Note typography (font families, sizes, weights)
- Identify UI components and layout structure
- Document spacing, padding, border radius values
- Note any gradients, shadows, or special effects

### 2. Navigation Best Practices

**CRITICAL: Always use the app's routing system for navigation**

- **NEVER** use `Navigator.push()` or `MaterialPageRoute` directly
- **ALWAYS** use `AppRouter` methods for navigation
- **ALWAYS** define routes in `lib/core/routes/route_names.dart`
- **ALWAYS** register routes in `lib/core/routes/router_config.dart`
- **ALWAYS** provide BlocProviders at the route level, not manually in navigation calls

**Navigation Pattern:**
1. Add route name constant to `RouteNames` class
2. Register route in `router_config.dart` with proper BlocProvider setup
3. Add navigation method to `AppRouter` class
4. Use `AppRouter.navigateToXxx()` in your UI code

**Example:**
```dart
// In route_names.dart
static const String articleDetail = '/article-detail';

// In router_config.dart
GoRoute(
  path: RouteNames.articleDetail,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return BlocProvider(
      create: (context) => di<ArticleDetailCubit>(),
      child: ArticleDetailScreen(
        articleId: extra?['articleId'] as String? ?? '',
      ),
    );
  },
),

// In app_router.dart
static void navigateToArticleDetail({required String articleId}) {
  push(RouteNames.articleDetail, extra: {'articleId': articleId});
}

// In UI code
AppRouter.navigateToArticleDetail(articleId: article.id);
```

### 3. Create Feature Folder Structure

Create the following structure under `lib/features/[feature_name]/`:

```
[feature_name]/
├── data/
│   ├── datasources/
│   │   └── [feature]_local_data_source.dart
│   ├── models/
│   │   └── [model]_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [entity].dart
│   └── repositories/
│       └── [feature]_repository.dart
└── presentation/
    ├── cubit/
    │   ├── [feature]_cubit.dart
    │   └── [feature]_state.dart
    ├── screens/
    │   └── [feature]_screen.dart
    └── widgets/
        └── [component]_widget.dart
```

### 3. Define Domain Layer

**Entities** (`domain/entities/`):

- Create pure Dart classes with Equatable
- No dependencies on external packages
- Represent business objects

**Repository Interface** (`domain/repositories/`):

- Define abstract repository with methods
- Return `Either<Failure, T>` for error handling
- Use dartz package for functional programming

### 4. Implement Data Layer

**Models** (`data/models/`):

- Extend entities
- Add `fromJson` and `toJson` methods
- Handle serialization/deserialization

**Data Source** (`data/datasources/`):

- Create local data source with dummy data
- Add comprehensive logging using `dart:developer`
- Include error simulation for testing
- Document that this will be replaced with remote data source

**Repository Implementation** (`data/repositories/`):

- Implement domain repository interface
- Handle errors and return Either
- Add detailed logging for debugging
- Wrap exceptions in Failure objects

### 5. Create Presentation Layer

**State Management** (`presentation/cubit/`):

- Define all possible states (Initial, Loading, Loaded, Error, etc.)
- Create cubit with dependency injection
- Add comprehensive logging for all state changes
- Handle errors gracefully with user-friendly messages

**Screens** (`presentation/screens/`):

- Create main screen widget
- Use BlocBuilder/BlocConsumer for state management
- Implement loading, error, and success states
- Match HTML design pixel-perfectly

**Widgets** (`presentation/widgets/`):

- Break down UI into reusable components
- Extract colors, spacing, and typography to match HTML
- Use existing `AppColors` and `AppTextTheme` where possible
- Create custom widgets for complex components

### 6. Pixel-Perfect UI Implementation

**Colors**:

- Map HTML Tailwind colors to Flutter `AppColors`
- Use exact hex values from HTML
- Maintain color consistency

**Typography**:

- Match font families (Manrope for headlines, Inter for body)
- Use exact font weights and sizes
- Maintain line heights and letter spacing

**Spacing & Layout**:

- Use exact padding and margin values from HTML
- Maintain border radius values
- Implement responsive layouts with MediaQuery

**Components**:

- Cards: Match rounded corners, shadows, backgrounds
- Buttons: Implement gradients, hover states, transitions
- Input fields: Match styling, focus states
- Icons: Use Material Icons matching HTML

### 7. Error Handling & Logging

- Add try-catch blocks in all async operations
- Log errors with context using `developer.log`
- Display user-friendly error messages
- Implement retry mechanisms where appropriate
- Add loading states for better UX

**Logging Format**:

```dart
developer.log
('🎯 [FeatureName]: Action starting...
'
);developer.log('✅ [FeatureName]: Success message');
developer.log('❌ [FeatureName]: Error message', error: e);
```

### 8. Dependency Injection

- Register repositories in DI container
- Register data sources
- Register cubits with dependencies
- Update main.dart or feature module

### 9. Navigation Integration

- Add navigation method to `NavigationCubit` if needed
- Update `MainScreen` to include new screen in IndexedStack
- Test navigation from home screen

### 10. Testing & Validation

// turbo

- Run `fvm flutter analyze` to check for issues
- Verify pixel-perfect match with HTML design
- Test all user interactions
- Verify error states display correctly
- Check logging output for debugging

## Best Practices

- **Always use `fvm flutter`** instead of `flutter` command
- Use `const` constructors wherever possible
- Follow existing code style and patterns
- Add comprehensive logging for debugging
- Handle all error cases gracefully
- Create dummy data that represents real-world scenarios
- Document complex logic with comments
- Use meaningful variable and function names
- Keep widgets small and focused
- Extract reusable components

## Common Pitfalls to Avoid

- Don't hardcode colors - use AppColors
- Don't skip error handling
- Don't forget logging statements
- Don't create overly complex widgets
- Don't ignore responsive design
- Don't forget to use fvm prefix

## Color Mapping Reference

Map HTML Tailwind colors to Flutter:

- `primary` → `AppColors.primary`
- `surface-container-lowest` → `AppColors.surfaceContainerLowest`
- `on-surface` → `AppColors.onSurface`
- etc.

## Example Dummy Data Source

```dart
class FeatureLocalDataSource {
  Future<List<ModelType>> getData() async {
    developer.log('📡 FeatureLocalDataSource: Fetching dummy data...');
    
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate occasional errors for testing
    if (Random().nextInt(10) == 0) {
      developer.log('❌ FeatureLocalDataSource: Simulated error');
      throw Exception('Simulated network error');
    }
    
    developer.log('✅ FeatureLocalDataSource: Data fetched successfully');
    return _dummyData;
  }
}
```
