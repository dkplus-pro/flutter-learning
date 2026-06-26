#!/usr/bin/env python3
"""Static validator for the Chinese progressive Flutter learning course.

The local environment for this repository may not have Flutter/Dart installed.
This script intentionally validates project structure and source text only, so
course/demo changes can still be checked in CI or by OMX workers before an SDK is
available.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable

CHINESE_RE = re.compile(r"[\u4e00-\u9fff]")
LESSON_DIR_RE = re.compile(r"lesson_(\d{2})_[a-z0-9_]+$")
REQUIRED_LESSON_SECTIONS = (
    "学习目标",
    "前端架构师迁移视角",
    "实践步骤",
    "验收标准",
)


@dataclass
class ValidationReport:
    root: Path
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    lessons: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.errors

    def error(self, path: Path | str, message: str) -> None:
        self.errors.append(f"{self._display(path)}: {message}")

    def warn(self, path: Path | str, message: str) -> None:
        self.warnings.append(f"{self._display(path)}: {message}")

    def _display(self, path: Path | str) -> str:
        candidate = Path(path) if not isinstance(path, Path) else path
        try:
            return str(candidate.resolve().relative_to(self.root.resolve()))
        except ValueError:
            return str(path)

    def as_dict(self) -> dict[str, object]:
        return {
            "ok": self.ok,
            "root": str(self.root),
            "lesson_count": len(self.lessons),
            "lessons": self.lessons,
            "errors": self.errors,
            "warnings": self.warnings,
        }


def read_text(path: Path, report: ValidationReport) -> str:
    if not path.exists():
        report.error(path, "missing required file")
        return ""
    if not path.is_file():
        report.error(path, "expected a file")
        return ""
    return path.read_text(encoding="utf-8")


def has_chinese(text: str) -> bool:
    return bool(CHINESE_RE.search(text))


def require_in_text(
    text: str,
    required: Iterable[str],
    path: Path,
    report: ValidationReport,
    reason: str,
) -> None:
    for token in required:
        if token not in text:
            report.error(path, f"missing {reason}: {token}")


def validate_root_docs(root: Path, report: ValidationReport) -> None:
    readme = read_text(root / "README.md", report)
    if readme:
        require_in_text(readme, ("Flutter", "7 年前端", "课程"), root / "README.md", report, "course positioning text")
        if not has_chinese(readme):
            report.error(root / "README.md", "must contain Chinese course description")

    outline_path = root / "docs" / "course_outline.md"
    outline = read_text(outline_path, report)
    if outline:
        require_in_text(
            outline,
            ("课程目标", "适合人群", "学习路径", "前端架构师"),
            outline_path,
            report,
            "outline section",
        )
        if not has_chinese(outline):
            report.error(outline_path, "must be written primarily for Chinese readers")


def discover_lessons(root: Path, report: ValidationReport) -> list[Path]:
    lessons_root = root / "lessons"
    if not lessons_root.exists():
        report.error(lessons_root, "missing lessons directory")
        return []
    if not lessons_root.is_dir():
        report.error(lessons_root, "expected a directory")
        return []

    lesson_dirs = sorted(path for path in lessons_root.iterdir() if path.is_dir())
    valid: list[Path] = []
    for path in lesson_dirs:
        match = LESSON_DIR_RE.match(path.name)
        if not match:
            report.error(path, "lesson directory must match lesson_XX_slug")
            continue
        valid.append(path)

    if not valid:
        report.error(lessons_root, "must contain at least one lesson_XX_slug directory")
        return []

    numbers = [int(LESSON_DIR_RE.match(path.name).group(1)) for path in valid]  # type: ignore[union-attr]
    expected = list(range(1, len(numbers) + 1))
    if numbers != expected:
        report.error(lessons_root, f"lesson numbers must be contiguous from 01; found {numbers}, expected {expected}")

    report.lessons = [path.name for path in valid]
    return valid


def validate_lesson_docs(lesson: Path, report: ValidationReport) -> None:
    lesson_readme = lesson / "README.md"
    text = read_text(lesson_readme, report)
    if not text:
        return
    if not has_chinese(text):
        report.error(lesson_readme, "lesson guide must contain Chinese explanations")
    require_in_text(text, REQUIRED_LESSON_SECTIONS, lesson_readme, report, "lesson section")
    if lesson.name not in text:
        report.warn(lesson_readme, "consider mentioning the lesson directory id for traceability")


def validate_pubspec(pubspec: Path, report: ValidationReport) -> None:
    text = read_text(pubspec, report)
    if not text:
        return
    require_in_text(
        text,
        ("name:", "environment:", "dependencies:", "flutter:", "sdk: flutter", "dev_dependencies:", "flutter_test:"),
        pubspec,
        report,
        "Flutter pubspec entry",
    )


def validate_dart_source(path: Path, report: ValidationReport, required_tokens: tuple[str, ...]) -> None:
    text = read_text(path, report)
    if not text:
        return
    require_in_text(text, required_tokens, path, report, "Dart token")
    if "//" not in text and "/*" not in text and "///" not in text:
        report.error(path, "Dart source must include comments explaining learning points")
    if text.count("{") != text.count("}"):
        report.error(path, "brace count is unbalanced")
    if text.count("(") != text.count(")"):
        report.error(path, "parenthesis count is unbalanced")


def validate_demo_project(lesson: Path, report: ValidationReport) -> None:
    demo = lesson / "demo"
    if not demo.exists():
        report.error(demo, "missing isolated runnable Flutter demo project")
        return
    if not demo.is_dir():
        report.error(demo, "expected a directory")
        return

    validate_pubspec(demo / "pubspec.yaml", report)
    validate_dart_source(
        demo / "lib" / "main.dart",
        report,
        ("import 'package:flutter/material.dart'", "void main()", "runApp", "StatelessWidget"),
    )
    validate_dart_source(
        demo / "test" / "widget_test.dart",
        report,
        ("import 'package:flutter_test/flutter_test.dart'", "testWidgets", "pumpWidget", "expect"),
    )


def validate_outline_links(root: Path, lessons: list[Path], report: ValidationReport) -> None:
    if not lessons:
        return
    outline_path = root / "docs" / "course_outline.md"
    outline = read_text(outline_path, report)
    if not outline:
        return
    for lesson in lessons:
        if lesson.name not in outline and f"lessons/{lesson.name}" not in outline:
            report.error(outline_path, f"outline does not reference {lesson.name}")


def validate_course(root: Path) -> ValidationReport:
    root = root.resolve()
    report = ValidationReport(root=root)
    validate_root_docs(root, report)
    lessons = discover_lessons(root, report)
    for lesson in lessons:
        validate_lesson_docs(lesson, report)
        validate_demo_project(lesson, report)
    validate_outline_links(root, lessons, report)
    return report


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate the Flutter learning course without requiring Flutter/Dart SDKs.")
    parser.add_argument("root", nargs="?", default=".", help="Repository root to validate")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    report = validate_course(Path(args.root))
    if args.json:
        print(json.dumps(report.as_dict(), ensure_ascii=False, indent=2))
    else:
        status = "PASS" if report.ok else "FAIL"
        print(f"{status}: {report.root}")
        print(f"Lessons: {len(report.lessons)}")
        for warning in report.warnings:
            print(f"WARN: {warning}")
        for error in report.errors:
            print(f"ERROR: {error}")
    return 0 if report.ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
