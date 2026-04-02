// lib/app/themes/light_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

final ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,

  // ==================== COLOR SCHEME ====================
  colorScheme: const ColorScheme.light(
    primary: AppTheme.primaryColor,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE2E8F0), // Slate-200
    secondary: AppTheme.accentColor,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: AppTheme.textPrimary,
    error: AppTheme.errorColor,
    onError: Colors.white,
  ),

  primaryColor: AppTheme.primaryColor,
  scaffoldBackgroundColor: AppTheme.lightBackground,
  cardColor: Colors.white,

  // ==================== TEXT THEME ====================
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppTheme.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppTheme.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppTheme.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppTheme.textSecondary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppTheme.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppTheme.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AppTheme.textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  // ==================== DIVIDER ====================
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE2E8F0), // Slate-200
    thickness: 1,
    space: 1,
  ),

  // ==================== APP BAR (Bleu foncé comme dans ton design) ====================
  appBarTheme: const AppBarTheme(
    backgroundColor: AppTheme.primaryColor,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 2,
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  ),

  // ==================== FAB (Bleu foncé comme dans ton design) ====================
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    elevation: 6,
    shape: CircleBorder(),
  ),

  // ==================== INPUT (Champs de formulaire arrondis) ====================
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Slate-200
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Slate-200
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: AppTheme.textLight),
    labelStyle: const TextStyle(color: AppTheme.textSecondary),
    prefixIconColor: AppTheme.textSecondary,
    suffixIconColor: AppTheme.textSecondary,
  ),

  // ==================== ELEVATED BUTTON (Bleu foncé, arrondi) ====================
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),

  // ==================== OUTLINED BUTTON ====================
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppTheme.primaryColor,
      side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),

  // ==================== TEXT BUTTON ====================
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // ==================== CARD (Arrondi avec ombre légère) ====================
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.08),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
  ),

  // ==================== CHIP (Filtres arrondis comme dans ton design) ====================
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFF1F5F9), // Slate-100
    selectedColor: AppTheme.primaryColor,
    disabledColor: const Color(0xFFF1F5F9), // Slate-100
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppTheme.textPrimary,
    ),
    secondaryLabelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),

  // ==================== BOTTOM NAVIGATION BAR ====================
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppTheme.primaryColor,
    unselectedItemColor: AppTheme.bottomNavInactive,
    elevation: 12,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    showUnselectedLabels: true,
  ),

  // ==================== TAB BAR (Filtres comme dans ton design) ====================
  tabBarTheme: TabBarThemeData(
    labelColor: AppTheme.primaryColor,
    unselectedLabelColor: AppTheme.textSecondary,
    indicatorColor: AppTheme.primaryColor,
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: const Color(0xFFE8ECF0),
  ),

  // ==================== DIALOG ====================
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimary,
    ),
  ),

  // ==================== BOTTOM SHEET ====================
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),

  // ==================== SNACKBAR ====================
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  ),

  // ==================== LIST TILE ====================
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    horizontalTitleGap: 12,
    iconColor: AppTheme.primaryColor,
  ),

  // ==================== ICON ====================
  iconTheme: const IconThemeData(
    color: AppTheme.textSecondary,
    size: 24,
  ),

  // ==================== PROGRESS INDICATOR ====================
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppTheme.primaryColor,
    linearTrackColor: Color(0xFFE8ECF0),
  ),

  // ==================== SWITCH ====================
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTheme.primaryColor;
      }
      return Colors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTheme.primaryColor.withOpacity(0.3);
      }
      return Colors.grey.withOpacity(0.3);
    }),
  ),

  // ==================== CHECKBOX ====================
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTheme.primaryColor;
      }
      return Colors.transparent;
    }),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
);