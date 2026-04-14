# 维弈阁更新指南

> 已安装维弈阁的项目，如何更新到最新版本？

---

## 一键更新

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash -s -- --mode update
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex -Mode update
```

## 更新逻辑

update 模式会自动：

1. **扫描项目目录**，寻找已安装的 `.weiyige/` 目录
2. **覆盖 Agent 定义文件**（SOUL.md、IDENTITY.md、技能文件、规则文件）
3. **覆盖协议文件**（PROTOCOL.md、ROUTER.md、MEMORY.md、QUICKSTART.md）
4. **覆盖 CodeBuddy Agent 文件**（`.codebuddy/agent/*.md`）
5. **保留用户数据**（memory/ 目录下的偏好、教训、知识）
6. **更新 CLAUDE.md 中的维弈阁配置段落**（仅替换维弈阁部分，不影响用户原有内容）

## 什么会被覆盖

| 文件 | 更新行为 |
|------|---------|
| `.weiyige/[Agent]/SOUL.md` | ✅ 覆盖 |
| `.weiyige/[Agent]/IDENTITY.md` | ✅ 覆盖 |
| `.weiyige/[Agent]/skills/*.md` | ✅ 覆盖 |
| `.weiyige/[Agent]/rules/**/*.mdc` | ✅ 覆盖 |
| `.weiyige/[Agent]/memory/*` | ❌ 保留（用户数据） |
| `.weiyige/PROTOCOL.md` | ✅ 覆盖 |
| `.weiyige/ROUTER.md` | ✅ 覆盖 |
| `.weiyige/MEMORY.md` | ✅ 覆盖 |
| `.weiyige/QUICKSTART.md` | ✅ 覆盖 |
| `.codebuddy/agent/*.md` | ✅ 覆盖 |
| `CLAUDE.md` 中的维弈阁段落 | ✅ 替换 |
| `CLAUDE.md` 中的用户原有内容 | ❌ 保留 |

## 手动更新

如果不想用脚本，可以手动操作：

```bash
# 1. clone 最新版
git clone https://github.com/voidlab7/weiyige-pavilion.git /tmp/weiyige-latest

# 2. 覆盖 Agent 定义（保留 memory/）
for agent in CEO_锋 PM_枢 架构_矩 设计_绘 QA_鉴 安全_盾 财务_算 内容_辞 顾问_隐 合伙人_砺; do
  # 覆盖 SOUL + IDENTITY + skills + rules
  cp /tmp/weiyige-latest/$agent/SOUL.md .weiyige/$agent/
  cp /tmp/weiyige-latest/$agent/IDENTITY.md .weiyige/$agent/
  cp -r /tmp/weiyige-latest/$agent/skills .weiyige/$agent/ 2>/dev/null || true
  cp -r /tmp/weiyige-latest/$agent/rules .weiyige/$agent/ 2>/dev/null || true
  # 不覆盖 memory/
done

# 3. 覆盖协议文件
cp /tmp/weiyige-latest/PROTOCOL.md .weiyige/
cp /tmp/weiyige-latest/ROUTER.md .weiyige/
cp /tmp/weiyige-latest/MEMORY.md .weiyige/
cp /tmp/weiyige-latest/QUICKSTART.md .weiyige/

# 4. 覆盖 CodeBuddy Agent
cp /tmp/weiyige-latest/agents_for_codebuddy/*.md .codebuddy/agent/

# 5. 清理
rm -rf /tmp/weiyige-latest
```

## 版本检查

查看当前安装的版本：

```bash
cat .weiyige/QUICKSTART.md | head -5
```

对比最新版：

```bash
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/QUICKSTART.md | head -5
```
