import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../views/profile_screen.dart';

class StudentAppBar extends StatelessWidget {
  const StudentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Background với hình ảnh logo-bg
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/logo-bg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    colorScheme.primary.withOpacity(0.85),
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),

            // Decorative elements - dots/accents
            Positioned(
              top: 15,
              right: 25,
              child: Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Subtle overlay for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),

            // Logo and university name
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo-short.png',
                        width: 40,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'UTT University',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Action buttons với thiết kế hiện đại
      actions: [
        // Theme toggle button
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.white,
              size: 22,
            ),
            tooltip: isDark ? 'Chế độ sáng' : 'Chế độ tối',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ),

        // Profile button
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
            tooltip: 'Hồ sơ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
