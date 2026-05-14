# P1-1: 角色 IDENTITY.md 精简至 < 500 token

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：80
> 难度：中 | 预估：60min
> 依赖：无
> 状态：待执行

---

## 问题

13 个角色 IDENTITY.md 内容过长，首次激活浪费大量上下文窗口。冗余描述挤占了实际工作的 token 预算。

## 目标

每个角色 IDENTITY.md 核心指令 < 500 token，详细方法论按需加载。

## 方案

1. 统计当前 13 个角色 IDENTITY.md 的 token 数（记录基线）
2. 每个角色提取 TOP3 核心指令保留在 IDENTITY.md（< 500 token）
3. 详细方法论、工作流程、历史背景剥离到同目录 `SOUL.md`
4. 确保精简后角色行为不退化（保留关键触发词和约束）
5. 跑 `sync-weiyige.sh` 同步到所有项目验证

## 验收标准

- [ ] 13 个角色 IDENTITY.md 均 < 500 token
- [ ] 每个角色目录下有 SOUL.md 包含完整方法论
- [ ] sync 后各项目 .weiyige/ 内容正确
- [ ] 精简前后 token 统计对比表

## 关联文件

- 13 个角色目录下的 IDENTITY.md
- `weiyige-ops/sync-weiyige.sh`
- `ai-workspace/queue/P1-1-identity-slim.yaml`
