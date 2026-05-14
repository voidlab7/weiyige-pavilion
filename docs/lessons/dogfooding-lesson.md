# Dogfooding 教训

> 开发 weiyige 自己也要走 weiyige 流程。

---

## 现象

开发 weiyige-cli 模块化拆分时，直接动手写代码，没走 `init-task → update-phase → finish-task` 流程。用户质疑："为什么开发 weiyige 本身也不按 weiyige 流程来？"

## 根因

惯性——"这是内部工具改动，不需要走流程"。但这恰恰是最需要 dogfooding 的场景。

## 改正

从拆分任务开始，全程走标准流程：
1. `add-queue`（入队）
2. `init-task`（初始化）
3. 矩·架构设计 → `gate` → `handoff`
4. 铸·开发 → 左移检查 → `gate` → `handoff`
5. 鉴·QA → 13 项回归 → `gate` → `handoff`
6. `finish-task`（完成）

## 教训

1. **Dogfooding 是信任的来源**：自己不用自己的工具 = 工具不值得信任
2. **流程发现 bug**：`finish-task` 因 running/ 残留阻塞的问题，就是在 dogfooding 中发现的
3. **所有项目一视同仁**：weiyige-ops 自身也注册在 registry.json 中，也被 sync 和 health-check 覆盖
