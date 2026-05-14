# ADR-004: CodeBuddy 双入口

### 状态
已采纳

### 日期
2026-05-14

### 背景

CodeBuddy 加载 `AGENTS.md`（只是花名册索引），不加载 `CLAUDE.md`（路由中枢 + 强制规则）。`.codebuddy/rules/` 为空——CodeBuddy 会话中没有任何维弈阁强制规则被注入。

### 决策

双入口策略：
1. **`CODEBUDDY.md`**（68 行铁律）：CodeBuddy 优先加载，替代 AGENTS.md
2. **`.codebuddy/rules/weiyige-core/RULE.mdc`**（`alwaysApply: true`）：每次会话自动注入 CLI 规范

CodeBuddy 官方文档依据：
- 项目根目录 `CODEBUDDY.md` 存在时，优先加载它（而非 `AGENTS.md`）
- `.codebuddy/rules/` 中 `alwaysApply: true` 的规则每次会话自动注入

### 替代方案

1. **只用 AGENTS.md**：把规则写进 AGENTS.md。放弃原因：AGENTS.md 定位是花名册，塞规则会让它变得冗长。
2. **只用 rules/**：不创建 CODEBUDDY.md。放弃原因：rules 注入的内容不包含路由表，AI 不知道怎么分发。

### 后果

- ✅ CodeBuddy 每次会话都有铁律注入
- ✅ 路由表 + 强制规则分离（CODEBUDDY.md 管路由，rules 管强制约束）
- ✅ 与 Claude Code 的 CLAUDE.md 对称
- ⚠️ 两个入口文件需要保持一致（CODEBUDDY.md 和 CLAUDE.md 的铁律部分）

### 相关

- `lessons/LLM遗忘bug.md`
