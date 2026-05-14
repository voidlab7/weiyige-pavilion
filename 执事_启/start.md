# 维弈阁多智能体启动协议

> 本文件由主 Agent 在用户触发 `@启` / `@team` / "自动跑完"时读取执行。

## 核心模式：预创建 + 按需唤醒

- 所有链路成员在 Step 1 一次性并行创建。
- `启·执事` 创建后立即作为 Leader 工作；其他成员初始化后待命。
- team 模式下 `task(name=...)` 和 `send_message(recipient=...)` **必须使用角色单字**：锋、砺、隐、枢、辞、寻、矩、绘、铸、鉴、盾、算、启。
- 非 Leader 成员收到 `🔔 [启 → {角色名}]` 后激活。

---

## Step 0：读取配置 + 三路路由

读取 `ai-workspace/{task_id}/state.json`（如存在），进行三路判断：

```text
路径 A — state.json 存在且有未完成阶段 → 断点续做（从 current_phase + current_step 继续）
         同时读取 runtime-knowledge/context-summary.json 恢复推理上下文
路径 B — state.json 存在但用户说"重新开始" → 清空状态，从头执行
路径 C — state.json 不存在或首次 → 新建 state.json，从头执行
```

**快速恢复**（用户说"继续"但未指定 task_id）：
读取 `ai-workspace/last-interrupted.json` → 获取 `last_task_id` → 走路径 A。

如果不支持多智能体 / team 工具，直接报告阻塞，**禁止静默降级为单会话串行**。

---

## Step 1：创建 state.json（ops 可见性保证）

**在 spawn 任何 team member 之前**，主 Agent 必须先执行：

```bash
node /Users/voidzhang/Documents/workspace/weyige/weiyige-ops/bin/cli/weiyige-cli.mjs init-task {task_id} --title "{任务描述}" --project-root {项目根目录}
```

这一条命令自动完成：
- ✅ 创建 `ai-workspace/{task_id}/state.json`（status=running）
- ✅ 创建 `ai-workspace/{task_id}/progress-board.md`
- ✅ 创建 `artifacts/01~06` 目录结构

**为什么**：weiyige-ops 全局调度中心通过扫描 state.json 感知任务运行状态。如果不先创建这个文件，调度中心看不到任务在跑，无法亮灯、无法检测僵尸。

**规则**：无论是 team 模式还是角色扮演模式，只要是走完整工作流的任务，**第一步永远是执行 init-task**。

### 阶段更新（每个阶段完成时执行）

```bash
node weiyige-cli.mjs update-phase {task_id} --phase 03-design --status completed --agent 矩 --project-root {项目根目录}
```

### 任务完成时

```bash
node weiyige-cli.mjs finish-task {task_id} --project-root {项目根目录}
```

---

## Step 2：创建团队 + 并行 spawn 成员

```text
team_create(team_name = "weiyige-{task_id}")
```

同时发出需要的 `task` 调用。

### Leader：启

```text
task(
  subagent_name = "启·执事",
  name = "启",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 Leader（启·执事）。
    团队已创建，成员将按需待命。
    请读取 .weiyige/执事_启/SOUL.md、PROTOCOL.md、ROUTER.md 完成初始化，然后开始调度。
    任务目标：{用户任务描述}
    编排模式：{auto/confirm/step}
    TASK_ID: {task_id}
    工作区: ai-workspace/{task_id}/"
)
```

### 成员：按链路创建，初始化后待命

```text
task(
  subagent_name = "枢·PM",
  name = "枢",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 枢·PM。读取自身定义和 PROTOCOL.md 后进入待命；收到 `🔔 [启 → 枢]` 再执行业务。"
)
```

其他成员同理：`砺`、`锋`、`隐`、`矩`、`绘`、`铸`、`鉴`、`盾`、`算`、`辞`、`寻`。

---

## Step 3：只 spawn 链路中需要的角色

| 任务类型 | 建议成员 |
|---------|----------|
| 新产品 / 新功能 | 启 + 砺 + 锋 + 枢 + 矩 + 绘 + 铸 + 鉴 + 盾 |
| Office Hours Deep | 启 + 砺 + 隐 + 绘（UI 类）+ 锋（需裁决时） |
| Bug 修复 | 启 + 铸 + 鉴 |
| 设计审查 | 启 + 绘 + 矩 + 鉴 |
| 内容创作 | 启 + 辞 + 锋 |
| 安全审计 | 启 + 盾 + 铸 + 鉴 |
| 信息探索 | 启 + 寻 + 隐（深度分析时） |

---

## Step 4：启接管调度

启初始化后：

1. 更新 `ai-workspace/{task_id}/state.json`（补充 phases 和详细信息）。
2. 创建 `ai-workspace/{task_id}/progress-board.md`。
3. 创建产物子目录：`01-ideation`、`02-requirement`、`03-design`、`04-development`、`05-testing`、`06-summary`。
4. 按 `SOUL.md` 的编排逻辑串行唤醒成员。
5. 每次唤醒前验证上游 `产物文件` 可读。
6. 每个成员完成后解析交接块，更新 state 和 progress-board。

### ⚠️ 阶段切换必须调 CLI（CRITICAL）

**每次唤醒一个角色之前**，必须执行：

```bash
node /Users/voidzhang/Documents/workspace/weyige/weiyige-ops/bin/cli/weiyige-cli.mjs update-phase {task_id} --phase {阶段} --status in_progress --agent {角色名} --description "{角色}正在执行{工作}" --project-root {项目根目录}
```

**每个角色完成后**，必须执行：

```bash
node /Users/voidzhang/Documents/workspace/weyige/weiyige-ops/bin/cli/weiyige-cli.mjs update-phase {task_id} --phase {阶段} --status completed --agent {角色名} --project-root {项目根目录}
```

**为什么**：ops 调度中心靠 state.json 的 `current_phase` 和阶段状态展示进度条和当前角色。如果不调，看板上只能看到「initializing → completed」，中间过程完全不可见。

示例（任务 my-feature，链路 矩→铸→鉴）：
```bash
# 矩开始
node weiyige-cli.mjs update-phase my-feature --phase 03-design --status in_progress --agent 矩 --description "矩·架构正在评审技术方案" --project-root /path
# 矩完成
node weiyige-cli.mjs update-phase my-feature --phase 03-design --status completed --agent 矩 --project-root /path
# 铸开始
node weiyige-cli.mjs update-phase my-feature --phase 04-development --status in_progress --agent 铸 --description "铸·开发正在实现代码" --project-root /path
# 铸完成
node weiyige-cli.mjs update-phase my-feature --phase 04-development --status completed --agent 铸 --project-root /path
# 鉴开始
node weiyige-cli.mjs update-phase my-feature --phase 05-testing --status in_progress --agent 鉴 --description "鉴·QA正在执行测试" --project-root /path
# 完成任务
node weiyige-cli.mjs finish-task my-feature --project-root /path
```

---

## Step 4：端到端示例

用户：

```text
@team auto 我有个产品想法：做一个宠物人格测试。请从评估、需求、设计、开发、测试走完整流程。
```

执行链：

```text
主 Agent 读取 start.md
→ team_create("weiyige-pet-mbti")
→ 并行 spawn：启、砺、锋、枢、矩、绘、铸、鉴、盾
→ 启唤醒砺：Office Hours v2，产出 01-ideation 设计文档
→ 启验证设计文档，必要时唤醒隐二评 / 绘草图
→ 启唤醒锋：方向审批
→ 启唤醒枢：PRD
→ 启并行唤醒矩+绘：工程审查 + 设计审查
→ 启唤醒铸：代码实现 + 左移检查
→ 启唤醒鉴：QA 测试
→ 启唤醒盾：安全审计
→ 启汇总 summary，shutdown_request 所有成员，team_delete
```

---

## Step 6：全链路完成

```text
Leader 汇总报告 → 写入 ai-workspace/{task_id}/artifacts/06-summary/
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