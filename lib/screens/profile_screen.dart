import 'package:flutter/material.dart';
import '../widgets/profile/profile_app_bar.dart';
import '../widgets/profile/profile_stat_card.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/profile_action_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header với avatar và thông tin cơ bản
          const ProfileAppBar(),

          // Thẻ Tổng quan
          const SliverToBoxAdapter(
            child: ProfileStatCard(),
          ),

          // Thông tin cá nhân
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ProfileInfoSection(
                title: 'Thông tin cá nhân',
                icon: Icons.person_outline,
                items: [
                  ProfileItem(
                    icon: Icons.school_outlined,
                    label: 'Khoa',
                    value: 'Công nghệ thông tin',
                  ),
                  ProfileItem(
                    icon: Icons.class_outlined,
                    label: 'Chuyên ngành',
                    value: 'Kỹ thuật phần mềm',
                  ),
                  ProfileItem(
                    icon: Icons.group_outlined,
                    label: 'Lớp',
                    value: 'D21CQCN01-B',
                  ),
                  ProfileItem(
                    icon: Icons.school_outlined,
                    label: 'Khóa',
                    value: '2021-2025',
                  ),
                ],
              ),
            ),
          ),

          // Thông tin liên hệ
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ProfileInfoSection(
                title: 'Thông tin liên hệ',
                icon: Icons.contact_mail_outlined,
                items: [
                  ProfileItem(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'example@student.hust.edu.vn',
                  ),
                  ProfileItem(
                    icon: Icons.phone_outlined,
                    label: 'Số điện thoại',
                    value: '0123456789',
                  ),
                  ProfileItem(
                    icon: Icons.location_on_outlined,
                    label: 'Địa chỉ',
                    value: 'Hà Nội',
                  ),
                ],
              ),
            ),
          ),

          // Các nút hành động
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ProfileActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Chỉnh sửa thông tin',
                    onTap: () {
                      // TODO: Implement edit profile
                    },
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  ProfileActionButton(
                    icon: Icons.lock_outline,
                    label: 'Đổi mật khẩu',
                    onTap: () {
                      // TODO: Implement change password
                    },
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  ProfileActionButton(
                    icon: Icons.logout,
                    label: 'Đăng xuất',
                    onTap: () {
                      // TODO: Implement logout
                    },
                    isDestructive: true,
                  ),
                  const SizedBox(height: 24),

                  // App version
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'Phiên bản 1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
