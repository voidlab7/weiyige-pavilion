# 维弈阁共享知识（Weiyige Shared Knowledge）

> 版本: v1.0 | 创建: 2026-05-13 | 状态: 生效中

所有角色的公共规则和模板。角色 SOUL.md 中通过引用（如「详见 SHARED.md §三档模式」）避免重复加载。

---

## §1 三档模式框架

每个角色按此框架定义自身的 Quick / Standard / Deep 模式：

| 模式 | 触发 | 行为 |
|------|------|------|
| **Quick** | `@quick [角色]` 或简单问题 | 最精简回答，< 5 分钟 |
| **Standard** | 默认 | 标准流程，15-30 分钟 |
| **Deep** | `@deep [角色]` 或大版本/全面审查 | 完整深度执行，30+ 分钟 |

**默认模式**：Standard。用户可通过 `@quick`/`@deep` 切换，或由路由器根据任务规模自动选择。

---

## §2 完成前自检（交接前必查）

每个角色完成工作前必须验证：

- [ ] **产出落盘** — 产出文件可通过 `read_file` 读取
- [ ] **交接块就绪** — 交接块已准备（含下游 Agent 建议）
- [ ] **记忆更新** — 有值得记录的经验/教训/发现已写入 `memory/`
- [ ] **范围守护** — 没有越权修改不在方案范围内的文件
- [ ] **计算型检查** — Lint/类型检查/测试等已通过 `execute_command` 实际执行（适用角色：矩、铸、鉴）

---

## §3 职责三分法

每个角色的职责划分为三层：

| 分类 | 含义 |
|------|------|
| **主 Owned** | 该角色独占负责的工作 |
| **协作** | 需要与其他角色配合的工作 |
| **不做** | 明确禁止做的事（越权防线） |

---

## §4 CLI 使用规范

- **禁止直接 `write_to_file` state.json** — 必须走 `weiyige-cli` 命令
- CLI 子命令：`init-task` / `update-phase` / `finish-task` / `validate`
- state.json 写入前自动调用 `validateState`，非法数据拒绝写入
- `finish-task` 前置检查：phase 完成性 + running/ 残留 + queue→done 移动

---

## §5 Git 规范

- 不主动执行 `git push` —— 需用户确认
- 不执行 `git push --force` / `git reset --hard` 等破坏性操作
- `finish-task` 默认自动 `git commit`（可 `--no-commit` 跳过）
- 创建功能分支前必须 `git stash` 无关修改

---

## §6 环境与安全

- 涉及 `git push`、`rm -rf`、SCP 部署 → **不自动执行，提醒用户确认**
- 敏感信息（密码、Token、API Key）不写入代码或 git 仓库
- 服务器操作需确认 IP 地址和目标环境

---

## §7 版本管理元信息格式

所有角色文件的头部使用统一的版本管理格式：

```markdown
<!-- Version: vX.X | Created: YYYY-MM-DD | Updated: YYYY-MM-DD -->
<!-- Changelog: ... -->
```

尾部元信息：

```markdown
**命名由来**：X=...
**团队定位**：...
**核心输出/方法论**：...
```

---

## §8 交接块协议

Agent 之间的信息传递通过交接块（Handoff Block）：

```markdown
## 交接块
- **来源**: [角色名]
- **目标**: [下游角色名]
- **产出路径**: ai-workspace/{task_id}/artifacts/{阶段}/
- **摘要**: [一句话总结]
- **建议下游关注**: [重点事项]
```

---

*共享知识的目标：一处定义，多处引用，消除 13 个角色间的重复加载。*
