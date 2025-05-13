import 'package:diem_danh_sv/providers/profile_provider.dart';
import 'package:diem_danh_sv/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/schedule_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  // Đảm bảo WidgetsFlutterBinding đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(1080, 2400),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   // skipTaskbar: false,
  //   // titleBarStyle: TitleBarStyle.hidden,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  // Tải file .env
  await dotenv.load(fileName: '.env');

  // Khởi tạo AuthProvider và đợi kiểm tra trạng thái đăng nhập
  final authProvider = AuthProvider();

  // Làm mới access token khi khởi động app để tạo phiên đăng nhập mới
  final refreshed = await authProvider.refreshAccessToken();

  // Nếu không làm mới được thì kiểm tra trạng thái đăng nhập bình thường
  if (!refreshed) {
    await authProvider.checkLoginStatus();
  }

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'UTT University Attendance',
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
