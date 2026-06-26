# 05｜异步数据、Repository 与错误态

## 学习目标

- 理解 Flutter 中 `Future` 驱动 UI 的基本方式。
- 掌握 `FutureBuilder` 的 loading、success、error 分支。
- 用 Repository 隔离数据来源，让 UI 不直接关心网络、缓存或 mock。
- 训练“状态显式建模”：加载中、成功、失败、重试。

## 给前端架构师的类比

| Web 前端 | Flutter |
| --- | --- |
| fetch / Promise | `Future<T>` |
| React Query/SWR 的 loading/error/data | `AsyncSnapshot` 分支 |
| API client / service | Repository |
| retry button | 重新创建 Future 并触发 rebuild |

## Demo 运行

```bash
cd demos/lesson_05_async_repository
flutter pub get
flutter run
flutter test
```

## 练习

1. 把 fake repository 改成返回空列表，并设计 empty state。
2. 给每条数据增加标签字段，并在 UI 上展示。
3. 思考：真实网络请求、缓存、本地数据库分别应该放在哪一层？

## 关键 takeaway

异步 UI 的质量不在于“能请求成功”，而在于是否清晰覆盖 loading、error、empty、retry。Repository 是前端架构师熟悉的边界思想在 Flutter 中的直接落点。
