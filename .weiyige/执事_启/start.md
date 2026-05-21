# 维弈阁多智能体启动协议

> 本文件由主 Agent 在用户触发 `@启` / `@team` / "自动跑完"时读取执行。

---

## 前置条件

如果不支持多智能体 / team 工具，直接报告阻塞，**禁止静默降级为单会话串行**。

---

## Step 1：创建 state.json（ops 可见性保证）

**在 spawn 任何 team member 之前**，主 Agent 必须先执行：

```bash
weiyige-cli init-task {task_id} --title "{任务描述}" --project-root {项目根目录}
```

这一条命令自动完成：
- ✅ 创建 `ai-workspace/{task_id}/state.json`（status=running）
- ✅ 创建 `ai-workspace/{task_id}/progress-board.md`
- ✅ 创建 `artifacts/01~06` 目录结构

**规则**：无论是 team 模式还是角色扮演模式，只要是走完整工作流的任务，**第一步永远是执行 init-task**。

---

## Step 2：创建团队 + spawn 成员

```text
team_create(team_name = "weiyige-{task_id}")
```

### Leader：启

```text
task(
  subagent_name = "启·执事",
  name = "启",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 Leader（启·执事）。
    请读取 .weiyige/执事_启/SOUL.md 完成初始化，然后开始调度。
    任务目标：{用户任务描述}
    编排模式：{auto/confirm/step}
    TASK_ID: {task_id}
    工作区: ai-workspace/{task_id}/"
)
```

### 成员：按链路创建，初始化后待命

```text
task(
  subagent_name = "{角色全名}",
  name = "{角色单字}",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 {角色全名}。读取自身 IDENTITY.md 后进入待命；收到 `🔔 [启 → {角色}]` 再执行业务。"
)
```

**team 通信命名规范**：`task(name=...)` 和 `send_message(recipient=...)` **必须**使用角色单字：锋、砺、隐、枢、辞、寻、矩、绘、铸、鉴、盾、算、启。

---

## Step 3：只 spawn 链路中需要的角色

| 任务类型 | 建议成员 |
|---------|----------|
| 新产品 / 新功能 | 启 + 砺 + 锋 + 枢 + 矩 + 绘 + 铸 + 鉴 + 盾 |
| Bug 修复 | 启 + 铸 + 鉴 |
| 设计审查 | 启 + 绘 + 矩 + 鉴 |
| 内容创作 | 启 + 辞 + 锋 |
| 安全审计 | 启 + 盾 + 铸 + 鉴 |

---

## Step 4：启接管调度

启初始化后按 `SOUL.md` 的编排逻辑串行唤醒成员。

### ⚠️ 阶段切换必须调 CLI（CRITICAL）

**每次唤醒一个角色之前**：
```bash
weiyige-cli update-phase {task_id} --phase {阶段} --status in_progress --agent {角色名} --description "{描述}" --project-root {项目根目录}
```

**每个角色完成后**：
```bash
weiyige-cli update-phase {task_id} --phase {阶段} --status completed --agent {角色名} --project-root {项目根目录}
```

**任务完成时**：
```bash
weiyige-cli finish-task {task_id} --project-root {项目根目录}
```

---

## Step 5：全链路完成

```text
Leader 汇总报告 → 写入 ai-workspace/{task_id}/artifacts/06-summary/
→ weiyige-cli finish-task
→ shutdown_request 所有成员
→ team_delete()
```

---

## task 同步模式（轻量任务）

不创建团队，主 Agent 直接用 `task` 同步调用单个角色：

```text
@铸 帮我修复这个 Bug
@矩 审查一下这个方案
@鉴 测试一下这个功能
```

此时不需要读取本文件，不创建 `ai-workspace/` 目录。