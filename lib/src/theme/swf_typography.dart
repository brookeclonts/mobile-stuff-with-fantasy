import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Typography for the StuffWithFantasy app.
///
/// The website uses Adobe Typekit fonts:
///   - **Yana** for display/headings
///   - **Urbane Rounded** for UI labels/subheadings
///
/// Since these are licensed Adobe fonts, we use Playfair Display (display)
/// and Inter (body) — both of which are also used on the site's home page.
///
/// To use the exact Adobe fonts, add the .ttf/.otf files to assets/fonts/
/// and update pubspec.yaml, then swap the fontFamily references here.
abstract final class SwfTypography {
  static TextTheme get textTheme {
    final displayFont = GoogleFonts.playfairDisplayTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return TextTheme(
      // Display styles — Playfair Display (standing in for Yana)
      displayLarge: displayFont.displayLarge!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: displayFont.displayMedium!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: displayFont.displaySmall!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),

      // Headline styles — Playfair Display
      headlineLarge: displayFont.headlineLarge!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: displayFont.headlineMedium!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: displayFont.headlineSmall!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w500,
      ),

      // Title styles — Inter (standing in for Urbane Rounded)
      titleLarge: bodyFont.titleLarge!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: bodyFont.titleMedium!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: bodyFont.titleSmall!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w500,
      ),

      // Body styles — Inter
      bodyLarge: bodyFont.bodyLarge!.copyWith(color: SwfColors.primaryText),
      bodyMedium: bodyFont.bodyMedium!.copyWith(color: SwfColors.primaryText),
      bodySmall: bodyFont.bodySmall!.copyWith(color: SwfColors.mediumGray),

      // Label styles — Inter
      labelLarge: bodyFont.labelLarge!.copyWith(
        color: SwfColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: bodyFont.labelMedium!.copyWith(color: SwfColors.mediumGray),
      labelSmall: bodyFont.labelSmall!.copyWith(color: SwfColors.lightGray),
    );
  }
}
