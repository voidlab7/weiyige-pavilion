# 部署与同步

> 安装维弈阁、同步配置到项目。

---

## 安装

### 一键安装（远程）

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex
```

### 安装到指定项目

```bash
curl -fsSL ... | bash -s -- --target ~/my-project
```

### 更新（保留 memory）

```bash
curl -fsSL ... | bash -s -- --mode update
```

update 模式覆盖 Agent 定义/协议，**保留 memory/ 不动**。

## sync-weiyige.sh

从 pavilion 根目录同步到所有注册项目的 `.weiyige/`。

```bash
/path/to/weiyige-ops/sync-weiyige.sh
```

### 同步规则

**白名单（同步的）**：
- 13 个角色目录（IDENTITY.md + SOUL.md + SKILLS.md + rules/ + skills/）
- `gates/`、`rules/`、`skills/`
- 6 个协议文件（PROTOCOL.md、ROUTER.md、LOADER.md、SHARED.md、MEMORY.md、QUICKSTART.md）

**排除的**：
- `README.md`、`install.sh`、`TODO.md`
- `agents_for_codebuddy/`、`ai-workspace/`、`examples/`
- `成长日记/`、`设计方案/`、`.openclaw/`

**保留的**：
- 各项目的 `memory/` 目录不覆盖

### 注册项目

```bash
weiyige-cli register-project /path/to/project --name "项目名"
```

或直接编辑 `.weiyige/registry.json`。

## 工作流

```
1. 编辑 pavilion 根目录源码
2. 跑 sync-weiyige.sh
3. 自动同步到自己的 .weiyige/ + 其他所有注册项目
```
