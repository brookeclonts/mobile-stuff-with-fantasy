import 'package:flutter/material.dart';

/// Brand colors from the StuffWithFantasy website.
///
/// Primary palette defined as CSS custom properties in app.css,
/// supplemented by the JS color constants in assets/colors.ts.
abstract final class SwfColors {
  // -- Core brand palette (from CSS :root custom properties) --

  /// General text color
  static const color1 = Color(0xFF3F3F3F);

  /// Deep dark plum — brand dark
  static const color2 = Color(0xFF382532);

  /// Dark purple — hover states, buttons
  static const color3 = Color(0xFF59324C);

  /// Pink/rose — primary CTA buttons, pills
  static const color4 = Color(0xFFB96D9A);

  /// Light warm beige — card backgrounds
  static const color5 = Color(0xFFDBD4CE);

  /// Warm bronze/gold — secondary accents, shop button
  static const color6 = Color(0xFFBC8D60);

  /// Dark navy blue — page background
  static const color7 = Color(0xFF1E364B);

  /// Off-white/cream — light backgrounds
  static const color8 = Color(0xFFEFEDE9);

  // -- Grays --

  /// Dark charcoal text
  static const gray = Color(0xFF2F2E2E);

  /// Medium gray
  static const mediumGray = Color(0xFF464646);

  /// Light gray
  static const lightGray = Color(0xFF7E7E7E);

  // -- Extended palette (from colors.ts) --

  static const blue = Color(0xFF82B1A1);
  static const purple = Color(0xFFAF65AF);
  static const violet = Color(0xFF7C54C5);
  static const orange = Color(0xFFF3BD75);

  /// Bright teal — high-contrast variant of blue for dark surfaces
  static const blueBright = Color(0xFFA8D4C4);

  // -- Derived / dark navy --

  /// Very dark navy (used in gradients)
  static const darkNavy = Color(0xFF172939);

  // -- Logo colors --

  /// Muted mauve — crest illustration
  static const logoMauve = Color(0xFFB7A69E);

  /// Medium plum — wordmark lettering
  static const logoPlum = Color(0xFF754167);

  // -- Pill / tag backgrounds --

  static const spicinessPill = Color(0xFFF5D0E8);
  static const representationPill = Color(0xFFD4E4F0);
  static const tropePill = Color(0xFFE8D5F0);

  // -- Semantic aliases --

  static const primaryBackground = color7;
  static const cardBackground = color5;
  static const lightBackground = color8;
  static const primaryText = color1;
  static const primaryButton = color4;
  static const secondaryAccent = color6;
  static const brandDark = color2;
  static const brandPurple = color3;
}
