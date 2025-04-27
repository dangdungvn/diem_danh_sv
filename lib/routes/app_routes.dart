import 'package:flutter/material.dart';
import '../screens/student_home_page.dart';
import '../screens/profile_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/statistics_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String schedule = '/schedule';
  static const String statistics = '/statistics';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const StudentHomePage(),
      profile: (context) => const ProfileScreen(),
      schedule: (context) => const ScheduleScreen(),
      statistics: (context) => const StatisticsScreen(),
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

    // Nếu không tìm thấy route, trả về trang mặc định (home)
    return MaterialPageRoute(
      builder: routes[home]!,
      settings: settings,
    );
  }
}