# 维弈阁打包与发布规范（Packaging）

> 版本: v1.0 | 创建: 2026-04-16
> 借鉴: 版本化发布设计

---

## 版本号规范

维弈阁使用**语义化版本**（SemVer）：`MAJOR.MINOR`

| 版本段 | 何时增加 | 示例 |
|--------|---------|------|
| MAJOR | 不兼容的结构变更（角色增删、协议重构） | 1.x → 2.0 |
| MINOR | 向后兼容的功能增强（新 Skill、新规则、优化） | 1.5 → 1.6 |

当前版本：**v1.6**

版本号写在以下位置（发布时同步更新）：
- `install.sh` 的 `WEIYIGE_VERSION` 变量
- `install.ps1` 的 `$WeiyigeVersion` 变量
- `QUICKSTART.md` 顶部
- 安装后写入 `project.yaml` 的 `weiyige_version`

---

## 发布清单（Release Checklist）

每次发布新版本前，逐条确认：

### 内容完整性

- [ ] 所有修改的 SOUL.md 版本号已更新（`<!-- Version: vX.X -->` 注释）
- [ ] PROTOCOL.md 版本号已更新
- [ ] UPDATE_FEATURE_LOG.md 已追加新版本记录
- [ ] README.md 已同步更新（角色数/Skill 数/新功能说明）

### 安装脚本

- [ ] `install.sh` 的 `WEIYIGE_VERSION` 已更新
- [ ] `install.ps1` 的 `$WeiyigeVersion` 已更新
- [ ] 新增的 Agent 目录已加入安装脚本的 `AGENTS` 数组
- [ ] 新增的协议文件已加入 `PROTOCOL_FILES` 数组
- [ ] 新增的 gates 文件已加入 `GATES_FILES` 数组
- [ ] 远程安装测试通过（`curl | bash`）
- [ ] 本地安装测试通过（`./install.sh`）
- [ ] update 模式测试通过（`--mode update`）
- [ ] Windows 安装测试通过（`install.ps1`）

### CodeBuddy 多 Agent

- [ ] `agents_for_codebuddy/` 目录下所有 Agent .md 已同步更新
- [ ] 新增角色的 Agent .md 已创建
- [ ] Agent 的 `description` 字段准确反映最新触发条件

### 质量检查

- [ ] 所有 SOUL.md 有"完成前自检"章节
- [ ] 所有 gates/*.md 的必查项与实际流程一致
- [ ] `rules/` 目录下的规则与 PROTOCOL.md 一致
- [ ] 无硬编码路径、无硬编码密钥
- [ ] `.gitignore` 排除了 `memory/` 和敏感文件

### Git & GitHub

- [ ] git commit（包含所有变更）
- [ ] git push
- [ ] 创建 Git Tag（如 `v1.6`）
- [ ] GitHub Release 已创建（含 changelog）

---

## 打包命令

```bash
# 创建版本标签
git tag -a v1.6 -m "v1.6: D2自检清单 + 全局规则 + 审核评分"

# 推送标签
git push origin v1.6

# 创建发布包（可选，用于离线安装）
git archive --format=tar.gz --prefix=weiyige-pavilion/ HEAD -o weiyige-pavilion-v1.6.tar.gz
```

---

## 安装脚本版本化

`install.sh` 开头增加版本号常量：

```bash
WEIYIGE_VERSION="1.6"
```

安装完成后自动写入 `project.yaml`：

```yaml
weiyige_version: "1.6"
```

update 模式时对比版本号，如果远程版本 > 本地版本才提示更新。

---

## 离线安装包

为无法访问 GitHub 的环境提供离线包：

```bash
# 打包
./package.sh   # 输出 weiyige-pavilion-v1.6.tar.gz

# 离线安装
tar xzf weiyige-pavilion-v1.6.tar.gz
cd weiyige-pavilion
./install.sh --target /path/to/project
```

---

## 目录兼容性矩阵

| 版本 | 安装目录 | Agent 数 | 破坏性变更 |
|------|---------|---------|-----------|
| v1.0 | `.weiyige/` | 10 | — |
| v1.1 | `.weiyige/` | 10 | 新增 PROTOCOL/ROUTER/MEMORY.md |
| v1.2 | `.weiyige/` + `.codebuddy/agents/` | 10 | 新增 agents_for_codebuddy/ |
| v1.3 | `.weiyige/` + `.codebuddy/agents/` | 11 | 新增探索_寻 + SKILLS.md |
| v1.4 | `.weiyige/` + `.codebuddy/agents/` | 12 | 新增执事_启 |
| v1.5 | `.weiyige/` + `.codebuddy/agents/` | 12 | gates/ 增加产物验证 |
| v1.6 | `.weiyige/` + `.codebuddy/agents/` | 12 | SOUL.md 增加自检 + 全局规则 |
| v2.0 | `.weiyige/` + `.codebuddy/agents/` | 13 | 新增铸·开发 + `skills/` 共享目录（artifact-review / knowledge-distillation） |
