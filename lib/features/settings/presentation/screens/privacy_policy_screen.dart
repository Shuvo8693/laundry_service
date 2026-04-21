import 'package:e_laundry/core/resources/asset_resolver/image_resource_resolver.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Privacy Policy', showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Banner Illustration
            Container(
              width: double.infinity,
              height: 172.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: ImageResourceResolver.privacyPolicyBanner.getImageWidget(
                  boxFit: BoxFit.contain,
                ),
              ),
            ),
            const VerticalSpace(24),

            // Content
            const CustomText.bodyMedium(
              'Lorem ipsum dolor sit amet consectetur. Ultrices id feugiat venenatis habitant mattis viverra elementum purus volutpat. Lacus eu molestie pulvinar rhoncus integer proin elementum. Pretium sit fringilla massa tristique aenean commodo leo. Aliquet viverra amet sit porta elementum et pellentesque posuere. Ullamcorper viverra tortor lobortis viverra auctor egestas. Nulla condimentum ac metus quam turpis gravida ut velit. Porta justo lacus consequat sed platea. Ut dui massa quam elit faucibus consectetur sapien aenean auctor. Felis ipsum amet justo in. Netus amet in egestas sed auctor lorem. Justo ullamcorper velit habitasse lorem eu arcu. Non enim a elit urna eget nibh quisque donec condimentum. Elit ut pellentesque neque in quis at viverra. Nisl etiam tristique odio eget convallis.',
              color: Color(0xFF545455),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
