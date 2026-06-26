# 环境准备

## 1. 安装 Flutter SDK

参考官方文档：<https://docs.flutter.dev/get-started/install>

安装后确认：

```bash
flutter --version
flutter doctor
```

## 2. 运行任意课程 demo

```bash
cd demos/lesson_01_hello_flutter
flutter pub get
flutter run
flutter test
```

如果 demo 目录缺少某个平台目录（例如 `web/`、`android/`），可以在 demo 目录执行：

```bash
flutter create .
```

该命令会补齐平台壳工程，不会改变本课程重点关注的 `lib/` 与 `test/` 代码。

## 3. 仓库离线校验

没有 Flutter SDK 时，可在仓库根目录执行：

```bash
python3 scripts/verify_structure.py
```

它会检查每课 demo 是否包含 `pubspec.yaml`、`lib/main.dart`、`test/widget_test.dart` 与课程 README。
