import 'package:e_laundry/core/constants/app_constants.dart';
import 'package:e_laundry/features/splash/domain/entities/splash_page_data.dart';

class MockSplashDataSource {
  Future<SplashPageData> fetchSplashData() async {
    // Delay for 2 seconds to simulate network call
    await Future.delayed(const Duration(seconds: 2));

    return const SplashPageData(
      title: AppConstants.brandName,
      subTitle: AppConstants.brandTagline,
      logoPath: AppConstants.brandLogoPath,
      academicIntegrityText: AppConstants.brandAcademicIntegrityText,
    );
  }
}
