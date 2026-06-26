# 01｜Flutter 心智模型与第一个界面

## 学习目标

- 知道 Flutter app 的入口是 `main()` 与 `runApp()`。
- 理解 `Widget` 是不可变 UI 描述，类似 React/Vue 的 render output。
- 能读懂 `MaterialApp`、`Scaffold`、`AppBar`、`Text`、`Column` 的职责。
- 建立“声明式 UI：状态变化 → 重新描述 UI”的第一层心智模型。

## 给前端架构师的类比

| Web/React/Vue | Flutter |
| --- | --- |
| `createRoot(...).render(<App />)` | `runApp(const App())` |
| Component | Widget |
| DOM tree | Widget tree / Element tree / Render tree |
| CSS reset + design system provider | `MaterialApp` + `ThemeData` |
| Page shell | `Scaffold` |

## Demo 运行

```bash
cd demos/lesson_01_hello_flutter
flutter pub get
flutter run
flutter test
```

## 练习

1. 把页面标题改成你的英文名。
2. 新增一行 `Text`，说明你为什么要学 Flutter。
3. 尝试删除 `const`，观察 IDE/分析器提示，再加回来。

## 关键 takeaway

Flutter 不是把 HTML/CSS 搬到移动端，而是用 Dart 对 UI 进行声明式描述。第一课只需要掌握入口、Widget 树与基础页面骨架。
