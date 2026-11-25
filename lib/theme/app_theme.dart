import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the app-wide Material 3 theme from the warm coffee palette.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    final poppins = GoogleFonts.poppinsTextTheme(base.textTheme);

    final textTheme = poppins.copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 40,
        height: 1.08,
        letterSpacing: -1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.espresso,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 34,
        height: 1.12,
        letterSpacing: -0.8,
        fontWeight: FontWeight.w700,
        color: AppColors.espresso,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 28,
        height: 1.18,
        letterSpacing: -0.6,
        fontWeight: FontWeight.w700,
        color: AppColors.espresso,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 23,
        height: 1.2,
        letterSpacing: -0.4,
        fontWeight: FontWeight.w600,
        color: AppColors.espresso,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 19,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AppColors.espresso,
      ),
      titleMedium: poppins.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.espresso,
      ),
      titleSmall: poppins.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      bodyLarge: poppins.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.55,
        color: AppColors.charcoal,
      ),
      bodyMedium: poppins.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.5,
        color: AppColors.charcoal,
      ),
      bodySmall: poppins.bodySmall?.copyWith(
        fontSize: 12.5,
        height: 1.45,
        color: AppColors.mutedGray,
      ),
      labelLarge: poppins.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: poppins.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: AppColors.mutedGray,
      ),
      labelSmall: poppins.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: AppColors.mutedGray,
      ),
    );

    final radius = BorderRadius.circular(18);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.caramel,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.caramel,
        onPrimary: AppColors.espresso,
        secondary: AppColors.espresso,
        onSecondary: AppColors.cream,
        surface: AppColors.cream,
        onSurface: AppColors.charcoal,
        onSurfaceVariant: AppColors.mutedGray,
        surfaceContainerHighest: AppColors.almond,
        outline: AppColors.crema,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.espresso),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.espresso,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.caramel,
          foregroundColor: AppColors.espresso,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: GoogleFonts.poppins(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.espresso,
          side: const BorderSide(color: AppColors.crema, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.caramelDeep,
          textStyle: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.espresso, size: 22),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 13,
          height: 1.4,
          color: AppColors.cream,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.crema,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.caramel,
        linearTrackColor: AppColors.almond,
        linearMinHeight: 8,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.caramel,
        selectionColor: AppColors.caramelGlow,
        selectionHandleColor: AppColors.caramel,
      ),
    );
  }
}
