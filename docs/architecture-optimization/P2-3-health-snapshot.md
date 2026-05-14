# P2-3: health-checker 快照与回退

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：55
> 难度：中 | 预估：45min
> 依赖：P2-2
> 状态：待执行

---

## 问题

状态文件损坏后无法恢复，只能手动重建，耗时且易遗漏。

## 目标

health-check 自动保存快照，异常时支持一键回退。

## 方案

1. `health-check.sh` 执行时自动保存 ai-workspace/ 快照到 `.snapshots/{timestamp}/`
2. 快照仅保留核心状态文件：state.json + progress-board.md + project-status.json（不含 artifacts）
3. 保留最近 10 个快照，超出自动清理（FIFO）
4. 提供 `weiyige-cli rollback {snapshot-id}` 子命令恢复到指定快照
5. `.snapshots/` 目录加入 .gitignore

## 验收标准

- [ ] health-check 产生快照文件
- [ ] 最多保留 10 个快照，超出自动清理
- [ ] `rollback` 命令可恢复状态
- [ ] `.snapshots/` 已加入 .gitignore

## 关联文件

- `weiyige-ops/health-check.sh`
- `weiyige-ops/bin/weiyige-cli.mjs`
- `ai-workspace/queue/P2-3-health-snapshot.yaml`
