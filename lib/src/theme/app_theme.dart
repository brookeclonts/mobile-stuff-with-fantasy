import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';
import 'package:swf_app/src/theme/swf_typography.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final textTheme = SwfTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: SwfColors.color4,
        onPrimary: Colors.white,
        primaryContainer: SwfColors.spicinessPill,
        onPrimaryContainer: SwfColors.color2,
        secondary: SwfColors.color6,
        onSecondary: Colors.white,
        secondaryContainer: SwfColors.color5,
        onSecondaryContainer: SwfColors.color2,
        tertiary: SwfColors.blue,
        onTertiary: Colors.white,
        surface: SwfColors.color8,
        onSurface: SwfColors.gray,
        surfaceContainerHighest: Colors.white,
        onSurfaceVariant: SwfColors.mediumGray,
        error: const Color(0xFFB00020),
        onError: Colors.white,
        outline: SwfColors.lightGray,
        shadow: Colors.black12,
      ),
      scaffoldBackgroundColor: SwfColors.color8,
      appBarTheme: AppBarTheme(
        backgroundColor: SwfColors.color2,
        foregroundColor: SwfColors.color8,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: SwfColors.color8,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SwfColors.color4,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SwfColors.color4,
          side: const BorderSide(color: SwfColors.color4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: SwfColors.color6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SwfColors.spicinessPill,
        labelStyle: textTheme.labelMedium?.copyWith(color: SwfColors.color3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SwfColors.color5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SwfColors.color4, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SwfColors.color5,
        thickness: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: SwfColors.color5,
        indicatorColor: SwfColors.color4,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SwfColors.color2,
        selectedItemColor: SwfColors.color4,
        unselectedItemColor: SwfColors.lightGray,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SwfColors.color2,
        indicatorColor: SwfColors.color3,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: SwfColors.color4);
          }
          return const IconThemeData(color: SwfColors.lightGray);
        }),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme = SwfTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: SwfColors.color4,
        onPrimary: Colors.white,
        primaryContainer: SwfColors.color3,
        onPrimaryContainer: SwfColors.color8,
        secondary: SwfColors.color6,
        onSecondary: Colors.white,
        secondaryContainer: SwfColors.color2,
        onSecondaryContainer: SwfColors.color5,
        tertiary: SwfColors.blueBright,
        onTertiary: SwfColors.darkNavy,
        surface: SwfColors.darkNavy,
        onSurface: SwfColors.color8,
        surfaceContainerHighest: SwfColors.color7,
        onSurfaceVariant: SwfColors.color5,
        error: const Color(0xFFCF6679),
        onError: Colors.white,
        outline: SwfColors.lightGray,
        shadow: Colors.black26,
      ),
      scaffoldBackgroundColor: SwfColors.darkNavy,
      appBarTheme: AppBarTheme(
        backgroundColor: SwfColors.color2,
        foregroundColor: SwfColors.color8,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: SwfColors.color8,
        ),
      ),
      cardTheme: CardThemeData(
        color: SwfColors.color7,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SwfColors.color4,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SwfColors.color4,
          side: const BorderSide(color: SwfColors.color4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: SwfColors.color6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SwfColors.color3,
        labelStyle: textTheme.labelMedium?.copyWith(color: SwfColors.color8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SwfColors.color7,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SwfColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SwfColors.color4, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: SwfColors.color5),
        hintStyle: textTheme.bodyMedium?.copyWith(color: SwfColors.color5),
      ),
      dividerTheme: const DividerThemeData(
        color: SwfColors.lightGray,
        thickness: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: SwfColors.color5,
        indicatorColor: SwfColors.color4,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SwfColors.color2,
        selectedItemColor: SwfColors.color4,
        unselectedItemColor: SwfColors.lightGray,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SwfColors.color2,
        indicatorColor: SwfColors.color3,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: SwfColors.color4);
          }
          return const IconThemeData(color: SwfColors.lightGray);
        }),
      ),
    );
  }
}
