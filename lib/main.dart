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
              textTheme: GoogleFonts.poppinsTextTheme().apply(
                bodyColor: const Color(0xFF1E293B),
                displayColor: const Color(0xFF1E293B),
              ),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: const Color(0xFF222862).withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                surfaceTintColor: Colors.transparent,
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
                shadowColor: Colors.transparent,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: const Color(0xFF222862),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF222862),
                  side: const BorderSide(color: Color(0xFF222862), width: 1.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF222862), width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontSize: 14,
                ),
                prefixIconColor: const Color(0xFF222862),
                suffixIconColor: const Color(0xFF222862),
              ),
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFF222862).withOpacity(0.1),
                labelTextStyle: MaterialStateProperty.all(
                  GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                shadowColor: Colors.black.withOpacity(0.05),
                surfaceTintColor: Colors.transparent,
                elevation: 3,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: const Color(0xFFF79421),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              dividerTheme: const DividerThemeData(
                color: Color(0xFFE2E8F0),
                thickness: 1,
                space: 1,
              ),
              chipTheme: ChipThemeData(
                backgroundColor: const Color(0xFFF1F5F9),
                selectedColor: const Color(0xFF222862),
                secondarySelectedColor: const Color(0xFF222862),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
                secondaryLabelStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              listTileTheme: const ListTileThemeData(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minLeadingWidth: 0,
                minVerticalPadding: 16,
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
              textTheme: GoogleFonts.poppinsTextTheme().apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              cardTheme: CardTheme(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF334155), width: 1),
                ),
                color: const Color(0xFF1E293B),
                surfaceTintColor: Colors.transparent,
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: const Color(0xFF403F8B),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFF222862).withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF334155), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF403F8B), width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                prefixIconColor: Colors.white,
                suffixIconColor: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: const Color(0xFF1E293B),
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
                elevation: 3,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: const Color(0xFFF79421),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              dividerTheme: const DividerThemeData(
                color: Color(0xFF334155),
                thickness: 1,
                space: 1,
              ),
              chipTheme: ChipThemeData(
                backgroundColor: const Color(0xFF334155),
                selectedColor: const Color(0xFF403F8B),
                secondarySelectedColor: const Color(0xFF403F8B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                secondaryLabelStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              listTileTheme: const ListTileThemeData(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minLeadingWidth: 0,
                minVerticalPadding: 16,
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
