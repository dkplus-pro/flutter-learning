# 02｜布局、约束与组件化

## 学习目标

- 理解 Flutter 的核心布局规则：父级给约束，子级选尺寸，父级决定位置。
- 掌握 `Row`、`Column`、`Expanded`、`Wrap`、`Card`、`LayoutBuilder` 的基础用法。
- 学会把页面拆成小 Widget，而不是把所有 UI 写进一个 `build()`。
- 从 CSS/Flexbox 迁移到 Flutter 的约束系统。

## 给前端架构师的类比

- `Row` / `Column`：类似只沿一个方向工作的 flex container。
- `Expanded`：类似 `flex: 1`，但前提是父级主轴空间是有界的。
- `LayoutBuilder`：类似根据容器宽度做 component-level responsive，而不是全局 media query。
- `Card` + `Padding`：更像设计系统 primitive 的组合，而不是 CSS class 堆叠。

## Demo 运行

```bash
cd demos/lesson_02_layout_composition
flutter pub get
flutter run
flutter test
```

## 练习

1. 新增一张指标卡，例如“测试覆盖率”。
2. 修改 `LayoutBuilder` 的断点，让窄屏也展示两列。
3. 把 `_MetricCard` 的颜色改为从 `Theme.of(context).colorScheme` 读取。

## 关键 takeaway

Flutter 布局不是 CSS cascade，而是局部、显式、可组合的约束传递。架构上应尽早把页面拆成有命名的 Widget，降低单个 `build()` 的复杂度。
