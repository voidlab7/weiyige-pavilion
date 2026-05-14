# CLI 变更日志

---

## v2.1 (2026-05-14)

- **fix**: `finish-task` 不再因 running/ 残留而阻塞，自动清理
- **模块化拆分**: 1629 行单文件 → 入口 72 行 + 11 个 lib 模块（最大 164 行）

## v2.0 (2026-05-14)

闭环状态同步：每次 CLI 命令都自动同步 project-status.json → ops dashboard 实时更新。

### 新增命令
- `handoff` — 原子交接（产物验证 + JSONL 日志 + 状态推进 + ops 同步）
- `gate` — Layer 0 确定性门禁检查
- `artifact` — 产物文件验证
- `status` — 项目概况 / 任务详情

### 增强
- `init-task` — 自动写 running/*.lock + ops 同步
- `update-phase` — 阶段依赖检查（不允许跳阶段）+ ops 同步 + progress-board 自动重生成
- `finish-task` — ops 同步

### 新增基础设施
- `syncProjectStatus()` — 通用 ops 同步函数
- `regenerateProgressBoard()` — 看板自动重生成
- `PHASE_LABELS` / `PHASE_STATUS_ICONS` — 阶段标签常量

## v1.0 (2026-05-12)

初始版本。

- `init-task` — 创建任务目录 + state.json
- `update-phase` — 更新阶段状态 + 校验 + 历史记录
- `finish-task` — 完成任务 + 前置检查 + queue→done + git commit
- `validate` — 校验 state.json 结构
- `history` — 查看变更历史
- `snapshots` / `rollback` — 快照管理
- `add-queue` — 任务入队
- `scan-workspace` / `register-project` — 项目扫描与注册
- `cost-report` / `budget-check` — 成本与预算
