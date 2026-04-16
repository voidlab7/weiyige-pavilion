# 规则体系（Rules）

> 版本: v1.0 | 创建: 2026-04-16
> 借鉴: 分层规则设计（全局 + 角色 + 门禁 + Skill 四层）

---

## 规则分层

```
层 1: 全局规则（rules/rules-global.md）     → 所有角色必须遵守
层 2: 角色规则（[角色]/rules/*.mdc）         → 角色专属约束
层 3: 阶段门禁（gates/gate-*.md）           → 阶段完成标准
层 4: 审核评分（rules/review-scoring.md）    → 产物质量评审
```

冲突时取更严格的那个。

## 文件清单

| 文件 | 层级 | 说明 |
|------|------|------|
| `rules/rules-global.md` | 层 1 | 12 条全局规则（W1-W12） |
| `rules/review-scoring.md` | 层 4 | 产物审核多维度评分规范 |
| `架构_矩/rules/eng-review/RULE.mdc` | 层 2 | 工程审查专属规则 |
| `设计_绘/rules/design-review/RULE.mdc` | 层 2 | 设计审查专属规则 |
| `QA_鉴/rules/qa/RULE.mdc` | 层 2 | QA 测试专属规则 |
| `gates/gate-01-ideation.md` | 层 3 | 构思阶段门禁 |
| `gates/gate-02-requirement.md` | 层 3 | 需求定义门禁 |
| `gates/gate-03-design.md` | 层 3 | 设计阶段门禁 |
| `gates/gate-04-development.md` | 层 3 | 开发阶段门禁 |
| `gates/gate-05-testing.md` | 层 3 | 测试阶段门禁 |
| `gates/gate-06-release.md` | 层 3 | 发布阶段门禁 |
| `gates/review-reminder.md` | 层 3+4 | 审核入口强制指令 |
