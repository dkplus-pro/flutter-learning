import tempfile
import unittest
from pathlib import Path

from tools.validate_course import validate_course


VALID_MAIN_DART = """import 'package:flutter/material.dart';

// 学习点：用最小 Widget 树连接前端组件思维和 Flutter 声明式 UI。
void main() {
  runApp(const LessonApp());
}

class LessonApp extends StatelessWidget {
  const LessonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Text('你好 Flutter'));
  }
}
"""

VALID_WIDGET_TEST = """import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lesson_01_flutter_foundations/main.dart';

// 学习点：用 widget test 验证首屏可见文本。
void main() {
  testWidgets('shows greeting text', (tester) async {
    await tester.pumpWidget(const LessonApp());
    expect(find.text('你好 Flutter'), findsOneWidget);
  });
}
"""

VALID_PUBSPEC = """name: lesson_01_flutter_foundations
description: Lesson 01 demo for Chinese Flutter course.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
"""


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


class CourseValidatorTest(unittest.TestCase):
    def create_valid_course(self, root: Path) -> None:
        write(root / "README.md", "# Flutter Learning\n\n面向 7 年前端架构师的 Flutter 渐进式课程。\n")
        write(
            root / "docs" / "course_outline.md",
            """# 课程目标\n\n适合人群：7 年前端架构师。\n\n## 学习路径\n\n- lessons/lesson_01_flutter_foundations：从组件化迁移到 Flutter。\n\n## 前端架构师\n\n强调架构迁移、状态管理和工程化。\n""",
        )
        lesson = root / "lessons" / "lesson_01_flutter_foundations"
        write(
            lesson / "README.md",
            """# lesson_01_flutter_foundations\n\n## 学习目标\n理解 Flutter Widget 与前端组件模型的对应关系。\n\n## 前端架构师迁移视角\n比较 React/Vue 声明式 UI 与 Flutter Widget 树。\n\n## 实践步骤\n运行 demo 并阅读注释。\n\n## 验收标准\n能解释 main、runApp、StatelessWidget 的职责。\n""",
        )
        write(lesson / "demo" / "pubspec.yaml", VALID_PUBSPEC)
        write(lesson / "demo" / "lib" / "main.dart", VALID_MAIN_DART)
        write(lesson / "demo" / "test" / "widget_test.dart", VALID_WIDGET_TEST)

    def test_valid_course_fixture_passes(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.create_valid_course(root)
            report = validate_course(root)
            self.assertTrue(report.ok, report.errors)
            self.assertEqual(report.lessons, ["lesson_01_flutter_foundations"])

    def test_missing_demo_test_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.create_valid_course(root)
            (root / "lessons" / "lesson_01_flutter_foundations" / "demo" / "test" / "widget_test.dart").unlink()
            report = validate_course(root)
            self.assertFalse(report.ok)
            self.assertTrue(any("widget_test.dart" in error for error in report.errors))

    def test_non_contiguous_lesson_numbers_are_reported(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.create_valid_course(root)
            original = root / "lessons" / "lesson_01_flutter_foundations"
            renamed = root / "lessons" / "lesson_02_flutter_foundations"
            original.rename(renamed)
            report = validate_course(root)
            self.assertFalse(report.ok)
            self.assertTrue(any("contiguous" in error for error in report.errors))

    def test_uncommented_dart_source_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.create_valid_course(root)
            main_path = root / "lessons" / "lesson_01_flutter_foundations" / "demo" / "lib" / "main.dart"
            main_path.write_text(VALID_MAIN_DART.replace("// 学习点：用最小 Widget 树连接前端组件思维和 Flutter 声明式 UI。\n", ""), encoding="utf-8")
            report = validate_course(root)
            self.assertFalse(report.ok)
            self.assertTrue(any("comments" in error for error in report.errors))


if __name__ == "__main__":
    unittest.main()
