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
                primary: Color(0xFF222862), // Navy chủ đạo
                secondary: Color(0xFFF79421), // Cam chủ đạo
                tertiary: Color(0xFF6B68B1), // Tím nhạt phụ trợ
                error: Color(0xFFE53935), // Đỏ
                background: Color(0xFFF5F5F8), // Xám nhạt ấm
                surface: Colors.white,
                surfaceTint: Colors.white,
                surfaceContainerLowest: Color(0xFFFFFEFC), // Lightest container
                surfaceContainerLow: Color(0xFFF8F8FC), // Light container
                surfaceContainer: Color(0xFFF0F0F7), // Medium container
                surfaceContainerHigh: Color(0xFFE8E8F0), // Darker container
                surfaceContainerHighest: Color(0xFFDDDDE8), // Darkest container
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onTertiary: Colors.white,
                onBackground: Color(0xFF333333),
                onSurface: Color(0xFF222862), // Text chính màu navy
                onSurfaceVariant: Color(0xFF555577), // Text phụ nhạt hơn navy
                outline: Color(0xFFCCCCE0), // Viền nhạt màu navy
                outlineVariant: Color(0xFFE0E0E8), // Viền rất nhạt màu navy
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: const Color(0xFF222862).withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF222862),
                titleTextStyle: GoogleFonts.poppins(
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
                  elevation: 3,
                  backgroundColor: const Color(0xFF222862),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFF0F0F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF222862), width: 1.5),
                ),
              ),
              scaffoldBackgroundColor:
                  const Color(0xFFF5F5F8), // Match background color
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFF222862).withOpacity(0.2),
                labelTextStyle: MaterialStateProperty.all(
                  GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                elevation: 3,
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
                primary:
                    Color(0xFF403F8B), // Navy chủ đạo sáng hơn cho dark mode
                secondary: Color(0xFFF79421), // Cam chủ đạo giữ nguyên
                tertiary: Color(0xFF8784D0), // Tím nhạt sáng hơn
                error: Color(0xFFE57373), // Đỏ nhạt hơn
                background: Color(0xFF121220),
                surface: Color(0xFF1E1E2F),
                surfaceTint: Color(0xFF1E1E2F),
                surfaceContainerLowest: Color(0xFF0E0E1A),
                surfaceContainerLow: Color(0xFF1A1A2A),
                surfaceContainer: Color(0xFF242437),
                surfaceContainerHigh: Color(0xFF2C2C40),
                surfaceContainerHighest: Color(0xFF38384D),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onTertiary: Colors.white,
                onBackground: Colors.white,
                onSurface: Colors.white,
                onSurfaceVariant: Color(0xFFAAAAAA),
                outline: Color(0xFF444466),
                outlineVariant: Color(0xFF333346),
              ),
              textTheme: GoogleFonts.poppinsTextTheme().apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: const Color(0xFF262638),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E1E2F),
                foregroundColor: Colors.white,
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                surfaceTintColor: Colors.transparent,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: const Color(0xFF403F8B),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF2A2A3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF403F8B), width: 1.5),
                ),
              ),
              scaffoldBackgroundColor:
                  const Color(0xFF121220), // Match background color
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: const Color(0xFF1E1E2F),
                indicatorColor: const Color(0xFF403F8B).withOpacity(0.2),
                labelTextStyle: MaterialStateProperty.all(
                  GoogleFonts.poppins(
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
