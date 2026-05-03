# 维弈阁打包与发布规范（Packaging）

> 版本: v2.1 | 更新: 2026-05-03 | 状态: 生效中

---

## 1. 版本号规范

维弈阁使用语义化版本：`MAJOR.MINOR`。

| 版本段 | 何时增加 | 示例 |
|--------|---------|------|
| MAJOR | 不兼容结构变更（角色增删、协议重构） | 1.x → 2.0 |
| MINOR | 向后兼容增强（新 Skill、新规则、优化） | 2.0 → 2.1 |

当前版本：**v2.1**。

发布时同步更新：

- `PACKAGING.md` 当前版本
- `README.md` 角色数 / Skill 数 / 新功能说明
- `QUICKSTART.md` 顶部版本
- `PROTOCOL.md` / `ROUTER.md` 版本和变更日志
- 安装脚本中的协议文件、Agent 文件、Skills 文件清单

---

## 2. 源文件与安装产物关系

**唯一编辑源**是仓库根目录中的文件；安装目录是生成 / 同步产物。

| 类型 | 源文件 | 安装产物 | 是否应手改安装产物 |
|------|--------|---------|------------------|
| 角色深度定义 | `[Agent]/IDENTITY.md`、`SOUL.md`、`SKILLS.md`、`skills/`、`rules/` | `.weiyige/[Agent]/...` | 否 |
| 协议文件 | `PROTOCOL.md`、`ROUTER.md`、`MEMORY.md`、`QUICKSTART.md`、`PROJECT-CONFIG-SPEC.md`、`PACKAGING.md` | `.weiyige/*.md` | 否 |
| CodeBuddy 适配层 | `agents_for_codebuddy/*.md` | `.codebuddy/agents/*.md` | 否 |
| 共享 Skill | `skills/*/SKILL.md` | `.weiyige/skills/*`、`.codebuddy/skills/*` | 否 |
| Agent 记忆 | `[Agent]/memory/*.md` | `.weiyige/[Agent]/memory/*.md` | 可以由 Agent 运行时写入 |
| 运行时状态 | `ai-workspace/`、`.codebuddy/teams/` | 本地运行生成 | 不纳入发布源 |

规则：

1. 修改 Agent 方法论时，改根目录源文件，不直接改 `.weiyige/`。
2. 修改 CodeBuddy Agent 入口时，改 `agents_for_codebuddy/`，再同步到 `.codebuddy/agents/`。
3. `install.sh --mode update` / `install.ps1 -Mode update` 覆盖核心定义，保留 memory。
4. `.codebuddy/` 是项目数据，不是临时缓存；不要删除。

---

## 3. 安装 / 更新覆盖范围

| 路径 | full 安装 | update 更新 | 说明 |
|------|----------|-------------|------|
| `.weiyige/[Agent]/IDENTITY.md` | 覆盖 | 覆盖 | 角色身份源文件 |
| `.weiyige/[Agent]/SOUL.md` | 覆盖 | 覆盖 | 方法论源文件 |
| `.weiyige/[Agent]/SKILLS.md` | 覆盖 | 覆盖 | Skill 卡片源文件 |
| `.weiyige/[Agent]/skills/` | 覆盖 | 覆盖 | 专属技能 |
| `.weiyige/[Agent]/rules/` | 覆盖 | 覆盖 | 专属规则 |
| `.weiyige/[Agent]/memory/` | 创建 | 保留 | 用户偏好 / 经验教训不能覆盖 |
| `.weiyige/*.md` | 覆盖 | 覆盖 | 协议文件 |
| `.weiyige/gates/` | 覆盖 | 覆盖 | 阶段门禁 |
| `.weiyige/rules/` | 覆盖 | 覆盖 | 全局规则 |
| `.weiyige/skills/` | 覆盖 | 覆盖 | 共享 Skill |
| `.codebuddy/agents/*.md` | 覆盖 | 覆盖 | CodeBuddy 适配层 |
| `.codebuddy/skills/*` | 覆盖 | 覆盖 | CodeBuddy Skill |
| `CLAUDE.md` 维弈阁段落 | 追加 / 替换 | 替换 | 保留用户原有内容 |

---

## 4. 发布清单

### 内容完整性

- [ ] 13 个 Agent 源目录齐全：锋、砺、隐、枢、辞、寻、矩、绘、铸、鉴、盾、算、启。
- [ ] 所有修改过的 `SOUL.md` / `SKILLS.md` 版本号已更新。
- [ ] `README.md`、`QUICKSTART.md`、`ROUTER.md`、`PROTOCOL.md` 无旧角色数量。
- [ ] `TODO.md` 已同步完成状态。
- [ ] 示例文档已更新：Office Hours Startup / Builder、team 端到端。

### 安装脚本

- [ ] `install.sh` 的 `AGENTS` 包含 13 个角色。
- [ ] `install.sh` 的 `CB_AGENT_NAMES` 包含 13 个 CodeBuddy Agent。
- [ ] `install.ps1` 的 `$AGENTS` / `$AGENT_NAMES` 与 `install.sh` 一致。
- [ ] `PROTOCOL_FILES` 包含 `PROJECT-CONFIG-SPEC.md`、`PACKAGING.md`。
- [ ] Gates / Rules / Skills 均被安装到 `.weiyige/`。
- [ ] Skills 同步到 `.codebuddy/skills/`。
- [ ] update 模式保留 `memory/`。

### CodeBuddy 多 Agent

- [ ] `agents_for_codebuddy/` 恰好包含 13 个正式角色适配文件。
- [ ] frontmatter 字段使用 `agentMode: agentic`。
- [ ] `description` 触发条件不互相抢路由。
- [ ] 交接块统一到 `PROTOCOL.md §2.2`。
- [ ] team 模式 `name` / `recipient` 使用单字角色名。

### 质量检查

- [ ] 全局搜索无过期表述：`10 个 Agent`、`12 个 Agent`、`模型直接生成代码`。
- [ ] 文档中的开发阶段责任统一为 `铸`。
- [ ] 审查类流程有评分和门禁。
- [ ] 产物要求有落盘路径。
- [ ] 无硬编码密钥、无敏感信息。

---

## 5. 安装后验证清单

在目标项目执行：

```bash
# 1. 角色目录数量
find .weiyige -maxdepth 1 -type d | grep -E '(_|执事|探索|开发)' | wc -l

# 2. CodeBuddy Agent 数量
find .codebuddy/agents -maxdepth 1 -name '*.md' | wc -l

# 3. 共享 Skill
find .weiyige/skills -maxdepth 2 -name 'SKILL.md'
find .codebuddy/skills -maxdepth 2 -name 'SKILL.md'

# 4. 协议文件
ls .weiyige/PROTOCOL.md .weiyige/ROUTER.md .weiyige/MEMORY.md .weiyige/QUICKSTART.md .weiyige/PROJECT-CONFIG-SPEC.md .weiyige/PACKAGING.md

# 5. 旧表述扫描
grep -R "10 个 Agent\|12 个 Agent\|模型直接生成代码" .weiyige agents_for_codebuddy README.md QUICKSTART.md ROUTER.md PROTOCOL.md || true
```

期望：13 个正式角色、13 个 CodeBuddy Agent、共享 Skill 均存在、无旧表述。

---

## 6. 目录兼容性矩阵

| 版本 | 安装目录 | Agent 数 | 破坏性变更 |
|------|---------|---------|-----------|
| v1.0 | `.weiyige/` | 10 | 初始角色体系 |
| v1.1 | `.weiyige/` | 10 | 新增 PROTOCOL / ROUTER / MEMORY |
| v1.2 | `.weiyige/` + `.codebuddy/agents/` | 10 | 新增 CodeBuddy 适配层 |
| v1.3 | `.weiyige/` + `.codebuddy/agents/` | 11 | 新增探索_寻 |
| v1.4 | `.weiyige/` + `.codebuddy/agents/` | 12 | 新增执事_启 |
| v2.0 | `.weiyige/` + `.codebuddy/agents/` + `.codebuddy/skills/` | 13 | 新增铸·开发 + 共享 Skills |
| v2.1 | 同 v2.0 | 13 | Office Hours v2 + 二评 + 视觉草图 + Spec Review Loop |

---

## 7. 打包命令

```bash
# 创建版本标签
git tag -a v2.1 -m "v2.1: Office Hours v2 + 13 Agent consistency"

# 推送标签
git push origin v2.1

# 创建离线包
git archive --format=tar.gz --prefix=weiyige-pavilion/ HEAD -o weiyige-pavilion-v2.1.tar.gz
```

---

*打包不是复制文件，而是保证源、产物、协议、运行时入口的一致性。*