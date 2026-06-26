import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson02App());
}

class Lesson02App extends StatelessWidget {
  const Lesson02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 02 - Layout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ArchitectureDashboardPage(),
    );
  }
}

class ArchitectureDashboardPage extends StatelessWidget {
  const ArchitectureDashboardPage({super.key});

  static const metrics = [
    MetricData('模块边界', '6 个 feature', Icons.account_tree),
    MetricData('状态归属', '页面内聚', Icons.hub),
    MetricData('响应式', '窄屏/宽屏', Icons.devices),
    MetricData('测试策略', 'Widget Test', Icons.verified),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('02｜布局与组件化')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // LayoutBuilder 可以读取父容器给当前 Widget 的约束，适合组件级响应式。
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        for (final metric in metrics) _MetricCard(metric: metric),
                      ],
                    ),
                  ),
                  Text(
                    isWide ? '当前是宽屏布局：4 列指标卡' : '当前是窄屏布局：2 列指标卡',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('架构指标面板', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('把页面拆成 Header、MetricCard 等小 Widget，避免 build 方法变成模板泥球。'),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final MetricData metric;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(metric.icon, color: colors.primary),
            const Spacer(),
            Text(metric.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(metric.value, style: TextStyle(color: colors.secondary)),
          ],
        ),
      ),
    );
  }
}

class MetricData {
  const MetricData(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;
}
