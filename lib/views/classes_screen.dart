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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Consumer<ClassProvider>(
        builder: (context, classProvider, child) {
          if (classProvider.status == ClassLoadingStatus.loading ||
              classProvider.status == ClassLoadingStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (classProvider.status == ClassLoadingStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Không thể tải danh sách lớp học',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    classProvider.errorMessage,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => classProvider.fetchMyClasses(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
    if (classProvider.classes.isEmpty) {
      return SliverFillRemaining(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 70,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Bạn chưa tham gia lớp học nào',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Tham gia lớp học để xem thông tin chi tiết và thời khóa biểu của lớp',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Card(
              elevation: 2,
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.format_list_numbered,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng số lớp học',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        Text(
                          '${classProvider.classes.length} lớp',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Title for the class list
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.class_,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Danh sách lớp học',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),

          // List of classes
          ...List.generate(
            classProvider.classes.length,
            (index) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ClassListItem(classInfo: classProvider.classes[index]),
            ),
          ),

          // Add some space at the bottom
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
