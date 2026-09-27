// =============================================================================
// app_theme.dart
// Store Management App — Light & Dark Theme
// Depends on: core.dart (AppColors, AppTextStyles, AppDimensions)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

// =============================================================================
// DARK PALETTE (companion to AppColors in core.dart)
// =============================================================================
class AppColorsDark {
  AppColorsDark._();

  static const Color primary = Color(
    0xFF4E7FB0,
  ); // Softer navy-blue for dark bg
  static const Color primaryLight = Color(0xFF6E9AC4);
  static const Color primaryDark = Color(0xFF335C81);

  static const Color secondary = Color(0xFF3ED685);
  static const Color secondaryLight = Color(0xFF6EE3A2);

  static const Color accent = Color(0xFFF7B84B);

  static const Color background = Color(0xFF12151B);
  static const Color surface = Color(0xFF1B1F27);
  static const Color surfaceMuted = Color(0xFF232833);
  static const Color border = Color(0xFF2D3340);
  static const Color divider = Color(0xFF2A2F3A);

  static const Color textPrimary = Color(0xFFF5F6F8);
  static const Color textSecondary = Color(0xFFA6ADBB);
  static const Color textHint = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF3ED685);
  static const Color successBg = Color(0xFF17301F);
  static const Color warning = Color(0xFFF7B84B);
  static const Color warningBg = Color(0xFF332711);
  static const Color error = Color(0xFFEF5A53);
  static const Color errorBg = Color(0xFF331A18);
  static const Color info = Color(0xFF5B9BF5);
  static const Color infoBg = Color(0xFF16233A);

  static const Color inStock = success;
  static const Color lowStock = warning;
  static const Color outOfStock = error;
}

// =============================================================================
// THEME EXTENSION — custom semantic colors accessible via Theme.of(context)
// (keeps store-specific colors theme-aware without hardcoding light/dark)
// =============================================================================
@immutable
class StoreColors extends ThemeExtension<StoreColors> {
  const StoreColors({
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
    required this.successBg,
    required this.warningBg,
    required this.errorBg,
    required this.infoBg,
  });

  final Color inStock;
  final Color lowStock;
  final Color outOfStock;
  final Color successBg;
  final Color warningBg;
  final Color errorBg;
  final Color infoBg;

  static const light = StoreColors(
    inStock: AppColors.inStock,
    lowStock: AppColors.lowStock,
    outOfStock: AppColors.outOfStock,
    successBg: AppColors.successBg,
    warningBg: AppColors.warningBg,
    errorBg: AppColors.errorBg,
    infoBg: AppColors.infoBg,
  );

  static const dark = StoreColors(
    inStock: AppColorsDark.inStock,
    lowStock: AppColorsDark.lowStock,
    outOfStock: AppColorsDark.outOfStock,
    successBg: AppColorsDark.successBg,
    warningBg: AppColorsDark.warningBg,
    errorBg: AppColorsDark.errorBg,
    infoBg: AppColorsDark.infoBg,
  );

  @override
  StoreColors copyWith({
    Color? inStock,
    Color? lowStock,
    Color? outOfStock,
    Color? successBg,
    Color? warningBg,
    Color? errorBg,
    Color? infoBg,
  }) {
    return StoreColors(
      inStock: inStock ?? this.inStock,
      lowStock: lowStock ?? this.lowStock,
      outOfStock: outOfStock ?? this.outOfStock,
      successBg: successBg ?? this.successBg,
      warningBg: warningBg ?? this.warningBg,
      errorBg: errorBg ?? this.errorBg,
      infoBg: infoBg ?? this.infoBg,
    );
  }

  @override
  StoreColors lerp(ThemeExtension<StoreColors>? other, double t) {
    if (other is! StoreColors) return this;
    return StoreColors(
      inStock: Color.lerp(inStock, other.inStock, t)!,
      lowStock: Color.lerp(lowStock, other.lowStock, t)!,
      outOfStock: Color.lerp(outOfStock, other.outOfStock, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
    );
  }
}

/// Convenience getter: `context.storeColors.lowStock`
extension StoreColorsX on BuildContext {
  StoreColors get storeColors => Theme.of(this).extension<StoreColors>()!;
}

// =============================================================================
// APP THEME — light & dark ThemeData
// =============================================================================
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    bg: AppColors.background,
    surface: AppColors.surface,
    surfaceMuted: AppColors.surfaceMuted,
    border: AppColors.border,
    divider: AppColors.divider,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textOnPrimary: AppColors.textOnPrimary,
    storeColors: StoreColors.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    bg: AppColorsDark.background,
    surface: AppColorsDark.surface,
    surfaceMuted: AppColorsDark.surfaceMuted,
    border: AppColorsDark.border,
    divider: AppColorsDark.divider,
    primary: AppColorsDark.primary,
    secondary: AppColorsDark.secondary,
    error: AppColorsDark.error,
    textPrimary: AppColorsDark.textPrimary,
    textSecondary: AppColorsDark.textSecondary,
    textHint: AppColorsDark.textHint,
    textOnPrimary: AppColorsDark.textOnPrimary,
    storeColors: StoreColors.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color surfaceMuted,
    required Color border,
    required Color divider,
    required Color primary,
    required Color secondary,
    required Color error,
    required Color textPrimary,
    required Color textSecondary,
    required Color textHint,
    required Color textOnPrimary,
    required StoreColors storeColors,
  }) {
    final textTheme = TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: textPrimary),
      displayMedium: AppTextStyles.h2.copyWith(color: textPrimary),
      headlineSmall: AppTextStyles.h3.copyWith(color: textPrimary),
      titleLarge: AppTextStyles.h4.copyWith(color: textPrimary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      labelLarge: AppTextStyles.button.copyWith(color: textOnPrimary),
      labelSmall: AppTextStyles.caption.copyWith(color: textHint),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      fontFamily: AppTextStyles.fontFamily,
      canvasColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: textOnPrimary,
        secondary: secondary,
        onSecondary: textOnPrimary,
        error: error,
        onError: textOnPrimary,
        surface: surface,
        onSurface: textPrimary,
      ),
      extensions: [storeColors],
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          disabledBackgroundColor: primary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          textStyle: AppTextStyles.button,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          textStyle: AppTextStyles.button.copyWith(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppTextStyles.button.copyWith(color: primary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: textOnPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceMd,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: textHint),
        labelStyle: AppTextStyles.label.copyWith(color: textSecondary),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceMuted,
        labelStyle: AppTextStyles.statusBadge.copyWith(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: bg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: textSecondary,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: textHint,
        labelStyle: AppTextStyles.label,
        indicatorColor: primary,
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: textSecondary),
      dividerColor: divider,
    );
  }
}
