import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_06_architecture_testing/main.dart';

void main() {
  test('controller toggles steps and exposes derived progress', () {
    final controller = LearningPlanController(const [
      LearningStep('A', 'first'),
      LearningStep('B', 'second'),
    ]);

    expect(controller.summaryText, '已完成 0 / 2');
    expect(controller.progress, 0);

    controller.toggle(0);

    expect(controller.steps.first.isDone, isTrue);
    expect(controller.summaryText, '已完成 1 / 2');
    expect(controller.progress, 0.5);
  });

  testWidgets('renders learning plan and updates after interaction', (WidgetTester tester) async {
    final controller = LearningPlanController.seeded();

    await tester.pumpWidget(Lesson06AppForTest(controller: controller));

    expect(find.text('06｜架构与测试'), findsOneWidget);
    expect(find.text('已完成 0 / 3'), findsOneWidget);
    expect(find.text('跑通 demo'), findsOneWidget);

    await tester.tap(find.text('补测试'));
    await tester.pump();

    expect(find.text('已完成 1 / 3'), findsOneWidget);
  });
}

class Lesson06AppForTest extends StatelessWidget {
  const Lesson06AppForTest({super.key, required this.controller});

  final LearningPlanController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LearningPlanPage(controller: controller));
  }
}
