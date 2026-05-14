# 维弈阁架构优化需求计划

> 来源：[设计方案/weiyige-architecture-analysis.md](../设计方案/weiyige-architecture-analysis.md)
> 创建时间：2026-05-12
> 共 11 个需求，分 3 个阶段执行

---

## 执行顺序

```
阶段一（协议强制化）：P0-1 → P0-2 → P0-3 → P2-1
阶段二（上下文优化）：P1-1 → P1-2 → P1-3
阶段三（多平台+审计）：P3-1 → P3-2 → P2-2 → P2-3
```

## 需求索引

| 优先级 | ID | 任务 | 难度 | 依赖 | 文档 |
|--------|-----|------|------|------|------|
| 95 | P0-1 | CLI 全覆盖 state 写操作 | 中 | — | [详情](architecture-optimization/P0-1-cli-state-write-guard.md) |
| 93 | P0-2 | 添加状态校验 hook | 中 | P0-1 | [详情](architecture-optimization/P0-2-state-validation-hook.md) |
| 91 | P0-3 | finish-task 强制检查 | 低 | P0-1 | [详情](architecture-optimization/P0-3-finish-task-enforce.md) |
| 85 | P2-1 | finish-task 自动 git commit | 低 | P0-3 | [详情](architecture-optimization/P2-1-auto-git-commit.md) |
| 80 | P1-1 | 角色 IDENTITY.md 精简 < 500 token | 中 | — | [详情](architecture-optimization/P1-1-identity-slim.md) |
| 75 | P3-1 | CLI 环境自适应 | 低 | — | [详情](architecture-optimization/P3-1-cli-env-adaptive.md) |
| 70 | P2-2 | 状态变更历史记录 | 中 | P0-2 | [详情](architecture-optimization/P2-2-state-change-history.md) |
| 65 | P1-2 | 分级加载协议 | 高 | P1-1 | [详情](architecture-optimization/P1-2-lazy-load-protocol.md) |
| 60 | P3-2 | hook 平台分支 | 中 | P3-1 | [详情](architecture-optimization/P3-2-hook-platform-branch.md) |
| 55 | P2-3 | health-checker 快照与回退 | 中 | P2-2 | [详情](architecture-optimization/P2-3-health-snapshot.md) |
| 50 | P1-3 | 共享知识外置 | 中 | P1-1,P1-2 | [详情](architecture-optimization/P1-3-shared-knowledge-extract.md) |
