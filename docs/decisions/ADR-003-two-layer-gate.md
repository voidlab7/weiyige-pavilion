# ADR-003: 两层门禁

### 状态
已采纳

### 日期
2026-05-14

### 背景

AI 审查产物时"善意推断"——Agent 说"已通过检查"，审查方不验证直接放行。结果：未通过 lint 的代码进入测试阶段，浪费 token。

### 决策

门禁分两层：
1. **Layer 0**（确定性检查，0 token）：文件存在性、lint、格式验证。由 `weiyige-cli gate` 执行。
2. **Layer 1**（AI 语义审查）：多维度评分。由 `artifact-review` Skill 执行。

Layer 0 不通过 → 直接打回，不进 Layer 1。

### 替代方案

1. **纯 AI 审查**：一层门禁，全由 AI 判断。放弃原因：AI 容易善意推断，确定性检查不需要 AI。
2. **纯确定性检查**：不用 AI 审查。放弃原因：无法判断 PRD 写得好不好、架构设计合不合理。

### 后果

- ✅ 确定性问题（文件不存在、lint 不通过）100% 拦截
- ✅ 节省 Layer 1 的 token（Layer 0 FAIL 不进 Layer 1）
- ✅ 关注点分离：代码检查能力归 CLI，语义判断归 AI
- ⚠️ Layer 0 检查项需要手动维护（新阶段需更新 `PHASE_ARTIFACTS` 配置）

### 相关

- `protocols/gate-system.md`
- `gates/two-layer-gate.md`
