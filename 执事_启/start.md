# 维弈阁多智能体启动协议

> 本文件由主 Agent（team-lead）在用户触发团队模式时读取执行。

## 核心模式：预创建 + 按需唤醒

- 所有链路成员在 Step 1 **一次性并行创建**
- 启·执事创建后立即作为 Leader 工作；其他成员待命
- 非 Leader 成员收到 `🔔 [Leader → {角色名}]` 后激活

---

## Step 0：读取配置 + 三路路由

读取 `ai-workspace/state.json`（如存在），进行三路判断：

```
路径 A — state.json 存在且有未完成阶段 → 断点续做
路径 B — state.json 存在但用户说"重新开始" → 清空状态，从头执行
路径 C — state.json 不存在或首次 → 新建 state.json，从头执行
```

## Step 1：创建团队 + 并行 spawn 全部成员

```
team_create(team_name = "weiyige-{task_id}")
```

**同时发出所有 task 调用**（并行创建）：

```
# 启作为 Leader（立即工作）
task(
  subagent_name = "启·执事",
  name = "leader",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 Leader（启·执事）。
    团队已创建，成员已就绪。
    请读取 .weiyige/执事_启/SOUL.md 完成初始化，然后开始工作。
    任务目标：{用户任务描述}
    编排模式：{auto/confirm/step}
    TASK_ID: {task_id}
    工作区: ai-workspace/{task_id}/"
)

# 其余成员（待命）— 只 spawn 链路中需要的角色
task(
  subagent_name = "枢·PM",
  name = "pm",
  team_name = "weiyige-{task_id}",
  mode = "bypassPermissions",
  prompt = "你是维弈阁团队的 枢·PM。完成初始化后进入待命，等待 Leader 唤醒。"
)

# ... 同样 spawn 矩·架构、铸·开发、绘·设计、鉴·QA、盾·安全 等链路角色
```

**只 spawn 链路中需要的角色**：
- 新功能开发：启 + 砺 + 锋 + 枢 + 矩 + 绘 + 铸 + 鉴 + 盾
- Bug 修复：启 + 铸 + 鉴
- 设计审查：启 + 绘 + 矩 + 鉴
- 内容创作：启 + 辞 + 锋

## Step 2：Leader（启）接管调度

启初始化后：
1. 读取/创建 `ai-workspace/{task_id}/state.json`
2. 创建 `ai-workspace/{task_id}/progress-board.md`
3. 创建产物子目录
4. 按 SOUL.md 的编排逻辑串行唤醒成员

## Step 3：全链路完成

```
Leader 汇总报告 → 写入 ai-workspace/{task_id}/artifacts/summary/
→ shutdown_request 所有成员
→ team_delete()
```

## 阻塞处理

不支持多智能体时：直接报告阻塞，**禁止静默降级为单会话串行**。

## task 同步模式（轻量任务）

不创建团队，主 Agent 直接用 `task` 工具同步调用单个角色：

```
@铸 帮我修复这个 Bug
@矩 审查一下这个方案
@鉴 测试一下这个功能
```

此时不需要读取本文件，不创建 ai-workspace 目录。
