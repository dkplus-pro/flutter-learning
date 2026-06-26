import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_01_hello_flutter/main.dart';

void main() {
  testWidgets('renders the first Flutter screen', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson01App());

    expect(find.text('01｜Hello Flutter'), findsOneWidget);
    expect(find.text('你好，Flutter'), findsOneWidget);
    expect(find.text('用 Widget 树声明 UI，就像用组件树描述前端页面。'), findsOneWidget);
  });
}
