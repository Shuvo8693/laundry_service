import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/app_button.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_state.dart';
import 'package:e_laundry/features/onboarding/domain/entities/onboarding_page_entity.dart';

// ─── Onboarding Screen ───────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Load onboarding data
    context.read<OnboardingCubit>().loadOnboardingPages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _onNext() {
    final cubit = context.read<OnboardingCubit>();
    final state = cubit.state;

    if (state is OnboardingLoaded) {
      if (_currentPage < state.pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _onGetStarted();
      }
    }
  }

  void _onGetStarted() {
    context.read<OnboardingCubit>().navigateToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingNavigateToLogin) {
              context.go(RouteNames.login);
            }
          },
          builder: (context, state) {
            if (state is OnboardingLoading || state is OnboardingInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            if (state is OnboardingError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText.bodyLarge(
                      'Failed to load onboarding pages',
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.medium(),
                    AppButton.primary(
                      text: 'Retry',
                      onPressed: () {
                        context.read<OnboardingCubit>().loadOnboardingPages();
                      },
                      width: 200,
                    ),
                  ],
                ),
              );
            }

            if (state is OnboardingLoaded) {
              return Column(
                children: [
                  // ── App Bar ──────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText.headlineMedium(
                          'Click',
                          color: AppColors.primary,
                        ),
                        const CustomText.headlineMedium('& Clean'),
                      ],
                    ),
                  ),

                  // ── Page View ────────────────────────────────────────────────
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: state.pages.length,
                      itemBuilder: (context, index) {
                        return _OnboardingPageView(
                          page: state.pages[index],
                          fadeAnimation: _fadeAnimation,
                          isActive: index == _currentPage,
                        );
                      },
                    ),
                  ),

                  // ── Dots Indicator ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        state.pages.length,
                        (i) => _DotIndicator(isActive: i == _currentPage),
                      ),
                    ),
                  ),

                  // ── Next Button ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: AppButton.primary(
                      text: _currentPage == state.pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _onNext,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ─── Single Page Content ───────────────────────────────────────────────────────
class _OnboardingPageView extends StatelessWidget {
  final OnboardingPageEntity page;
  final Animation<double> fadeAnimation;
  final bool isActive;

  const _OnboardingPageView({
    required this.page,
    required this.fadeAnimation,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // ── Illustration Placeholder ──────────────────────────────────────────
          Expanded(
            flex: 5,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _parseColor(page.illustrationBackgroundColor),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_laundry_service_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const VerticalSpace.small(),
                    const CustomText.bodySmall(
                      '[ Illustration ]',
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const VerticalSpace.small(),

          // ── Text Content ─────────────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Column(
                children: [
                  CustomText.headlineLarge(
                    page.title,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpace.medium(),
                  CustomText.bodyMedium(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

// ─── Dot Indicator ─────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
