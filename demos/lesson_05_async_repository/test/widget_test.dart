import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_05_async_repository/main.dart';

void main() {
  testWidgets('renders async success and retryable error states', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson05App());

    expect(find.text('加载课程数据中...'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('FutureBuilder 状态机'), findsOneWidget);
    expect(find.text('Repository 边界'), findsOneWidget);

    await tester.tap(find.text('模拟错误'));
    await tester.pump();
    expect(find.text('加载课程数据中...'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.textContaining('加载失败：Exception: Repository 模拟错误'), findsOneWidget);

    await tester.tap(find.text('重试成功'));
    await tester.pumpAndSettle();
    expect(find.text('重试策略'), findsOneWidget);
  });
}
