# 03｜交互与局部状态

## 学习目标

- 理解 `StatefulWidget` 与 `State` 的分工：配置不可变，状态可变。
- 掌握 `setState()` 的基本使用边界。
- 用 `TextEditingController` 读取输入，并在 `dispose()` 中释放资源。
- 区分局部 UI 状态与需要提升/共享的应用状态。

## 给前端架构师的类比

| Web 前端 | Flutter |
| --- | --- |
| `useState` / Vue `ref` | `State<T>` 字段 + `setState()` |
| controlled input | `TextEditingController` |
| component unmount cleanup | `dispose()` |
| derived UI | 在 `build()` 中从状态派生 Widget |

## Demo 运行

```bash
cd demos/lesson_03_state_interaction
flutter pub get
flutter run
flutter test
```

## 练习

1. 新增“删除任务”按钮。
2. 把已完成任务显示为灰色。
3. 思考：如果多个页面都要读任务列表，当前状态应该放在哪里？

## 关键 takeaway

`setState()` 适合页面内部、生命周期短、无需跨页面共享的状态。当前端架构师看到状态开始跨组件传播时，就应该考虑 ViewModel、Repository 或更明确的状态边界。
