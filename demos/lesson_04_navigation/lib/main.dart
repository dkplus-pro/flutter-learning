import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson04App());
}

class Lesson04App extends StatelessWidget {
  const Lesson04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 04 - Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const CourseListPage(),
    );
  }
}

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  static const courses = [
    CourseModule('Widget 树', '理解声明式 UI 与构建上下文', Icons.account_tree),
    CourseModule('布局系统', '掌握约束、尺寸与位置', Icons.dashboard_customize),
    CourseModule('状态边界', '区分局部状态与应用状态', Icons.sync_alt),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('04｜导航与页面边界')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            child: ListTile(
              leading: Icon(course.icon),
              title: Text(course.title),
              subtitle: Text(course.summary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // 小型应用可以直接 push 一个页面；大型应用再抽象路由表/深链策略。
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => CourseDetailPage(course: course)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});

  final CourseModule course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(course.icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(course.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(course.summary),
            const SizedBox(height: 24),
            const Text('架构提示：页面之间优先传递稳定、最小的数据对象；复杂状态放到更明确的状态层。'),
          ],
        ),
      ),
    );
  }
}

class CourseModule {
  const CourseModule(this.title, this.summary, this.icon);

  final String title;
  final String summary;
  final IconData icon;
}
