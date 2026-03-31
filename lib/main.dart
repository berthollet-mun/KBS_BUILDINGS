// lib/main.dart

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/theme_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  // ✅ Ajoute cet import

import 'app/initialization.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/themes/app_theme.dart';


void main() async {
  // 1. Initialiser Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialiser toutes les dépendances
  await AppInitialization.initialize();

  // 3. Lancer l'application
  runApp(const ImmoApp());
}

class ImmoApp extends StatelessWidget {
  const ImmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'IMMO - KBS Building',
        debugShowCheckedModeBanner: false,

        // Thèmes
        themeMode: themeController.currentTheme.value,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        // Routes
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,

        // Localisation FR
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('fr', 'CD'),
        ],
        locale: const Locale('fr', 'FR'),

        // Transitions
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),

        // Logs
        enableLog: true,
        logWriterCallback: (text, {bool isError = false}) {
          if (isError) {
            print('🔴 IMMO ERROR: $text');
          }
          // Ne pas logger les infos en production
        },
      ),
    );
  }
}