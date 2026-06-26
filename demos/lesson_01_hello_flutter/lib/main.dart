import 'package:flutter/material.dart';

void main() {
  // runApp 与 Web 里的 createRoot(...).render(...) 类似：
  // 它把最顶层的 Widget 挂到 Flutter 引擎管理的视图上。
  runApp(const Lesson01App());
}

class Lesson01App extends StatelessWidget {
  const Lesson01App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 01 - Hello Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HelloFlutterPage(),
    );
  }
}

class HelloFlutterPage extends StatelessWidget {
  const HelloFlutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold 提供一页 Material Design 应用常见的骨架：顶部栏、内容区、FAB 等。
    return Scaffold(
      appBar: AppBar(title: const Text('01｜Hello Flutter')),
      body: const Center(
        // Column 类似纵向 flex container；mainAxis 是主轴（这里为垂直方向）。
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flutter_dash, size: 72, color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              '你好，Flutter',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('用 Widget 树声明 UI，就像用组件树描述前端页面。'),
          ],
        ),
      ),
    );
  }
}
