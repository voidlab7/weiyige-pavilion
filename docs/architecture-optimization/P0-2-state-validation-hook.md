# P0-2: 添加状态校验 hook

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：93
> 难度：中 | 预估：45min
> 依赖：P0-1
> 状态：待执行

---

## 问题

state.json 缺乏结构校验，错误数据（非法 phase、缺失字段、格式错误）可静默写入，后续流程基于脏数据运行。

## 目标

写 state.json 前必须通过结构校验，不合规直接拒绝写入。

## 方案

1. 实现 `weiyige-cli validate` 子命令
2. 校验规则：
   - phase 枚举值合法（init / planning / design / implementation / testing / review / done）
   - required 字段非空（task_id, project, agent, phase）
   - agent 角色名在允许列表内（13 个角色）
   - timestamps 格式正确（ISO 8601）
3. 在 update-phase / finish-task 内部自动调用 validate，校验失败则拒绝执行并输出原因
4. 可选：用 JSON Schema 定义 state.json 结构约束

## 验收标准

- [ ] `weiyige-cli validate` 可独立运行并输出校验结果
- [ ] update-phase 写入前自动校验
- [ ] 校验失败时明确提示哪个字段不合规
- [ ] JSON Schema 文件存在（可选）

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`
- `ai-workspace/queue/P0-2-state-validation-hook.yaml`
