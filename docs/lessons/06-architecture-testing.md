# 06｜应用状态、测试与工程化收束

## 学习目标

- 用 `ChangeNotifier` 建立轻量 ViewModel/Controller，集中页面事件和派生状态。
- 理解 View、Controller、Model 的职责边界。
- 编写不依赖 UI 的单元测试，以及验证关键交互的 widget test。
- 形成课程结束后的 Flutter 工程化质量门禁。

## 给前端架构师的类比

| Web 前端 | Flutter |
| --- | --- |
| Store/ViewModel | `ChangeNotifier` 控制器 |
| selector / computed | controller getter 派生状态 |
| component test | `testWidgets` |
| unit test | 对 Controller/Repository 直接测试 |
| CI gate | `flutter analyze` + `flutter test` + 结构校验 |

## Demo 运行

```bash
cd demos/lesson_06_architecture_testing
flutter pub get
flutter run
flutter test
```

## 练习

1. 新增一个学习步骤，并补充对应单元测试。
2. 把 `LearningPlanController` 拆到单独文件，观察测试 import 如何变化。
3. 设计一个 CI：根目录先跑结构校验，再逐个 demo 跑 `flutter test`。

## 关键 takeaway

Flutter 架构不是一开始就引入复杂状态库，而是先把职责边界切清楚：Widget 负责渲染，Controller 负责状态和事件，Model 表达业务数据。测试应该锁定这些边界，而不是只验证页面能启动。
