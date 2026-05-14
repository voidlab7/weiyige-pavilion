# P0-1: CLI 全覆盖 state 写操作

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：95（最高）
> 难度：中 | 预估：60min
> 依赖：无
> 状态：待执行

---

## 问题

Agent 可以绕过 CLI 直接 `write_to_file` 修改 state.json，导致协议遵从全靠自觉。finish 后的 done yaml 写入、progress 更新仍未 100% CLI 覆盖。

## 目标

Agent 没有任何理由直接 write_to_file state.json/progress-board.md，所有状态写操作必须走 CLI。

## 方案

1. 审计 `weiyige-cli.mjs` 中所有 state.json / progress-board.md 的写操作路径
2. 确保 init-task / update-phase / finish-task 完全覆盖所有状态写入场景
3. finish-task 中增加自动将 `queue/*.yaml` 移到 `done/` 的逻辑
4. 所有角色 IDENTITY.md 增加强制约束：「禁止直接 write_to_file state.json，必须走 CLI」
5. 添加 `validate` 子命令作为写入前置校验
6. 补充单元测试覆盖 CLI 写操作路径

## 验收标准

- [ ] state.json 所有写入路径均通过 CLI
- [ ] finish-task 自动移动 queue yaml 到 done/
- [ ] 角色 IDENTITY.md 含「禁止手动写 state.json」指令
- [ ] validate 子命令可用

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`
- `ai-workspace/queue/P0-1-cli-state-write-guard.yaml`
- 13 个角色 IDENTITY.md
