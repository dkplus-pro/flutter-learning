import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_02_layout_composition/main.dart';

void main() {
  testWidgets('renders architecture dashboard metrics', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson02App());

    expect(find.text('02｜布局与组件化'), findsOneWidget);
    expect(find.text('架构指标面板'), findsOneWidget);
    expect(find.text('模块边界'), findsOneWidget);
    expect(find.text('测试策略'), findsOneWidget);
  });
}
