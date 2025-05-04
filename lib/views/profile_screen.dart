import 'package:diem_danh_sv/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../widgets/profile/profile_app_bar.dart';
import '../widgets/profile/profile_stat_card.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/profile_action_button.dart';
import './edit_profile_screen.dart';
import './change_password_screen.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Lấy thông tin profile khi màn hình được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final User? user = profileProvider.user;
          final ProfileModel? profile = profileProvider.profile;

          if (profileProvider.isLoading && user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Không thể tải thông tin người dùng',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.fetchUserProfile();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => profileProvider.fetchUserProfile(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header với avatar và thông tin cơ bản
                ProfileAppBar(
                  user: user,
                  profile: profile,
                  onEditProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    ).then((_) {
                      // Cập nhật thông tin khi quay lại từ màn chỉnh sửa
                      profileProvider.fetchUserProfile();
                    });
                  },
                ),

                // Thẻ Tổng quan
                const SliverToBoxAdapter(
                  child: ProfileStatCard(),
                ),

                // Thông tin cá nhân
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: ProfileInfoSection(
                      title: 'Thông tin cá nhân',
                      icon: Icons.person_outline,
                      items: [
                        ProfileItem(
                          icon: Icons.badge_outlined,
                          label: 'Họ và tên',
                          value: user.name,
                        ),
                        if (user.gender != null)
                          ProfileItem(
                            icon: Icons.people_outline,
                            label: 'Giới tính',
                            value: user.gender == 'M'
                                ? 'Nam'
                                : (user.gender == 'F' ? 'Nữ' : 'Khác'),
                          ),
                        if (user.dateOfBirth != null)
                          ProfileItem(
                            icon: Icons.cake_outlined,
                            label: 'Ngày sinh',
                            value: user.dateOfBirth!,
                          ),
                        ProfileItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                      ],
                    ),
                  ),
                ),

                // Thông tin liên hệ
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ProfileInfoSection(
                      title: 'Thông tin liên hệ',
                      icon: Icons.contact_mail_outlined,
                      items: [
                        if (user.phoneNumber != null)
                          ProfileItem(
                            icon: Icons.phone_outlined,
                            label: 'Số điện thoại',
                            value: user.phoneNumber!,
                          ),
                        if (user.address != null)
                          ProfileItem(
                            icon: Icons.location_on_outlined,
                            label: 'Địa chỉ',
                            value: user.address!,
                          ),
                        if (user.bio != null && user.bio!.isNotEmpty)
                          ProfileItem(
                            icon: Icons.info_outline,
                            label: 'Giới thiệu',
                            value: user.bio!,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            ).then((_) {
                              // Cập nhật thông tin khi quay lại từ màn chỉnh sửa
                              profileProvider.fetchUserProfile();
                            });
                          },
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        ProfileActionButton(
                          icon: Icons.lock_outline,
                          label: 'Đổi mật khẩu',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(height: 12),
                        ProfileActionButton(
                          icon: Icons.logout,
                          label: 'Đăng xuất',
                          onTap: () {
                            _showLogoutConfirmation(context);
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
                                color: colorScheme.onSurfaceVariant
                                    .withOpacity(0.6),
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
        },
      ),
    );
  }

  // Hiển thị dialog xác nhận đăng xuất
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Thực hiện đăng xuất
              Provider.of<AuthProvider>(context, listen: false)
                  .logout()
                  .then((_) {
                // Chuyển về màn hình đăng nhập sau khi đăng xuất
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false);
              });
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
