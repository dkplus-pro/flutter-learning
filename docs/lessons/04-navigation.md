# 04｜导航、页面拆分与信息架构

## 学习目标

- 理解小型 Flutter 应用中 `Navigator` 与 `MaterialPageRoute` 的基本用法。
- 学会把列表页、详情页和领域模型拆开，避免所有页面堆在一个 Widget 中。
- 建立移动端页面栈与 Web SPA 路由的差异认知。
- 练习从信息架构角度设计页面入口、详情与返回路径。

## 给前端架构师的类比

- Web Router 的 URL route table 更强调地址栏同步；Flutter 小应用常从页面栈开始。
- `Navigator.push` 类似进入一个新页面状态；系统返回键/导航栏返回会 pop。
- Route 参数可以先用构造函数传递；复杂场景再抽象路由表、深链或 Router API。

## Demo 运行

```bash
cd demos/lesson_04_navigation
flutter pub get
flutter run
flutter test
```

## 练习

1. 给详情页新增“开始学习”按钮。
2. 在课程列表中新增一个“架构复盘”课程。
3. 思考：如果需要支持 Web URL 深链，当前 Navigator 写法要如何演进？

## 关键 takeaway

导航是信息架构的一部分，不只是页面跳转 API。对于前端架构师，重点是先定义页面边界、数据传递方式与返回路径，再选择 Navigator 或 Router。
