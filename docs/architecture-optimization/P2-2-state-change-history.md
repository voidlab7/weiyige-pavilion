# P2-2: 状态变更历史记录

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：70
> 难度：中 | 预估：45min
> 依赖：P0-2
> 状态：待执行

---

## 问题

update-phase 无审计日志，出问题无法追溯「谁在什么时间改了什么」。

## 目标

每次状态变更自动记录 diff，支持事后追溯。

## 方案

1. update-phase 执行时，记录变更前后 diff 到 `ai-workspace/{task-id}/history/{timestamp}.json`
2. JSON 格式：
   ```json
   {
     "timestamp": "2026-05-12T20:30:00Z",
     "agent": "矩/ju-architect",
     "action": "update-phase",
     "before": { "phase": "design", ... },
     "after": { "phase": "implementation", ... }
   }
   ```
3. 提供 `weiyige-cli history {task-id}` 子命令查看变更历史
4. history 目录不参与 sync，仅本地保留

## 验收标准

- [ ] 每次 update-phase 产生一条 history 记录
- [ ] `weiyige-cli history` 可读取并展示
- [ ] history JSON 格式完整可解析
- [ ] history 目录不被 sync 覆盖

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`
- `ai-workspace/queue/P2-2-state-change-history.yaml`
