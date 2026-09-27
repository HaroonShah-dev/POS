// =============================================================================
// core.dart
// Store Management App — Core Design System
// Contains: AppColors, AppTextStyles, AppValidators, AppDimensions, AppTheme
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================
// 1. COLORS
// =============================================================================
class AppColors {
  AppColors._();

  // ---- Brand ----
  static const Color primary = Color(0xFF1E3A5F); // Deep navy blue
  static const Color primaryLight = Color(0xFF335C81);
  static const Color primaryDark = Color(0xFF0F2340);

  static const Color secondary = Color(0xFF2FBF71); // Fresh green (accent)
  static const Color secondaryLight = Color(0xFF5FD394);
  static const Color secondaryDark = Color(0xFF1E8E52);

  static const Color accent = Color(0xFFF5A623); // Amber highlight

  // ---- Neutrals / Surfaces ----
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFE1E4E8);
  static const Color divider = Color(0xFFE9ECEF);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF1A1D23);
  static const Color textSecondary = Color(0xFF5F6672);
  static const Color textHint = Color(0xFF9AA1AC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---- Status ----
  static const Color success = Color(0xFF2FBF71);
  static const Color successBg = Color(0xFFE6F9EF);
  static const Color warning = Color(0xFFF5A623);
  static const Color warningBg = Color(0xFFFFF4E0);
  static const Color error = Color(0xFFE0433D);
  static const Color errorBg = Color(0xFFFCEAE9);
  static const Color info = Color(0xFF2F80ED);
  static const Color infoBg = Color(0xFFE8F1FD);

  // ---- Inventory / Store specific status ----
  static const Color inStock = Color(0xFF2FBF71);
  static const Color lowStock = Color(0xFFF5A623);
  static const Color outOfStock = Color(0xFFE0433D);

  // ---- Gradients ----
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  // ---- Shadows ----
  static List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black, blurRadius: 16, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black, blurRadius: 10, offset: const Offset(0, 2)),
  ];
}

// =============================================================================
// 2. TEXT STYLES
// =============================================================================
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter'; // swap for your bundled font

  // ---- Display / Headings ----
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // ---- Body ----
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ---- Labels / UI ----
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.3,
  );

  // ---- Store-specific ----
  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle priceDiscount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle statusBadge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );
}

// =============================================================================
// 3. DIMENSIONS / SPACING / RADIUS
// =============================================================================
class AppDimensions {
  AppDimensions._();

  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  static const double inputHeight = 52.0;
  static const double buttonHeight = 52.0;
  static const double appBarHeight = 64.0;
}

// =============================================================================
// 4. VALIDATORS
// =============================================================================
class AppValidators {
  AppValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
  );
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
  static final RegExp _skuRegex = RegExp(r'^[A-Za-z0-9\-\_]{3,20}$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  /// Generic required-field check.
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (!_usernameRegex.hasMatch(value.trim())) {
      return '3-20 characters: letters, numbers, underscore only';
    }
    return null;
  }

  /// Validates a plain numeric string (e.g. quantities).
  static String? number(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (num.tryParse(value.trim()) == null) return '$field must be a number';
    return null;
  }

  /// Validates a positive price (allows decimals, up to 2 places).
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) return 'Price is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid price';
    if (parsed < 0) return 'Price cannot be negative';
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value.trim())) {
      return 'Max 2 decimal places allowed';
    }
    return null;
  }

  /// Validates stock quantity (non-negative integer).
  static String? stockQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stock quantity is required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Enter a whole number';
    if (parsed < 0) return 'Stock cannot be negative';
    return null;
  }

  /// Validates a product SKU / barcode-friendly code.
  static String? sku(String? value) {
    if (value == null || value.trim().isEmpty) return 'SKU is required';
    if (!_skuRegex.hasMatch(value.trim())) {
      return '3-20 chars: letters, numbers, - or _ only';
    }
    return null;
  }

  /// Validates min length.
  static String? minLength(
    String? value,
    int length, {
    String field = 'This field',
  }) {
    if (value == null || value.trim().length < length) {
      return '$field must be at least $length characters';
    }
    return null;
  }

  /// Validates max length.
  static String? maxLength(
    String? value,
    int length, {
    String field = 'This field',
  }) {
    if (value != null && value.trim().length > length) {
      return '$field must be under $length characters';
    }
    return null;
  }

  /// Combines multiple validators; returns the first error found.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

// =============================================================================
// 5. INPUT FORMATTERS (bonus — commonly needed alongside validators)
// =============================================================================
class AppFormatters {
  AppFormatters._();

  static final priceFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d{0,2}'),
  );

  static final integerOnly = FilteringTextInputFormatter.digitsOnly;

  static final noWhitespace = FilteringTextInputFormatter.deny(RegExp(r'\s'));
}

// =============================================================================
// 6. THEME
// =============================================================================
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h4,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
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
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceMd,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        labelStyle: AppTextStyles.label,
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        titleLarge: AppTextStyles.h4,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.button,
      ),
    );
  }
}
