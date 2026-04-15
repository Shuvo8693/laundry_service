import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:e_laundry/core/config/app_config.dart';
import 'package:e_laundry/core/localization/cubit/language_cubit.dart';
import 'package:e_laundry/core/localization/cubit/language_state.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_theme.dart';
import 'package:e_laundry/core/routes/app_router.dart';
import 'package:e_laundry/injection_container.dart';
import 'package:e_laundry/l10n/app_localizations.dart';

Future<void> setupApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI(config);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<LanguageCubit>(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          ScreenUtil.init(context);
          return MaterialApp.router(
            title: 'Medi Dreamers',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            supportedLocales: const [
              Locale('en'), // English
              Locale('bn'), // Bengali
              Locale('ar'), // Arabic
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                surface: AppColors.surface,
              ),
              textTheme: AppTextTheme.textTheme,
              useMaterial3: true,
            ),
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
