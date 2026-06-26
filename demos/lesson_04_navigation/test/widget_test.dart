import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_04_navigation/main.dart';

void main() {
  testWidgets('navigates from course list to detail page', (WidgetTester tester) async {
    await tester.pumpWidget(const Lesson04App());

    expect(find.text('04｜导航与页面边界'), findsOneWidget);
    expect(find.text('Widget 树'), findsOneWidget);

    await tester.tap(find.text('状态边界'));
    await tester.pumpAndSettle();

    expect(find.text('区分局部状态与应用状态'), findsOneWidget);
    expect(find.text('架构提示：页面之间优先传递稳定、最小的数据对象；复杂状态放到更明确的状态层。'), findsOneWidget);
  });
}
