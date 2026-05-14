# P1-3: 共享知识外置

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：50
> 难度：中 | 预估：60min
> 依赖：P1-1, P1-2
> 状态：待执行

---

## 问题

13 个角色重复加载相同的基础知识（git 命令规范、CodeBuddy 协议、环境变量说明、CLI 使用方法），token 浪费严重。

## 目标

公共知识提取到单一文件，各角色引用而非重复。

## 方案

1. 审计 13 个角色 IDENTITY.md / SOUL.md 中重复出现的内容
2. 提取公共知识到 `.weiyige/SHARED.md`：
   - git 命令规范
   - CodeBuddy 协议
   - 环境变量说明
   - CLI 使用方法
   - 通用工作流（init-task → update-phase → finish-task）
3. 各角色 IDENTITY.md 通过引用替代重复文本（如「详见 SHARED.md §CLI」）
4. LOADER.md 中将 SHARED.md 定义为 L0 共享层
5. 统计精简前后 token 总量对比

## 验收标准

- [ ] SHARED.md 包含所有公共知识
- [ ] 13 个角色 IDENTITY.md 无重复内容
- [ ] 总 token 消耗减少量有明确统计
- [ ] LOADER.md 引用 SHARED.md 为 L0 共享层

## 关联文件

- `.weiyige/SHARED.md`（新建）
- `.weiyige/LOADER.md`
- 13 个角色 IDENTITY.md / SOUL.md
- `ai-workspace/queue/P1-3-shared-knowledge-extract.yaml`
