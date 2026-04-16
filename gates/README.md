# 阶段门禁清单（Gate Checklists）

> 来源：[GSLB CodeBuddy 工作流](gslb-devepos-ai-results/) — 审核引擎与流程检查分离设计
> 
> 每个阶段有独立的门禁清单，审查时**逐条勾选**。
> 门禁清单只含**流程完成度检查**，产物质量评审由 `rules/review-scoring.md` 的多维度评分负责。
> 审查入口强制指令见 `review-reminder.md`。

| 文件 | 阶段 | 审查方 |
|------|------|--------|
| `gate-01-ideation.md` | 构思 | 锋 |
| `gate-02-requirement.md` | 需求定义 | 锋（审批枢的 PRD） |
| `gate-03-design.md` | 设计 | 枢（协调矩+绘） |
| `gate-04-development.md` | 开发 | 矩 |
| `gate-05-testing.md` | 测试 | 枢（协调鉴+盾） |
| `gate-06-release.md` | 发布 | 枢 |
| `review-reminder.md` | **所有审查** | **审核入口强制指令** |
