# P1-2: 分级加载协议（LOADER.md）

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：65
> 难度：高 | 预估：60min
> 依赖：P1-1
> 状态：待执行

---

## 问题

角色激活时一次性加载所有文档（IDENTITY + 协议 + 规则），上下文浪费严重，尤其在小任务场景。

## 目标

引入分级加载策略，角色首次激活仅加载核心指令，详细内容按需触发。

## 方案

1. 创建 `.weiyige/LOADER.md`，定义加载策略：
   - **L0**（必加载）：IDENTITY.md 核心指令（< 500 token）
   - **L1**（按需）：SOUL.md 方法论、PROTOCOL.md 协议
   - **L2**（深度）：领域知识、历史经验、MEMORY.md
2. 角色首次激活仅加载 L0
3. 提供触发词加载更高层级：
   - `/load detail` 或 `@soul` → 加载 L1
   - `/load deep` → 加载 L2
4. ROUTER.md 中补充加载层级说明

## 验收标准

- [ ] LOADER.md 定义清晰的三级加载策略
- [ ] 角色激活 token 消耗减少 50%+
- [ ] `/load detail` 触发词正常工作
- [ ] ROUTER.md 含加载层级说明

## 关联文件

- `.weiyige/LOADER.md`（新建）
- `.weiyige/ROUTER.md`
- `ai-workspace/queue/P1-2-lazy-load-protocol.yaml`
