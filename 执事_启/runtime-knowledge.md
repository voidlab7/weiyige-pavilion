# 运行时知识（Runtime Knowledge）

> 不等项目结束事后沉淀，在执行过程中实时积累知识。

## 存储位置

```
ai-workspace/{task_id}/runtime-knowledge/
├── patterns.json            # 代码/API 使用模式
├── fix-patterns.json        # 修复策略、编译错误解法
├── architecture-decisions.json  # 架构决策记录
└── cross-stage-hints.json   # 跨阶段提示
```

## 写入规则

| 阶段 | 谁写 | 写什么 | 写到哪里 |
|------|------|--------|---------|
| 01-构思 | 锋/砺/隐 | 关键约束、战略方向 | cross-stage-hints.json |
| 02-需求 | 枢 | 用户画像洞察、需求优先级理由 | cross-stage-hints.json |
| 03-设计 | 矩 | 架构决策（选型理由、trade-off） | architecture-decisions.json |
| 04-开发 | 铸 | 编译陷阱、API 弃用、环境坑 | fix-patterns.json, patterns.json |
| 05-测试 | 鉴 | 容易漏测的场景、边界值 | cross-stage-hints.json |
| 06-发布 | 启 | 整理 runtime-knowledge → 永久 memory/ | 清空，转移 |

## JSON 条目格式

```json
{
  "id": "rk-001",
  "discovered_at": "2026-04-25T01:00:00+08:00",
  "source_stage": "04-development",
  "source_agent": "铸·开发",
  "type": "fix-pattern",
  "content": "含非平凡成员的 struct 必须在 .cc 中 = default 构造/析构",
  "reuse_count": 0
}
```

## 读取规则

- 每个 Agent 被唤醒时，Leader 在唤醒消息中附带 `cross-stage-hints.json` 的关键条目
- 铸被唤醒时额外附带 `fix-patterns.json` 和 `patterns.json`
- 项目完成后（06-发布），启将有价值的 runtime-knowledge 转入 `.weiyige/[角色]/memory/`
