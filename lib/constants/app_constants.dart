import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';

  static const String appName = 'BM Store';

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 10);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultRadius = 16.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 24.0;
  static const double extraLargeRadius = 32.0;

  static const String cartStorageKey = 'cart_items';
  static const String userStorageKey = 'user_data';

  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration defaultDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  static const int apiTimeoutDuration = 15; // seconds
}

class AppColors {
  // Primary and accent colors
  static const Color primaryColor = Color(0xFF3E64FF); // Royal Blue
  static const Color secondaryColor = Color(0xFF5A73E8); // Lighter Blue
  static const Color accentColor = Color(0xFFFF7E67); // Coral
  static const Color tertiaryColor = Color(0xFFFFC15E); // Amber

  // Background Colors
  static const Color scaffoldBackground = Colors.white;
  static const Color cardColor = Color(0xFFF8F9FD); // Light Gray-Blue
  static const Color cardBackgroundColor = Colors.white;

  // Text Colors
  static const Color textColor = Color(0xFF2C3E50); // Dark Blue-Gray
  static const Color textSecondaryColor = Color(0xFF7F8C9A); // Medium Gray
  static const Color textLightColor = Color(0xFFBDC3C7); // Light Gray

  // Status Colors
  static const Color successColor = Color(0xFF2ECC71); // Green
  static const Color errorColor = Color(0xFFE74C3C); // Red
  static const Color warningColor = Color(0xFFF39C12); // Orange
  static const Color infoColor = Color(0xFF3498DB); // Blue

  // Misc
  static const Color dividerColor = Color(0xFFEFF2F7); // Very Light Gray
  static const Color shadowColor = Color(0x10000000); // Shadow

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3E64FF), Color(0xFF5A73E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF7E67), Color(0xFFFF9D8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF8F9FD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  // Using Outfit font for headings - a modern geometric sans serif
  static final TextStyle headline1 = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textColor,
  );

  static final TextStyle headline2 = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textColor,
  );

  static final TextStyle headline3 = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textColor,
  );

  static final TextStyle headline4 = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textColor,
  );

  // Using Plus Jakarta Sans for body text - a modern humanist sans serif with excellent readability
  static final TextStyle bodyText1 = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textColor,
  );

  static final TextStyle bodyText2 = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textColor,
  );

  static final TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textSecondaryColor,
  );

  static final TextStyle button = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static final TextStyle overline = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondaryColor,
  );
}
