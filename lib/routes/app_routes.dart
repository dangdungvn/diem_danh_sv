import 'package:flutter/material.dart';
import '../views/student_home_page.dart';
import '../views/profile_screen.dart';
import '../views/schedule_screen.dart';
import '../views/statistics_screen.dart';
import '../views/login_screen.dart';
import '../views/qr_scanner_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String schedule = '/schedule';
  static const String statistics = '/statistics';
  static const String qrScanner = '/qr-scanner';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const StudentHomePage(),
      profile: (context) => const ProfileScreen(),
      schedule: (context) => const ScheduleScreen(),
      statistics: (context) => const StatisticsScreen(),
      qrScanner: (context) => const QrScannerPage(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routes = getRoutes();
    final WidgetBuilder? builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    // Nếu không tìm thấy route, trả về trang mặc định (login)
    return MaterialPageRoute(
      builder: routes[login]!,
      settings: settings,
    );
  }
}
