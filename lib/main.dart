import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:playground_1/common_libs.dart';
import 'package:playground_1/logic/app_logic.dart';
import 'package:playground_1/logic/data/wonder_data/timeline_logic.dart';
import 'package:playground_1/logic/locale_logic.dart';
import 'package:playground_1/logic/settings_logic.dart';
import 'package:playground_1/logic/wonder_logic.dart';
import 'package:playground_1/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash screen up until app is finished bootstrapping
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  registerSingletons();
  runApp(MyApp());
  await appLogic.bootstrap();
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget with GetItMixin {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locale = watchX((SettingsLogic s) => s.currentLocale);
    return MaterialApp.router(
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      locale: locale == null ? null : Locale(locale),
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.routerDelegate,
      theme: ThemeData(
          fontFamily: $styles.text.body.fontFamily, useMaterial3: true),
      color: $styles.colors.black,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

void registerSingletons() {
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  GetIt.I.registerLazySingleton<WondersLogic>(() => WondersLogic());
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
  GetIt.I.registerLazySingleton<TimelineLogic>(() => TimelineLogic());
}

AppLogic get appLogic => GetIt.I.get<AppLogic>();
WondersLogic get wondersLogic => GetIt.I.get<WondersLogic>();
LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
TimelineLogic get timelineLogic => GetIt.I.get<TimelineLogic>();

AppLocalizations get $strings => localeLogic.strings;
AppStyle get $styles => WondersAppScaffold.style;


// SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();


