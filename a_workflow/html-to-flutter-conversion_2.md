# 🚀 Agent CLI Feature Development Workflow
> **Project:** `e_laundry` | **Architecture:** Clean Architecture | **State Management:** Cubit | **VM:** FVM

---

## 📋 Table of Contents

1. [Prerequisites & FVM Setup](#prerequisites--fvm-setup)
2. [Project Folder Structure](#project-folder-structure)
3. [Step-by-Step Feature Development Workflow](#step-by-step-feature-development-workflow)
   - [Step 1 — Create Feature Skeleton](#step-1--create-feature-skeleton)
   - [Step 2 — Domain Layer](#step-2--domain-layer)
   - [Step 3 — Data Layer (Mock Local Data)](#step-3--data-layer-mock-local-data)
   - [Step 4 — Cubit (State Management)](#step-4--cubit-state-management)
   - [Step 5 — UI — Screens & Widgets](#step-5--ui--screens--widgets)
   - [Step 6 — Register Dependencies](#step-6--register-dependencies)
   - [Step 7 — Register Route](#step-7--register-route)
4. [Core Reusable Components Reference](#core-reusable-components-reference)
5. [UI Pixel-Perfect Rules](#ui-pixel-perfect-rules)
6. [Naming Conventions](#naming-conventions)
7. [Checklist Before PR](#checklist-before-pr)

---

## FVM — Always Use `fvm` Prefix

> ⚠️ FVM is already installed. **Every** flutter/dart command in this project must be prefixed with `fvm`.

```bash
# ✅ Always use fvm prefix:
fvm flutter pub get
fvm flutter run --flavor development --target lib/main_development.dart
fvm flutter run --flavor production  --target lib/main_production.dart
fvm flutter test
fvm flutter analyze
fvm flutter build apk --flavor production --target lib/main_production.dart

# ❌ Never run bare flutter commands:
flutter pub get    # wrong
flutter run        # wrong
```

---

## Clean Architecture Folder Structure

> Three layers per feature: **Data → Domain → Presentation**.  
> `core/widgets/` = shared reusable components.  
> `presentation/widgets/` = feature-specific UI pieces.

```
lib/
│
├── injection_container.dart              # GetIt DI root (registers all layers)
│
├── core/                                 # Shared across ALL features
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── entities/                        # ★ Base models & Error handlers
│   │   ├── api_error.dart
│   │   ├── json_serializer.dart
│   │   └── session_data.dart
│   ├── error/
│   │   ├── exceptions.dart              # CacheException, ServerException …
│   │   └── failures.dart                # CacheFailure, ServerFailure …
│   ├── extensions/
│   │   ├── context_extension.dart
│   │   ├── date_time_extension.dart
│   │   └── string_extension.dart
│   ├── localization/                     # ★ Language Management
│   │   └── cubit/
│   │       ├── language_cubit.dart
│   │       └── language_state.dart
│   ├── logger/
│   │   └── app_logger.dart
│   ├── navigation/                       # ★ Global Navigation State
│   │   └── cubit/
│   │       ├── navigation_cubit.dart
│   │       └── navigation_state.dart
│   ├── network/
│   │   ├── dio_network_call_executor.dart
│   │   ├── network_caller.dart
│   │   └── network.dart
│   ├── resources/
│   │   ├── asset_resolver/
│   │   │   └── app_assets.dart          # all asset path constants
│   │   ├── colors/
│   │   │   └── app_colors.dart          # design token palette
│   │   └── text/
│   │       └── app_text_styles.dart     # typography system
│   ├── routes/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── services/
│   │   ├── notification_service.dart
│   │   └── interceptors/
│   │       ├── language_interceptor.dart
│   │       └── network_interceptor.dart
│   ├── utils/
│   │   ├── screen_util.dart             # ★ ScreenUtil init + extension helpers
│   │   ├── date_time_utils.dart
│   │   ├── prayer_helper.dart
│   │   └── validators.dart
│   │
│   └── widgets/                         # ★ GLOBAL REUSABLE UI COMPONENTS ★
│       ├── app_button.dart              # AppButton — all tappable actions
│       ├── custom_app_bar.dart          # CustomAppBar — all screen AppBars
│       ├── custom_progress_indicator.dart
│       ├── custom_text.dart             # CustomText — all text rendering
│       ├── error_placeholder.dart       # ErrorPlaceholder + retry callback
│       ├── language_switcher.dart
│       ├── shimmer_placeholder.dart     # ShimmerPlaceholder — loading states
│       ├── spacing.dart                 # VSpace / HSpace helpers
│       └── widgets.dart                 # barrel export (single import)
│
└── features/
    └── <feature_name>/                  # One folder per business feature
        │
        ├── data/                        # ── LAYER 1: DATA ──────────────────
        │   │
        │   ├── datasources/
        │   │   ├── <feature>_local_data_source.dart   # ★ MOCK DATA lives here
        │   │   └── <feature>_remote_data_source.dart  # future real API
        │   │
        │   ├── models/
        │   │   └── <feature>_model.dart               # extends entity, adds fromJson/toJson
        │   │
        │   └── repositories/
        │       └── <feature>_repository_impl.dart     # implements domain contract
        │
        ├── domain/                      # ── LAYER 2: DOMAIN (pure Dart) ────
        │   │
        │   ├── entities/
        │   │   └── <feature>_entity.dart              # Equatable, no framework deps
        │   │
        │   ├── repositories/
        │   │   └── <feature>_repository.dart          # abstract contract
        │   │
        │   └── usecases/
        │       ├── get_<feature>s.dart               # one file per action
        │       └── <action>_<feature>.dart
        │
        └── presentation/               # ── LAYER 3: PRESENTATION ──────────
            │
            ├── cubit/
            │   ├── <feature>_cubit.dart              # business logic + emit
            │   └── <feature>_state.dart              # sealed state classes
            │
            ├── screens/
            │   └── <feature>_screen.dart             # BlocProvider + Scaffold
            │
            └── widgets/               # ★ FEATURE-SPECIFIC COMPOSED UI ONLY ★
                │                      # ✅ Cards, list tiles, section containers,
                │                      #    row items, dialogs, bottom sheet bodies
                │                      # ❌ NOT colors, shimmer, text styles, spacing
                ├── <feature>_card.dart               # e.g. OrderCard, ServiceCard
                ├── <feature>_list_item.dart          # e.g. OrderListItem, ServiceRow
                └── <feature>_section.dart            # e.g. OrderSummarySection
```

### Layer Dependency Rule

```
presentation  →  domain  ←  data
     ↓               ↑
  core/widgets    core/error
```

| Layer | Allowed imports | Forbidden imports |
|-------|----------------|-------------------|
| `domain/` | `core/error`, `dartz`, `equatable` | `data/`, `presentation/`, Flutter SDK |
| `data/` | `domain/`, `core/error`, models | `presentation/` |
| `presentation/` | `domain/entities`, `domain/usecases`, `core/widgets`, `core/resources` | `data/` directly |
| `core/widgets/` | Flutter SDK, `core/resources` | `features/` |

---

## Step-by-Step Feature Development Workflow

> **Replace `<feature>` with your actual feature name in snake_case** (e.g., `laundry_order`, `user_profile`).

---

### Step 1 — Create Feature Skeleton

Run these commands to create all required directories at once:

```bash
# From project root
$feature = "laundry_order"   # <-- change this

New-Item -ItemType Directory -Force -Path @(
  "lib/features/$feature/data/datasources",
  "lib/features/$feature/data/models",
  "lib/features/$feature/data/repositories",
  "lib/features/$feature/domain/entities",
  "lib/features/$feature/domain/repositories",
  "lib/features/$feature/domain/usecases",
  "lib/features/$feature/presentation/cubit",
  "lib/features/$feature/presentation/screens",
  "lib/features/$feature/presentation/widgets",
  "test/features/$feature/data",
  "test/features/$feature/domain/usecases",
  "test/features/$feature/presentation/cubit"
)
```

---

### Step 2 — Domain Layer

#### 2a. Entity
`lib/features/<feature>/domain/entities/<feature>_entity.dart`
```dart
import 'package:equatable/equatable.dart';

class LaundryOrderEntity extends Equatable {
  final String id;
  final String serviceName;
  final double price;
  final String status;
  final DateTime createdAt;

  const LaundryOrderEntity({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, serviceName, price, status, createdAt];
}
```

#### 2b. Repository (Abstract)
`lib/features/<feature>/domain/repositories/<feature>_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/<feature>_entity.dart';

abstract class LaundryOrderRepository {
  Future<Either<Failure, List<LaundryOrderEntity>>> getOrders();
  Future<Either<Failure, LaundryOrderEntity>> getOrderById(String id);
}
```

#### 2c. Use Cases
`lib/features/<feature>/domain/usecases/get_<feature>s.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/<feature>_entity.dart';
import '../repositories/<feature>_repository.dart';

class GetLaundryOrders {
  final LaundryOrderRepository repository;

  GetLaundryOrders(this.repository);

  Future<Either<Failure, List<LaundryOrderEntity>>> call() {
    return repository.getOrders();
  }
}
```

---

### Step 3 — Data Layer (Mock Local Data)

#### 3a. Model (extends Entity + fromJson/toJson)
`lib/features/<feature>/data/models/<feature>_model.dart`
```dart
import '../../domain/entities/<feature>_entity.dart';

class LaundryOrderModel extends LaundryOrderEntity {
  const LaundryOrderModel({
    required super.id,
    required super.serviceName,
    required super.price,
    required super.status,
    required super.createdAt,
  });

  factory LaundryOrderModel.fromJson(Map<String, dynamic> json) {
    return LaundryOrderModel(
      id: json['id'] as String,
      serviceName: json['service_name'] as String,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'service_name': serviceName,
    'price': price,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
```

#### 3b. Local Data Source (Mock)
`lib/features/<feature>/data/datasources/<feature>_local_data_source.dart`

> 🔑 **All mock data lives here.** No network calls, no external dependencies.

```dart
import 'package:e_laundry/core/error/exceptions.dart';
import '../models/<feature>_model.dart';

/// Contract
abstract class LaundryOrderLocalDataSource {
  Future<List<LaundryOrderModel>> getOrders();
  Future<LaundryOrderModel> getOrderById(String id);
}

/// Implementation with hardcoded mock data
class LaundryOrderLocalDataSourceImpl implements LaundryOrderLocalDataSource {

  /// ── MOCK DATA ────────────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': 'ORD-001',
      'service_name': 'Wash & Fold',
      'price': 12.99,
      'status': 'Pending',
      'created_at': '2026-04-10T09:00:00.000Z',
    },
    {
      'id': 'ORD-002',
      'service_name': 'Dry Cleaning',
      'price': 24.50,
      'status': 'In Progress',
      'created_at': '2026-04-11T11:30:00.000Z',
    },
    {
      'id': 'ORD-003',
      'service_name': 'Iron Only',
      'price': 8.00,
      'status': 'Completed',
      'created_at': '2026-04-12T08:15:00.000Z',
    },
  ];
  /// ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<LaundryOrderModel>> getOrders() async {
    // Simulate network delay for realistic UX testing
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockOrders
        .map((json) => LaundryOrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<LaundryOrderModel> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final json = _mockOrders.firstWhere(
      (o) => o['id'] == id,
      orElse: () => throw CacheException(message: 'Order $id not found'),
    );
    return LaundryOrderModel.fromJson(json);
  }
}
```

#### 3c. Repository Implementation
`lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../../domain/entities/<feature>_entity.dart';
import '../../domain/repositories/<feature>_repository.dart';
import '../datasources/<feature>_local_data_source.dart';

class LaundryOrderRepositoryImpl implements LaundryOrderRepository {
  final LaundryOrderLocalDataSource localDataSource;

  LaundryOrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<LaundryOrderEntity>>> getOrders() async {
    try {
      final result = await localDataSource.getOrders();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LaundryOrderEntity>> getOrderById(String id) async {
    try {
      final result = await localDataSource.getOrderById(id);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
```

---

### Step 4 — Cubit (State Management)

#### 4a. State
`lib/features/<feature>/presentation/cubit/<feature>_state.dart`
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/<feature>_entity.dart';

// Use sealed classes (Dart 3+) for exhaustive pattern matching
sealed class LaundryOrderState extends Equatable {
  const LaundryOrderState();

  @override
  List<Object?> get props => [];
}

final class LaundryOrderInitial extends LaundryOrderState {
  const LaundryOrderInitial();
}

final class LaundryOrderLoading extends LaundryOrderState {
  const LaundryOrderLoading();
}

final class LaundryOrderLoaded extends LaundryOrderState {
  final List<LaundryOrderEntity> orders;
  const LaundryOrderLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

final class LaundryOrderError extends LaundryOrderState {
  final String message;
  const LaundryOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

#### 4b. Cubit
`lib/features/<feature>/presentation/cubit/<feature>_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_<feature>s.dart';
import '<feature>_state.dart';

class LaundryOrderCubit extends Cubit<LaundryOrderState> {
  final GetLaundryOrders getLaundryOrders;

  LaundryOrderCubit({required this.getLaundryOrders})
      : super(const LaundryOrderInitial());

  Future<void> fetchOrders() async {
    emit(const LaundryOrderLoading());

    final result = await getLaundryOrders();

    result.fold(
      (failure) => emit(LaundryOrderError(message: failure.message)),
      (orders)  => emit(LaundryOrderLoaded(orders: orders)),
    );
  }
}
```

---

### Step 5 — UI — Screens & Widgets

#### What goes where?

| Belongs in `presentation/widgets/` ✅ | Comes from `core/` only ❌ Never in feature widgets |
|---------------------------------------|----------------------------------------------------|
| `OrderCard` — composed card widget | Colors → `AppColors.*` |
| `ServiceListItem` — row/tile widget | Text styles → `AppTextStyles.*` |
| `OrderSummarySection` — section container | Shimmer → `ShimmerPlaceholder` from `core/widgets` |
| `CheckoutBottomSheet` — bottom sheet body | Spacing → `VSpace` / `HSpace` from `core/widgets` |
| `ServiceBadge` — feature-specific badge | Buttons → `AppButton` from `core/widgets` |
| `OrderStatusRow` — composed status row | Loading indicator → `CustomProgressIndicator` |

> 🎯 **Golden Rules for Pixel-Perfect UI:**
> - **NEVER** hardcode colors inline — always use `AppColors.*`
> - **NEVER** hardcode text styles inline — always use `AppTextStyles.*`
> - **NEVER** hardcode spacings — always use `VSpace/HSpace` from `core/widgets/widgets.dart`
> - **ALWAYS** import shimmer, buttons, text, spacing from `core/widgets/widgets.dart`
> - **ALWAYS** handle loading in the **screen** using `ShimmerPlaceholder` from core
> - **ALWAYS** handle errors in the **screen** using `ErrorPlaceholder` from core
> - Feature `widgets/` files **only compose** core widgets + entity data — nothing else

#### 5a. Feature-Specific Widget (Card)
`lib/features/<feature>/presentation/widgets/<feature>_card.dart`
```dart
import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_styles.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import '../../domain/entities/<feature>_entity.dart';

class LaundryOrderCard extends StatelessWidget {
  final LaundryOrderEntity order;
  final VoidCallback? onTap;

  const LaundryOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status indicator dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor(order.status),
              ),
            ),
            const HSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: order.serviceName,
                    style: AppTextStyles.bodyMediumBold,
                  ),
                  const VSpace(4),
                  CustomText(
                    text: order.status,
                    style: AppTextStyles.caption.copyWith(
                      color: _statusColor(order.status),
                    ),
                  ),
                ],
              ),
            ),
            CustomText(
              text: '\$${order.price.toStringAsFixed(2)}',
              style: AppTextStyles.bodyMediumBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'Completed'   => AppColors.success,
      'In Progress' => AppColors.warning,
      'Pending'     => AppColors.info,
      _             => AppColors.textSecondary,
    };
  }
}
```

#### 5b. Feature Section Widget (Section Container Example)
`lib/features/<feature>/presentation/widgets/<feature>_section.dart`

> This is a **composed UI container** — it uses `CustomText`, `AppColors`, `AppTextStyles`,
> `VSpace` from core. It does NOT define its own colors or shimmer.

```dart
import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_styles.dart';
import 'package:e_laundry/core/widgets/widgets.dart';   // CustomText, VSpace, HSpace
import '../../domain/entities/<feature>_entity.dart';

class OrderSummarySection extends StatelessWidget {
  final LaundryOrderEntity order;

  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,          // ← from core/resources
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(                              // ← from core/widgets
            text: 'Order Summary',
            style: AppTextStyles.titleMedium,     // ← from core/resources
          ),
          const VSpace(8),                        // ← from core/widgets
          _SummaryRow(label: 'Service', value: order.serviceName),
          const VSpace(4),
          _SummaryRow(
            label: 'Price',
            value: '\$${order.price.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

// Private helper — stays inside the same file (not a separate widget file)
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: label, style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        )),
        CustomText(text: value, style: AppTextStyles.bodyMediumBold),
      ],
    );
  }
}
```

> ⚠️ **Loading skeleton lives in the Screen, not in feature widgets:**
> The screen handles `LaundryOrderLoading` state by calling `ShimmerPlaceholder` directly
> from `core/widgets` — no shimmer file inside `presentation/widgets/`.

#### 5c. Screen
`lib/features/<feature>/presentation/screens/<feature>_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_styles.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/injection_container.dart';
import '../cubit/<feature>_cubit.dart';
import '../cubit/<feature>_state.dart';
import '../widgets/<feature>_card.dart';
import '../widgets/<feature>_shimmer.dart';

class LaundryOrderScreen extends StatelessWidget {
  const LaundryOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide cubit via GetIt — do NOT create use cases manually in UI
      create: (_) => sl<LaundryOrderCubit>()..fetchOrders(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: CustomAppBar(
          title: 'My Orders',
          // Use AppTextStyles for all text — never inline TextStyle
          titleStyle: AppTextStyles.headlineMedium,
        ),
        body: BlocBuilder<LaundryOrderCubit, LaundryOrderState>(
          builder: (context, state) {
            return switch (state) {
              LaundryOrderInitial()  => const SizedBox.shrink(),
              LaundryOrderLoading()  => const LaundryOrderShimmer(),
              LaundryOrderLoaded()   => _OrderList(orders: state.orders),
              LaundryOrderError()    => ErrorPlaceholder(
                  message: state.message,
                  onRetry: () =>
                      context.read<LaundryOrderCubit>().fetchOrders(),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List orders;

  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: CustomText(
          text: 'No orders yet.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<LaundryOrderCubit>().fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: orders.length,
        itemBuilder: (context, index) => LaundryOrderCard(
          order: orders[index],
          onTap: () {
            // Navigate using go_router route name
            // context.pushNamed(RouteNames.orderDetail, extra: orders[index]);
          },
        ),
      ),
    );
  }
}
```

---

### Step 6 — Register Dependencies

Add to `lib/injection_container.dart` inside the `init()` function, following this **bottom-up** order:

```dart
// ── <FEATURE_NAME> ───────────────────────────────────────────────────────────

// 1. Data Sources (always register first)
sl.registerLazySingleton<LaundryOrderLocalDataSource>(
  () => LaundryOrderLocalDataSourceImpl(),
);

// 2. Repository
sl.registerLazySingleton<LaundryOrderRepository>(
  () => LaundryOrderRepositoryImpl(
    localDataSource: sl<LaundryOrderLocalDataSource>(),
  ),
);

// 3. Use Cases
sl.registerLazySingleton(
  () => GetLaundryOrders(sl<LaundryOrderRepository>()),
);

// 4. Cubit (always Factory — new instance per screen)
sl.registerFactory(
  () => LaundryOrderCubit(
    getLaundryOrders: sl<GetLaundryOrders>(),
  ),
);
```

---

### Step 7 — Register Route

#### 7a. Add Route Name
`lib/core/routes/route_names.dart`
```dart
abstract class RouteNames {
  // ... existing routes ...
  static const String laundryOrders = '/laundry-orders';
  static const String laundryOrderDetail = '/laundry-orders/:id';
}
```

#### 7b. Add GoRoute
`lib/core/routes/app_router.dart`
```dart
GoRoute(
  path: RouteNames.laundryOrders,
  name: 'laundryOrders',
  builder: (context, state) => const LaundryOrderScreen(),
),
```

---

## Core Reusable Components Reference

> 🔴 **MANDATORY**: Every single component below MUST be used in the feature UI where applicable. Never re-implement them.

| `CustomText` | `core/widgets/custom_text.dart` | **All text rendering** in the app using standardized `TextType`. |

```dart
enum TextType {
  displayLarge,
  displayMedium,
  headlineLarge,
  headlineMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelSmall,
}
```

### 🛠 CustomText Standard Pattern

Always use the following pattern for text rendering to ensure theme consistency:

```dart
CustomText(
  text: 'Your Text Here',
  textType: TextType.bodyMedium, // Choose appropriate type from TextType enum
  color: AppColors.onSurface,    // Optional: override color if needed
  textAlign: TextAlign.start,     // Optional: alignment
)
```

**Avoid** using `.copyWith()` on `TextStyle` or the named constructors `CustomText.bodyMedium()` unless strictly necessary for a quick fix. The standard `CustomText()` with `textType` parameter is the preferred way.
| `CustomAppBar` | `core/widgets/custom_app_bar.dart` | All screen `appBar:` properties |
| `ShimmerPlaceholder` | `core/widgets/shimmer_placeholder.dart` | Loading states for lists/cards/images |
| `ErrorPlaceholder` | `core/widgets/error_placeholder.dart` | All error states with retry |
| `CustomProgressIndicator` | `core/widgets/custom_progress_indicator.dart` | Inline/overlay loading spinners |
| `VSpace` | `core/widgets/spacing.dart` | Vertical spacing between widgets |
| `HSpace` | `core/widgets/spacing.dart` | Horizontal spacing between widgets |
| `LanguageSwitcher` | `core/widgets/language_switcher.dart` | Locale toggle in settings/appbar |

### Barrel Import (use this single import)
```dart
import 'package:e_laundry/core/widgets/widgets.dart';
```

---

## UI Pixel-Perfect Rules

### 1. Color System — `AppColors`
```dart
// lib/core/resources/colors/app_colors.dart
// ✅ Always use:
AppColors.primary          // brand primary
AppColors.secondary        // brand secondary
AppColors.scaffoldBackground
AppColors.cardBackground
AppColors.textPrimary
AppColors.textSecondary
AppColors.success
AppColors.warning
AppColors.error
AppColors.info
AppColors.shadow
AppColors.divider

// ❌ Never:
Color(0xFF123456)          // hardcoded hex in UI files
Colors.blue                // Flutter Material colors
```

### 2. Typography System — `AppTextStyles`
```dart
// lib/core/resources/text/app_text_styles.dart
// ✅ Always use:
AppTextStyles.displayLarge
AppTextStyles.displayMedium
AppTextStyles.headlineLarge
AppTextStyles.headlineMedium
AppTextStyles.headlineSmall
AppTextStyles.titleLarge
AppTextStyles.titleMedium
AppTextStyles.bodyLarge
AppTextStyles.bodyMedium
AppTextStyles.bodyMediumBold
AppTextStyles.bodySmall
AppTextStyles.caption
AppTextStyles.overline
AppTextStyles.buttonLabel

// ✅ Acceptable override for one-off tweaks:
AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)

// ❌ Never:
TextStyle(fontSize: 14, fontWeight: FontWeight.bold) // inline styles
```

### 3. Asset Paths — `AppAssets`
```dart
// lib/core/resources/asset_resolver/app_assets.dart
// ✅ Always use named constants:
AppAssets.logoSvg
AppAssets.placeholderImage
AppAssets.iconWash

// ❌ Never:
'assets/app_image/logo.png' // hardcoded strings in UI
```

### 4. Spacing Scale
```dart
// From lib/core/widgets/spacing.dart
// Use consistent multiples of 4
const VSpace(4);    // 4dp
const VSpace(8);    // 8dp
const VSpace(12);   // 12dp
const VSpace(16);   // 16dp
const VSpace(24);   // 24dp
const VSpace(32);   // 32dp

// For EdgeInsets, stick to:
EdgeInsets.all(16)
EdgeInsets.symmetric(horizontal: 16, vertical: 8)
EdgeInsets.only(bottom: 24)
```

### 5. Border Radius Scale
```dart
// ✅ Use consistent border radius values
BorderRadius.circular(4)   // chips, tags
BorderRadius.circular(8)   // input fields
BorderRadius.circular(12)  // cards
BorderRadius.circular(16)  // bottom sheets, modals
BorderRadius.circular(24)  // buttons (pill)
BorderRadius.circular(50)  // avatars (circle via ClipRRect)
```

### 6. ScreenUtil — Pixel-Perfect Responsive Sizing ★

> `flutter_screenutil` is the **mandatory** sizing tool for all dimensions, font sizes,
> and radius values. It adapts the UI to match the design file's reference resolution on every device.

#### 6a. pubspec.yaml
```yaml
dependencies:
  flutter_screenutil: ^5.9.3
```

#### 6b. core/utils/screen_util.dart
```dart
// lib/core/utils/screen_util.dart
// Central place for ScreenUtil design reference dimensions.
// Keep in sync with your Figma/design file canvas size.

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScreenUtil {
  // Design reference size (match your Figma artboard)
  static const double designWidth  = 375;   // iPhone 14 width (pt)
  static const double designHeight = 812;   // iPhone 14 height (pt)

  // Call once inside MaterialApp builder
  static Future<void> init() async {
    await ScreenUtil.ensureScreenSize();
  }
}
```

#### 6c. main.dart — Initialize ScreenUtil
```dart
// Wrap MaterialApp with ScreenUtilInit
ScreenUtilInit(
  designSize: const Size(
    AppScreenUtil.designWidth,
    AppScreenUtil.designHeight,
  ),
  minTextAdapt: true,          // scales text automatically
  splitScreenMode: true,       // supports split screen
  builder: (context, child) => MaterialApp.router(
    routerConfig: appRouter,
    // ...
  ),
);
```

#### 6d. Usage in UI — Extension Suffixes
```dart
// ✅ Always use ScreenUtil extensions for all dimensions:

// Width  → .w
100.w          // 100 logical pixels wide (scaled to screen)

// Height → .h
50.h           // 50 logical pixels high (scaled to screen)

// Font size → .sp  (scales with both screen size and text scale factor)
16.sp          // 16sp font size

// Radius → .r  (proportional radius)
12.r           // 12dp radius

// Screen fractions
0.5.sw         // 50% of screen width
0.3.sh         // 30% of screen height

// ❌ NEVER use raw double values for sizes in UI widgets:
width: 100          // wrong — not responsive
fontSize: 16        // wrong — not adaptive
BorderRadius.circular(12)  // wrong — use 12.r instead
```

#### 6e. Practical Examples
```dart
// Container
Container(
  width: 160.w,
  height: 80.h,
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),   // ← .r not raw
    color: AppColors.cardBackground,
  ),
)

// Text (via CustomText — AppTextStyles must use .sp)
// In app_text_styles.dart:
static TextStyle get bodyMedium => TextStyle(
  fontSize: 14.sp,                               // ← .sp
  fontWeight: FontWeight.w400,
  color: AppColors.textPrimary,
);

// SizedBox spacing (preferred over VSpace when exact size matters)
SizedBox(height: 24.h)   // or: const VSpace(24) if non-responsive
SizedBox(width: 16.w)

// Image
Image.asset(
  AppAssets.placeholderImage,
  width: 80.w,
  height: 80.w,    // equal → square
)
```

#### 6f. Rule Summary
| Value type | Extension | Example |
|------------|-----------|--------|
| Width | `.w` | `160.w` |
| Height | `.h` | `48.h` |
| Font size | `.sp` | `14.sp` |
| Border radius | `.r` | `12.r` |
| Screen % width | `.sw` | `0.5.sw` |
| Screen % height | `.sh` | `0.4.sh` |

### 7. Animation Standards
```dart
// Loading transitions
const Duration loadingDuration = Duration(milliseconds: 300);

// Page transitions — use CustomTransitionPage in GoRouter
// Slide, Fade, or Scale — never use default platform transition

// AnimatedSwitcher for state changes
AnimatedSwitcher(
  duration: const Duration(milliseconds: 250),
  child: state is LaundryOrderLoaded
      ? _OrderList(key: const ValueKey('list'), orders: state.orders)
      : const LaundryOrderShimmer(key: ValueKey('shimmer')),
);
```

---

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Feature directory | `snake_case` | `laundry_order/` |
| Dart files | `snake_case.dart` | `laundry_order_cubit.dart` |
| Classes | `PascalCase` | `LaundryOrderCubit` |
| Variables/methods | `camelCase` | `fetchOrders()` |
| Constants | `camelCase` | `AppColors.primary` |
| Route names | `camelCase` const string | `'laundryOrders'` |
| Test files | mirror source + `_test` | `laundry_order_cubit_test.dart` |
| Mock data methods | prefix with `mock` | `mockOrders`, `mockOrderById` |

### Git Branch Naming
```
feature/<feature-name>        → feature/laundry-order
fix/<issue-description>       → fix/order-status-color
chore/<task>                  → chore/update-dependencies
refactor/<component>          → refactor/order-card-widget
```

---

## Checklist Before PR

### 🏗️ Architecture
- [ ] Entity created in `domain/entities/`
- [ ] Repository abstract interface in `domain/repositories/`
- [ ] At least one use case per action in `domain/usecases/`
- [ ] Model extends entity with `fromJson`/`toJson` in `data/models/`
- [ ] Local data source with **all mock data** in `data/datasources/`
- [ ] Repository implementation handles `Either<Failure, T>` correctly
- [ ] No business logic leaking into Cubit or UI layer

### 🧠 State Management
- [ ] Sealed state classes with `Equatable`
- [ ] Cubit registered as **Factory** (not Singleton) in `injection_container.dart`
- [ ] All states handled in `BlocBuilder` switch statement (exhaustive)
- [ ] Cubit initialized in `BlocProvider.create` with `..fetchOrders()`

### 🎨 UI & Widgets
- [ ] **All text** uses `CustomText` with `AppTextStyles.*`
- [ ] **All colors** use `AppColors.*` — zero inline `Color(...)` or `Colors.*`
- [ ] **All spacing** uses `VSpace`/`HSpace` or `EdgeInsets` with standard values
- [ ] **All images** use paths from `AppAssets.*`
- [ ] **AppButton** used for all tappable actions
- [ ] **CustomAppBar** used for all screen app bars
- [ ] **ShimmerPlaceholder** used during `LaundryOrderLoading` state
- [ ] **ErrorPlaceholder** used during `LaundryOrderError` state with retry callback
- [ ] Single barrel import `package:e_laundry/core/widgets/widgets.dart`
- [ ] No `Text(...)` widgets — only `CustomText(...)`
- [ ] No `ElevatedButton`/`TextButton` — only `AppButton`
- [ ] Screen scaffold wrapped in `BlocProvider` providing cubit via `sl<>()`

### 📐 ScreenUtil (Pixel-Perfect)
- [ ] `ScreenUtilInit` wraps `MaterialApp` in `main.dart` with correct design size
- [ ] `AppScreenUtil.designWidth` / `designHeight` match Figma canvas
- [ ] All widths use `.w` extension (e.g. `160.w`)
- [ ] All heights use `.h` extension (e.g. `48.h`)
- [ ] All font sizes in `AppTextStyles` use `.sp` (e.g. `14.sp`)
- [ ] All border radii use `.r` (e.g. `12.r`)
- [ ] Zero raw `double` literals for dimensions in UI files
- [ ] `flutter_screenutil` added to `pubspec.yaml` dependencies

### 🔌 Dependency Injection
- [ ] Data source → Repository → Use Cases → Cubit registered in correct order
- [ ] All `registerLazySingleton` for non-UI layers
- [ ] Cubit always `registerFactory`
- [ ] Feature DI block added to `injection_container.dart` with comment header

### 🗺️ Routing
- [ ] Route name constant added to `route_names.dart`
- [ ] `GoRoute` entry added to `app_router.dart`
- [ ] Navigate using `context.pushNamed(RouteNames.xxx)` — never `Navigator.push`

### ✅ Code Quality
- [ ] No `print()` statements — use `AppLogger.log()`
- [ ] `fvm flutter analyze` runs with zero warnings
- [ ] `fvm flutter test` passes all unit tests
- [ ] All mock data is realistic and closely resembles real API shape

---

> **📌 Tip for Agent CLI:** Always process the checklist top-to-bottom. Generate each layer in the order: **Domain → Data → Cubit → UI → DI → Route**. This ensures compilation never fails mid-development due to missing dependencies.
