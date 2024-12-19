import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/medical_info_screen.dart';
import 'providers/app_provider.dart';

// Define custom colors
class AppColors {
  // Primary Colors
  static const primary = Color(0xFF2D3142);        // Deep Blue Gray
  static const primaryLight = Color(0xFF4F5D75);   // Light Blue Gray
  static const primaryDark = Color(0xFF1C1F2B);    // Dark Blue Gray

  // Secondary Colors
  static const secondary = Color(0xFFEF233C);      // Vibrant Red
  static const secondaryLight = Color(0xFFFF4D6D); // Light Red
  static const secondaryDark = Color(0xFFD90429);  // Dark Red

  // Accent Colors
  static const accent = Color(0xFF8D99AE);         // Cool Gray
  static const accentLight = Color(0xFFBDC6D1);    // Light Gray
  static const accentDark = Color(0xFF5C6B7A);     // Dark Gray

  // Background Colors
  static const background = Color(0xFFF8F9FA);     // Off White
  static const surface = Color(0xFFFFFFFF);        // Pure White
  static const surfaceVariant = Color(0xFFF2F4F6); // Light Gray

  // Text Colors
  static const textDark = Color(0xFF2D3142);       // Almost Black
  static const textMedium = Color(0xFF4F5D75);     // Dark Gray
  static const textLight = Color(0xFF8D99AE);      // Medium Gray

  // Status Colors
  static const success = Color(0xFF28A745);        // Green
  static const warning = Color(0xFFFFC107);        // Yellow
  static const error = Color(0xFFDC3545);          // Red
  static const info = Color(0xFF17A2B8);           // Blue
}

void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
  
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('first_time') ?? true;
  
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'First Aid Kit',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            primaryContainer: AppColors.primaryLight,
            onPrimaryContainer: Colors.white,
            
            secondary: AppColors.secondary,
            onSecondary: Colors.white,
            secondaryContainer: AppColors.secondaryLight,
            onSecondaryContainer: Colors.white,
            
            surface: AppColors.surface,
            onSurface: AppColors.textDark,
            surfaceVariant: AppColors.surfaceVariant,
            onSurfaceVariant: AppColors.textMedium,
            
            background: AppColors.background,
            onBackground: AppColors.textDark,
            
            error: AppColors.error,
            onError: Colors.white,
            
            tertiary: AppColors.accent,
            onTertiary: Colors.white,
            tertiaryContainer: AppColors.accentLight,
            onTertiaryContainer: AppColors.textDark,
          ),
          scaffoldBackgroundColor: AppColors.background,
          
          // App Bar Theme
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 70,
            shadowColor: AppColors.primaryDark.withOpacity(0.3),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: AppColors.primaryDark.withOpacity(0.3),
                ),
              ],
            ),
          ),
          
          // Card Theme
          cardTheme: CardTheme(
            color: AppColors.surface,
            elevation: 2,
            shadowColor: AppColors.primaryDark.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          
          // Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: AppColors.secondaryDark.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.accent.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.accent.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        initialRoute: isFirstTime ? '/intro' : '/home',
        routes: {
          '/intro': (context) => const IntroScreen(),
          '/home': (context) => const HomeScreen(),
          '/medical_info': (context) => const MedicalInfoScreen(),
        },
      ),
    );
  }
}
