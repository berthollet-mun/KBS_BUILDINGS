// lib/app/themes/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  // ==================== COLOR SCHEME ====================
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF60A5FA), // Blue-400
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1E3A8A), // Blue-900
    secondary: Color(0xFF3B82F6), // Blue-500
    onSecondary: Colors.white,
    surface: Color(0xFF1E293B), // Slate-800
    onSurface: Color(0xFFF1F5F9), // Slate-100
    error: Color(0xFFEF4444), // Red-500
    onError: Colors.white,
  ),

  primaryColor: const Color(0xFF60A5FA),
  scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate-900
  cardColor: const Color(0xFF1E293B), // Slate-800

  // ==================== TEXT THEME ====================
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFFE0E6ED),
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFFE0E6ED),
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE0E6ED),
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE0E6ED),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFE0E6ED),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF8899AA),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFFCCD6E0),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFFCCD6E0),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: Color(0xFF8899AA),
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  // ==================== DIVIDER ====================
  dividerTheme: const DividerThemeData(
    color: Color(0xFF2A3A4A),
    thickness: 1,
    space: 1,
  ),

  // ==================== APP BAR ====================
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E2A3A),
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

  // ==================== FAB ====================
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF5B9BD5),
    foregroundColor: Colors.white,
    elevation: 6,
    shape: CircleBorder(),
  ),

  // ==================== INPUT ====================
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2A3A4A)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2A3A4A)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF5B9BD5), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
    ),
    filled: true,
    fillColor: const Color(0xFF253545),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: Color(0xFF5A6A7A)),
    labelStyle: const TextStyle(color: Color(0xFF8899AA)),
    prefixIconColor: const Color(0xFF8899AA),
    suffixIconColor: const Color(0xFF8899AA),
  ),

  // ==================== ELEVATED BUTTON ====================
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5B9BD5),
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: const Color(0xFF5B9BD5).withOpacity(0.3),
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
      foregroundColor: const Color(0xFF5B9BD5),
      side: const BorderSide(color: Color(0xFF5B9BD5), width: 1.5),
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
      foregroundColor: const Color(0xFF5B9BD5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // ==================== CARD ====================
  cardTheme: CardThemeData(
    color: const Color(0xFF1E2A3A),
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
  ),

  // ==================== CHIP ====================
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF253545),
    selectedColor: const Color(0xFF5B9BD5),
    disabledColor: const Color(0xFF253545),
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFFCCD6E0),
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
    backgroundColor: Color(0xFF1E2A3A),
    selectedItemColor: Color(0xFF5B9BD5),
    unselectedItemColor: Color(0xFF5A6A7A),
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

  // ==================== TAB BAR ====================
  tabBarTheme: TabBarThemeData(
    labelColor: const Color(0xFF5B9BD5),
    unselectedLabelColor: const Color(0xFF8899AA),
    indicatorColor: const Color(0xFF5B9BD5),
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: const Color(0xFF2A3A4A),
  ),

  // ==================== DIALOG ====================
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1E2A3A),
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE0E6ED),
    ),
  ),

  // ==================== BOTTOM SHEET ====================
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1E2A3A),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),

  // ==================== SNACKBAR ====================
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF253545),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  ),

  // ==================== LIST TILE ====================
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    horizontalTitleGap: 12,
    iconColor: Color(0xFF5B9BD5),
    textColor: Color(0xFFCCD6E0),
  ),

  // ==================== ICON ====================
  iconTheme: const IconThemeData(
    color: Color(0xFF8899AA),
    size: 24,
  ),

  // ==================== PROGRESS INDICATOR ====================
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF5B9BD5),
    linearTrackColor: Color(0xFF2A3A4A),
  ),

  // ==================== SWITCH ====================
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF5B9BD5);
      }
      return const Color(0xFF5A6A7A);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF5B9BD5).withOpacity(0.3);
      }
      return const Color(0xFF2A3A4A);
    }),
  ),

  // ==================== CHECKBOX ====================
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF5B9BD5);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: const BorderSide(color: Color(0xFF5A6A7A)),
  ),
);