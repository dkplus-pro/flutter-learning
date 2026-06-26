import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_03_state_interaction/main.dart';

void main() {
  testWidgets('adds and completes a learning task', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson03App());

    expect(find.text('已完成 0 / 2'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), '练习 setState 边界');
    await tester.tap(find.text('添加'));
    await tester.pump();

    expect(find.text('练习 setState 边界'), findsOneWidget);
    expect(find.text('已完成 0 / 3'), findsOneWidget);

    await tester.tap(find.text('理解 Widget 与 Element 的关系'));
    await tester.pump();

    expect(find.text('已完成 1 / 3'), findsOneWidget);
    expect(find.text('状态：已完成'), findsOneWidget);
  });
}
