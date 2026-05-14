# P3-2: hook 平台分支

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：60
> 难度：中 | 预估：45min
> 依赖：P3-1
> 状态：待执行

---

## 问题

心跳脚本不区分平台，跨平台运行可能路径异常、写入失败。

## 目标

hooks/ 下的脚本根据平台自动适配，统一输出格式。

## 方案

1. `hooks/` 下的心跳脚本根据检测到的平台（CodeBuddy / Claude Code / OpenClaw）执行不同逻辑
2. 统一写入 `session-state/` 目录，格式一致
3. 提供平台检测函数供其他脚本复用（复用 P3-1 的检测逻辑）
4. 如果平台不可识别，写 warning 日志但不中断

## 验收标准

- [ ] 三种平台心跳脚本正常运行
- [ ] session-state/ 输出格式统一
- [ ] 未知平台有降级处理（warning 日志）
- [ ] 平台检测函数可复用

## 关联文件

- `weiyige-ops/hooks/`
- `weiyige-ops/session-state/`
- `ai-workspace/queue/P3-2-hook-platform-branch.yaml`
