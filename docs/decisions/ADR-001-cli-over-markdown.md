# ADR-001: 用 CLI 替代 Markdown 约束

### 状态
已采纳

### 日期
2026-05-14

### 背景

维弈阁最初用 Markdown 文档约束 AI 行为——"禁止直接写 state.json""交接块必填""门禁不可跳过"。但 AI 是概率模型，协议越长越容易被忽略。实际运行中：
- 交接块经常被跳过
- state.json 忘记更新
- 门禁变成 AI 自己审自己

根因：**靠"口头约定"让 AI 自律 = 让学生自己判卷**。

### 决策

创建 `weiyige-cli`，把关键规则从 Markdown 文字变成可执行代码：
- 状态写入由 CLI 管理（`init-task`、`update-phase`、`finish-task`）
- 交接由 CLI 原子执行（`handoff`，验证产物 + 写日志）
- 门禁由 CLI 检查（`gate`，确定性验证）
- 每次命令自动同步 `project-status.json`

### 替代方案

1. **更强的 Markdown 规则**：在规则中反复强调"必须""不可跳过"。放弃原因：实测无效，AI 对 200 行之后的规则遵从度显著下降。
2. **文件系统 watcher**：监控 state.json 写入并校验。放弃原因：实现复杂，跨平台兼容性差。

### 后果

- ✅ 状态更新不可能漏（CLI 自动写）
- ✅ 产物验证确定性（`fs.existsSync`）
- ✅ ops 同步成为命令副产品（不是 AI 的责任）
- ⚠️ CLI 不能替代 Layer 1 语义审查（PRD 写得好不好仍需 AI 判断）
- ⚠️ AI 需要学会调用 CLI 命令（学习成本）

### 相关

- `protocols/state-management.md`
- `cli/cli-reference.md`
