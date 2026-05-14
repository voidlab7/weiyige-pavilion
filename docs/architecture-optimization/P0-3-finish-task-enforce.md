# P0-3: finish-task 强制检查

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：91
> 难度：低 | 预估：30min
> 依赖：P0-1
> 状态：待执行

---

## 问题

finish-task 不检查前置条件，可能在 phase 未完成、running/ 未清空时被调用，导致状态不一致。

## 目标

finish-task 执行前必须通过所有前置检查，否则拒绝完成。

## 方案

1. 前置检查：当前 phase 标记为 completed
2. 检查 `running/` 目录已清空（无残留文件）
3. 自动将 `queue/` 中对应任务 yaml 移到 `done/`
4. 任一检查失败则拒绝完成并输出缺失项

## 验收标准

- [ ] 前置检查全部通过才允许执行
- [ ] 检查失败有明确报错信息
- [ ] running/ 残留文件被正确处理
- [ ] queue yaml 自动移入 done/

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`（finish-task 逻辑）
- `weiyige-ops/finish-task.sh`
- `ai-workspace/queue/P0-3-finish-task-enforce.yaml`
