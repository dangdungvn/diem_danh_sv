import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';
import '../widgets/classes/class_list_item.dart';
import '../widgets/app_bar/classes_app_bar.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ClassProvider>(context, listen: false).fetchMyClasses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ClassProvider>(
        builder: (context, classProvider, child) {
          return CustomScrollView(
            slivers: [
              const ClassesAppBar(),
              _buildContent(classProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ClassProvider classProvider) {
    switch (classProvider.status) {
      case ClassLoadingStatus.loading:
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );

      case ClassLoadingStatus.error:
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text('Đã xảy ra lỗi: ${classProvider.errorMessage}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => classProvider.fetchMyClasses(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );

      case ClassLoadingStatus.loaded:
        if (classProvider.classes.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Bạn chưa tham gia lớp học nào'),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final classInfo = classProvider.classes[index];
                return ClassListItem(classInfo: classInfo);
              },
              childCount: classProvider.classes.length,
            ),
          ),
        );

      case ClassLoadingStatus.initial:
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
    }
  }
}
