import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson03App());
}

class Lesson03App extends StatelessWidget {
  const Lesson03App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 03 - State',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true),
      home: const LearningTasksPage(),
    );
  }
}

class LearningTasksPage extends StatefulWidget {
  const LearningTasksPage({super.key});

  @override
  State<LearningTasksPage> createState() => _LearningTasksPageState();
}

class _LearningTasksPageState extends State<LearningTasksPage> {
  final TextEditingController _controller = TextEditingController();
  final List<LearningTask> _tasks = [
    LearningTask('理解 Widget 与 Element 的关系'),
    LearningTask('手写一个 StatefulWidget'),
  ];

  @override
  void dispose() {
    // TextEditingController 持有平台输入资源；类似前端 effect cleanup，必须释放。
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.add(LearningTask(text));
      _controller.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((task) => task.isDone).length;
    return Scaffold(
      appBar: AppBar(title: const Text('03｜交互与状态')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('学习任务清单', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('已完成 $doneCount / ${_tasks.length}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: '新增学习任务', border: OutlineInputBorder()),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(onPressed: _addTask, child: const Text('添加')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _tasks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return CheckboxListTile(
                    value: task.isDone,
                    onChanged: (_) => _toggleTask(index),
                    title: Text(task.title),
                    subtitle: Text(task.isDone ? '状态：已完成' : '状态：进行中'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LearningTask {
  const LearningTask(this.title, {this.isDone = false});

  final String title;
  final bool isDone;

  LearningTask copyWith({String? title, bool? isDone}) {
    return LearningTask(title ?? this.title, isDone: isDone ?? this.isDone);
  }
}
