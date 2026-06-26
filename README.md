# Flutter Learning：前端架构师从零学 Flutter

这是一套面向 **7 年经验前端架构师** 的 Flutter 递进课程。课程默认你熟悉浏览器端工程、组件化、状态管理、路由、异步数据与测试，但从 Flutter/Dart 零基础开始。

## 课程结构

| 课次 | 主题 | 独立 Demo |
| --- | --- | --- |
| 01 | Flutter 心智模型与第一个界面 | `demos/lesson_01_hello_flutter` |
| 02 | 布局、约束与组件化 | `demos/lesson_02_layout_composition` |
| 03 | 交互与局部状态 | `demos/lesson_03_state_interaction` |
| 04 | 导航、页面拆分与信息架构 | `demos/lesson_04_navigation` |
| 05 | 异步数据、Repository 与错误态 | `demos/lesson_05_async_repository` |
| 06 | 应用状态、测试与工程化收束 | `demos/lesson_06_architecture_testing` |

## 如何学习

1. 先读 [`docs/course.md`](docs/course.md) 了解路线图。
2. 每一课先读 `docs/lessons/XX-*.md`，再进入对应 `demos/lesson_*` 运行。
3. 每个 demo 都是独立 Flutter app：进入目录后执行 `flutter pub get`、`flutter run`、`flutter test`。

> 当前仓库生成时，本机没有 `flutter` / `dart` 命令；代码按标准 Flutter app 结构编写，并提供 `scripts/verify_structure.py` 做离线结构校验。安装 Flutter SDK 后可直接运行每个 demo。
