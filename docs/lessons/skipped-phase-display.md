# skipped 阶段进度条显示 Bug

> Dashboard 进度条不认 skipped 状态。

---

## 现象

Dashboard 卡片显示 `开发 0/6`，但实际 state.json 中 01-03 阶段都是 `skipped`（需求/设计已有，直接跳过）。进度条前 3 段灰色（pending），应该是绿色。

## 根因

`health-checker.js` 只统计 `status === 'completed'` 的阶段：

```js
const completed = phases.filter(([_, v]) => v.status === 'completed').length;
```

`skipped` 不在统计范围内 → completed = 0 → 显示 `0/6`。

同时，`phasesDetail` 中 `skipped` 状态未映射为 `done`，进度条渲染时当作 pending 处理。

## 修复（3 处）

1. `health-checker.js`：`phaseProgress` 统计加入 `|| v.status === 'skipped'`
2. `health-checker.js`：`phasesDetail` 中 `skipped` 映射为 `done`
3. `app.js`：前端 `pd.status === 'done'` 渲染为绿色

## 教训

状态枚举增加新值时，必须检查所有消费方：
- 计算逻辑（统计、进度）
- 数据转换（状态映射）
- 前端渲染（CSS class）
