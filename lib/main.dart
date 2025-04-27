import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/student_home_page.dart';

void main() {
  runApp(const MyApp());
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Điểm Danh SV',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF222862),
                secondary: Color(0xFFF79421),
                tertiary: Color(0xFF6B68B1),
                error: Color(0xFFE53935),
                background: Color(0xFFF8FAFC),
                surface: Colors.white,
                surfaceTint: Colors.white,
                surfaceContainerLowest: Colors.white,
                surfaceContainerLow: Color(0xFFF8FAFC),
                surfaceContainer: Color(0xFFF1F5F9),
                surfaceContainerHigh: Color(0xFFE2E8F0),
                surfaceContainerHighest: Color(0xFFCBD5E1),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onTertiary: Colors.white,
                onBackground: Color(0xFF1E293B),
                onSurface: Color(0xFF1E293B),
                onSurfaceVariant: Color(0xFF64748B),
                outline: Color(0xFFE2E8F0),
                outlineVariant: Color(0xFFF1F5F9),
              ),
              textTheme: GoogleFonts.interTextTheme(),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: const Color(0xFF222862).withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 6,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF222862),
                titleTextStyle: GoogleFonts.inter(
                  color: const Color(0xFF222862),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: const IconThemeData(
                  color: Color(0xFF222862),
                ),
                surfaceTintColor: Colors.transparent,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: const Color(0xFF222862),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF222862), width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFF222862).withOpacity(0.1),
                labelTextStyle: MaterialStateProperty.all(
                  GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.05),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFF79421),
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF403F8B),
                secondary: Color(0xFFF79421),
                tertiary: Color(0xFF8784D0),
                error: Color(0xFFE57373),
                background: Color(0xFF0F172A),
                surface: Color(0xFF1E293B),
                surfaceTint: Color(0xFF1E293B),
                surfaceContainerLowest: Color(0xFF0F172A),
                surfaceContainerLow: Color(0xFF1E293B),
                surfaceContainer: Color(0xFF334155),
                surfaceContainerHigh: Color(0xFF475569),
                surfaceContainerHighest: Color(0xFF64748B),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onTertiary: Colors.white,
                onBackground: Colors.white,
                onSurface: Colors.white,
                onSurfaceVariant: Color(0xFF94A3B8),
                outline: Color(0xFF334155),
                outlineVariant: Color(0xFF1E293B),
              ),
              textTheme: GoogleFonts.interTextTheme().apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF334155)),
                ),
                color: const Color(0xFF1E293B),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 6,
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                titleTextStyle: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                surfaceTintColor: Colors.transparent,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: const Color(0xFF403F8B),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF403F8B), width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: const Color(0xFF1E293B),
                indicatorColor: const Color(0xFF403F8B).withOpacity(0.2),
                labelTextStyle: MaterialStateProperty.all(
                  GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                iconTheme: MaterialStateProperty.all(
                  const IconThemeData(color: Colors.white),
                ),
                surfaceTintColor: Colors.transparent,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFF79421),
                foregroundColor: Colors.white,
              ),
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const StudentHomePage(),
          );
        },
      ),
    );
  }
}
