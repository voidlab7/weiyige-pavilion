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

## Step 1：创建团队 + 并行 spawn 成员

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

## Step 2：只 spawn 链路中需要的角色

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

## Step 3：启接管调度

启初始化后：

1. 读取 / 创建 `ai-workspace/{task_id}/state.json`。
2. 创建 `ai-workspace/{task_id}/progress-board.md`。
3. 创建产物子目录：`01-ideation`、`02-requirement`、`03-design`、`04-development`、`05-testing`、`06-summary`。
4. 按 `SOUL.md` 的编排逻辑串行唤醒成员。
5. 每次唤醒前验证上游 `产物文件` 可读。
6. 每个成员完成后解析交接块，更新 state 和 progress-board。

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

## Step 5：全链路完成

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