import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson06App());
}

class Lesson06App extends StatelessWidget {
  const Lesson06App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 06 - Architecture Testing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
      home: LearningPlanPage(controller: LearningPlanController.seeded()),
    );
  }
}

class LearningPlanPage extends StatelessWidget {
  const LearningPlanPage({super.key, required this.controller});

  final LearningPlanController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('06｜架构与测试')),
      body: AnimatedBuilder(
        // AnimatedBuilder 不只服务动画；它也能监听 ChangeNotifier 并重建局部 UI。
        animation: controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flutter 学习计划', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(controller.summaryText),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: controller.progress),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.steps.length,
                    itemBuilder: (context, index) {
                      final step = controller.steps[index];
                      return CheckboxListTile(
                        value: step.isDone,
                        onChanged: (_) => controller.toggle(index),
                        title: Text(step.title),
                        subtitle: Text(step.description),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LearningPlanController extends ChangeNotifier {
  LearningPlanController(List<LearningStep> steps) : _steps = List<LearningStep>.of(steps);

  factory LearningPlanController.seeded() {
    return LearningPlanController(const [
      LearningStep('跑通 demo', '确认每课都能 flutter run'),
      LearningStep('补测试', '为核心交互写 widget test'),
      LearningStep('架构复盘', '记录状态边界与目录约定'),
    ]);
  }

  final List<LearningStep> _steps;

  List<LearningStep> get steps => List<LearningStep>.unmodifiable(_steps);

  int get doneCount => _steps.where((step) => step.isDone).length;

  double get progress => _steps.isEmpty ? 0 : doneCount / _steps.length;

  String get summaryText => '已完成 $doneCount / ${_steps.length}';

  void toggle(int index) {
    if (index < 0 || index >= _steps.length) {
      return;
    }
    final current = _steps[index];
    _steps[index] = current.copyWith(isDone: !current.isDone);
    notifyListeners();
  }
}

class LearningStep {
  const LearningStep(this.title, this.description, {this.isDone = false});

  final String title;
  final String description;
  final bool isDone;

  LearningStep copyWith({String? title, String? description, bool? isDone}) {
    return LearningStep(
      title ?? this.title,
      description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
