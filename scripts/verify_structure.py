#!/usr/bin/env python3
"""Offline structure checker for the Flutter course demos.

It intentionally avoids requiring Flutter SDK so the repository can be checked in
minimal CI or learning environments. When Flutter is installed, run each demo's
`flutter test` for real behavior verification.
"""
from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
LESSONS = [
    "lesson_01_hello_flutter",
    "lesson_02_layout_composition",
    "lesson_03_state_interaction",
    "lesson_04_navigation",
    "lesson_05_async_repository",
    "lesson_06_architecture_testing",
]
REQUIRED_FILES = [
    "README.md",
    "pubspec.yaml",
    "analysis_options.yaml",
    "lib/main.dart",
    "test/widget_test.dart",
]


def assert_contains(path: Path, snippets: list[str]) -> list[str]:
    text = path.read_text(encoding="utf-8")
    return [f"{path.relative_to(ROOT)} missing snippet: {snippet}" for snippet in snippets if snippet not in text]


def main() -> int:
    errors: list[str] = []
    for lesson in LESSONS:
        demo = ROOT / "demos" / lesson
        if not demo.exists():
            errors.append(f"missing demo directory: demos/{lesson}")
            continue
        for relative in REQUIRED_FILES:
            file_path = demo / relative
            if not file_path.exists():
                errors.append(f"missing file: {file_path.relative_to(ROOT)}")
        pubspec = demo / "pubspec.yaml"
        main_dart = demo / "lib" / "main.dart"
        test_dart = demo / "test" / "widget_test.dart"
        if pubspec.exists():
            errors.extend(assert_contains(pubspec, ["sdk: flutter", "uses-material-design: true"]))
        if main_dart.exists():
            errors.extend(assert_contains(main_dart, ["void main()", "runApp", "MaterialApp"]))
        if test_dart.exists():
            errors.extend(assert_contains(test_dart, ["testWidgets", "pumpWidget"]))

    if errors:
        print("Structure verification failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(f"OK: {len(LESSONS)} independent Flutter demo structures are present.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
