import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classInfo;

  const ClassDetailScreen({
    super.key,
    required this.classInfo,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tạo màu ngẫu nhiên dựa trên tên lớp học
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.deepOrange,
      Colors.indigo,
      Colors.teal,
    ];
    final color = colors[classInfo.className.hashCode.abs() % colors.length];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar với header thông tin lớp học
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: color.withOpacity(0.1),
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.2),
                      color.withOpacity(0.2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      // Icon lớp học
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school,
                          color: color,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tên lớp học
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          classInfo.className,
                          style: TextStyle(
                            color: color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Các tag hiển thị thông tin lớp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Mã lớp: ${classInfo.classCode}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: color.withOpacity(0.9),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (classInfo.students.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Sĩ số: ${classInfo.students.length} SV',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: color.withOpacity(0.9),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_vert, color: color),
                    onPressed: () {
                      // Hiển thị menu tùy chọn
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => _buildOptionsSheet(context),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Nội dung chính
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thẻ tổng quan về lớp học
                _buildOverviewCard(context, color),

                const SizedBox(height: 16),

                // Phần giảng viên
                _buildSectionTitle(
                    context, 'Giảng viên giảng dạy', Icons.person, color),
                _buildTeachersList(context, classInfo.teachers, color),

                const SizedBox(height: 16),

                // Phần sinh viên
                _buildSectionTitle(
                    context, 'Danh sách sinh viên', Icons.people, color),
                _buildStudentsList(context, classInfo.students, color),

                const SizedBox(
                    height: 80), // Thêm khoảng cách để tránh FAB che nội dung
              ],
            ),
          ),
        ],
      ),

      // Nút điểm danh
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Triển khai tính năng điểm danh
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chức năng điểm danh đang được phát triển'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: color,
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text(
          'Điểm danh',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget hiển thị menu tùy chọn
  Widget _buildOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.primary),
            title: const Text('Thông tin lớp học'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Hiển thị thông tin chi tiết lớp học
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary),
            title: const Text('Lịch học của lớp'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Hiển thị lịch học của lớp
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment,
                color: Theme.of(context).colorScheme.primary),
            title: const Text('Lịch sử điểm danh'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Hiển thị lịch sử điểm danh
            },
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thẻ tổng quan
  Widget _buildOverviewCard(BuildContext context, Color color) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng quan lớp học',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoItem(
                    context,
                    Icons.person,
                    '${classInfo.teachers.length}',
                    'Giảng viên',
                    Colors.blue,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.people,
                    '${classInfo.students.length}',
                    'Sinh viên',
                    Colors.orange,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.book,
                    'Mã',
                    classInfo.classCode,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị một mục thông tin trong thẻ tổng quan
  Widget _buildInfoItem(BuildContext context, IconData icon, String title,
      String subtitle, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget hiển thị tiêu đề phần
  Widget _buildSectionTitle(
      BuildContext context, String title, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách giảng viên
  Widget _buildTeachersList(
      BuildContext context, List<TeacherInfo> teachers, Color color) {
    if (teachers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.person_off,
                size: 48,
                color: color.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Lớp học chưa có giảng viên nào',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (int index = 0; index < teachers.length; index++) ...[
            if (index > 0) const Divider(height: 1, indent: 70),
            _buildTeacherItem(context, teachers[index], color),
          ],
        ],
      ),
    );
  }

  // Widget hiển thị một giảng viên
  Widget _buildTeacherItem(
      BuildContext context, TeacherInfo teacher, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        radius: 24,
        child: Text(
          teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      title: Text(
        teacher.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.badge_outlined,
                  size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                'Mã GV: ${teacher.teacherCode}',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.email_outlined,
                  size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                teacher.email,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.email_outlined, color: color),
          onPressed: () {
            // Triển khai chức năng gửi email nếu cần
          },
          tooltip: 'Gửi email',
        ),
      ),
    );
  }

  // Widget hiển thị danh sách sinh viên
  Widget _buildStudentsList(
      BuildContext context, List<StudentInfo> students, Color color) {
    if (students.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: color.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Lớp học chưa có sinh viên nào',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (int index = 0; index < students.length; index++) ...[
            if (index > 0) const Divider(height: 1, indent: 70),
            _buildStudentItem(context, students[index], color),
          ],
        ],
      ),
    );
  }

  // Widget hiển thị một sinh viên
  Widget _buildStudentItem(
      BuildContext context, StudentInfo student, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.2),
        radius: 24,
        child: Text(
          student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      title: Text(
        student.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.badge_outlined,
                  size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                'Mã SV: ${student.studentCode}',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.email_outlined,
                  size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                student.email,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
