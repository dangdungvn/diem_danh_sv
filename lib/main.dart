import 'package:diem_danh_sv/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  // Đảm bảo WidgetsFlutterBinding đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Tải file .env
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'Điểm Danh SV',
            debugShowCheckedModeBanner: false,
            theme: getLightTheme(),
            darkTheme: getDarkTheme(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // Kiểm tra trạng thái đăng nhập để chọn màn hình khởi đầu
            initialRoute:
                authProvider.isLoggedIn ? AppRoutes.home : AppRoutes.login,
            routes: AppRoutes.getRoutes(),
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
