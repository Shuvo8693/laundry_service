import 'package:e_laundry/features/onboarding/domain/entities/onboarding_page_entity.dart';

class MockOnboardingDataSource {
  Future<List<OnboardingPageEntity>> fetchOnboardingPages() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const OnboardingPageEntity(
        title: 'Hassle-Free Laundry\nat Your Doorstep',
        subtitle:
            'Book your laundry service in seconds and enjoy pickup and delivery without leaving your home',
        iconPath: 'assets/icons/laundry_service.svg',
        illustrationBackgroundColor: '#E8F7F7',
      ),
      const OnboardingPageEntity(
        title: 'Track Your Laundry\nin Real-Time',
        subtitle:
            'Stay updated at every step — from pickup to cleaning and final delivery.',
        iconPath: 'assets/icons/track_changes.svg',
        illustrationBackgroundColor: '#DFF4F4',
      ),
      const OnboardingPageEntity(
        title: 'Clean Clothes,\nDelivered to You',
        subtitle:
            'Get fresh, clean clothes delivered to your door with easy, secure payment.',
        iconPath: 'assets/icons/delivery.svg',
        illustrationBackgroundColor: '#E8F7F7',
      ),
    ];
  }
}
