# 维弈阁全局调度中心 — 需求更新 v2

> 日期：2026-05-04
> 基于：weiyige-global-ops-design.md (2026-05-03 v1)
> 触发：2026-05-04 实际调度 6 项目任务时发现的架构缺口
> 状态：**需求澄清，待设计实现**

---

## 0. v1 设计的验证结论

v1 设计的三层架构（全局调度层 → 项目工作流层 → 单任务执行层）和调度逻辑（得分排序、WIP 控制、晨报）在 2026-05-04 实战中**调度侧验证通过**，但**执行侧暴露了关键缺口**：

| v1 假设 | 实际情况 | 问题 |
|---------|---------|------|
| OpenClaw 作为唯一 Worker | 用户同时使用 CodeBuddy IDE 和 Claude Code CLI | 需要多执行环境支持 |
| 调度器写 dispatch 文件 → Worker 自动 pick up | 没有 Worker 进程来 pick up | 执行层断裂 |
| 一个 Worker 串行执行 | 用户希望 6 个项目任务并行推进 | 需要多 Worker 并行 |
| Worker 是 headless 的 | 有些任务需要 hold 等人决策 | 需要 hold/resume 机制 |

---

## 1. 用户核心需求（2026-05-04 澄清）

### 1.1 调度完成后必须自动 spawn Worker

> "Codebuddy 调度以后，应该类似 spawn team 模式，spawn 到各个项目启动对应的角色。"

**含义**：`run-once.py` dispatch 一个任务后，不能只写文件就结束。必须**主动启动一个 Worker**进入目标项目执行任务。在 CodeBuddy 环境下，使用 `task` 工具 spawn 子 Agent；在 Claude Code 环境下，使用 `claude -p` 启动子进程。

```
调度器 dispatch
  ↓
自动 spawn Worker（不是等人来 pick up）
  ↓
Worker 进入项目，读 .weiyige 协议，按角色链路执行
  ↓
Worker 完成/阻塞 → 写 last-result.json → finish-task.sh
```

### 1.2 中断恢复的两条路径

> "项目中断，我可以到项目的 CodeBuddy 中继续启动；我也可以在调度中心检查状态，继续启动。"

**含义**：任务执行可能因为会话断开、Token 耗尽、超时等原因中断。恢复必须支持两种入口：

| 恢复路径 | 方式 | 场景 |
|---------|------|------|
| **路径 A：项目内恢复** | 在项目目录开 CodeBuddy/Claude Code，读 `ai-workspace/running/{task}.yaml` + `state.json`，从断点继续 | 用户直接关心某个项目 |
| **路径 B：调度中心恢复** | 在 ops 目录，运行 `resume-task.sh <project> <task-id>`，调度中心重新 spawn Worker | 用户在 ops 全局视角操作 |

两条路径必须**读同一份 state.json**，不能有两套状态。

### 1.3 双执行环境适配

> "我现在需要适配调度中心在 Claude Code 启动和 CodeBuddy 中启动两种模式。"

**含义**：调度中心本身可以在两种环境运行，spawn Worker 的方式不同：

| 调度中心环境 | spawn Worker 方式 | Worker 运行环境 |
|-------------|------------------|----------------|
| **CodeBuddy IDE** | `task` 工具 spawn 子 Agent | CodeBuddy 子 Agent |
| **Claude Code CLI** | `claude -p "$(cat dispatch-prompt.md)" --cwd <project-path>` | Claude Code 子进程 |

调度器需要感知自己运行在哪个环境，自动选择 spawn 方式。

### 1.4 终极目标

> "我可以让每个项目完成对应的事情，需要决策的时候可以 hold，不需要决策的时候整个调度不中断，并且可以添加不同任务到队列，ops 可以观察所有情况。"

拆解为 5 个能力：

| # | 能力 | 说明 |
|---|------|------|
| **C1** | 自动执行 | 调度 → spawn → 执行 → 完成，全链路无人干预 |
| **C2** | 决策 hold | 任务执行到需要人决策时暂停，不影响其他任务 |
| **C3** | 队列动态追加 | 随时通过 `quick-task.py` 添加新任务，调度器下一轮自动 pick up |
| **C4** | 全局观察 | ops dashboard 看到所有项目的队列/运行/完成/阻塞/hold 状态 |
| **C5** | 不中断调度 | 一个任务 hold/blocked 不阻塞其他项目的任务推进 |

---

## 2. 架构更新：补全执行层

### 2.1 v1 架构（缺执行层）

```
调度器 → 写 dispatch 文件 → ??? → 任务完成
                              ↑
                          这里断了
```

### 2.2 v2 架构（补全 spawn + 执行）

```
L0 控制中心（人 + ops 会话）
│
├── 添加任务到队列（quick-task.py）
├── 触发调度（run-once.py）
├── 观察状态（board.sh / dashboard）
├── 恢复中断任务（resume-task.sh）
└── 人工决策（review hold 队列）

        ↓ 调度 + spawn

L1 全局调度层（weiyige-ops/run-once.py）
│
├── 读 projects.yaml + 各项目 queue
├── 按得分选任务
├── spawn Worker 到目标项目 ← 【新增：不再只写文件】
├── 管理 WIP（并行上限）
├── 轮询 Worker 状态
└── 生成晨报

        ↓ Worker 进入项目

L2 项目工作流层（project/.weiyige + ai-workspace）
│
├── Worker 读 .weiyige 协议
├── 按任务类型选角色链路
├── 角色执行 + 产物落盘
├── 遇到决策点 → hold（写 hold.json）
├── 两层门禁审核
└── 完成 → 写 last-result.json + state.json

        ↓ 结果回传

L3 状态回收层（调度器轮询 / finish-task.sh）
│
├── 检测 last-result.json / state.json
├── 清理 lock + 移动任务文件
├── 更新 scheduler-state.json
├── 追加晨报
└── 如有 hold → 通知控制中心
```

### 2.3 spawn Worker 的具体机制

#### CodeBuddy 环境（必须使用 team 模式）

**严禁使用 `task` 工具 spawn 子 Agent**。原因：
1. `task` 的 code-explorer 子 Agent 是只读的，无法写文件
2. `task` 同步模式非常慢，会阻塞主 Agent
3. 历史教训：2026-04-27 踩坑，用 task 同步模式失败

**正确方式**：使用 `team_create` + team member spawn

```python
# 1. 创建 team（如果还没有）
team_create(team_name="ops-dispatch")

# 2. spawn team member 到目标项目
task(
    name=f"worker-{project_id}",      # team member 名称
    team_name="ops-dispatch",          # 加入 team
    mode="acceptEdits",                # 允许写文件
    prompt=dispatch_prompt,            # 包含项目路径、任务指令、协议引用
    description=f"执行 {project_id}/{task_id}",
    subagent_name="code-explorer",     # 基础 subagent
    max_turns=50,                      # 限制轮次
)
```

team member 异步运行，不阻塞调度中心。调度中心可以继续 spawn 其他项目的 Worker。

Worker 进入项目后，应该读取 `.weiyige/` 协议，让项目内的维弈阁角色启动工作。

#### Claude Code 环境

```bash
# 在 run-once.py 中调用
claude -p "$(cat logs/dispatch-prompt.md)" \
  --cwd /path/to/project \
  --max-turns 50 \
  --allowedTools "read,write,bash" \
  2>&1 | tee logs/worker-{task_id}.log
```

---

## 3. 任务生命周期（v2 更新）

```
queued → dispatched → spawned → running → [hold] → completed/blocked/failed
                                  ↑                      │
                                  └──── resume ───────────┘
```

| 状态 | 含义 | 存储位置 |
|------|------|---------|
| `queued` | 在 queue/ 等待调度 | queue/{task}.yaml |
| `dispatched` | 调度器已选中，准备 spawn | running/{task}.yaml + lock |
| `spawned` | Worker 已启动 | lock.status = "spawned" |
| `running` | Worker 正在执行 | state.json.status = "running" |
| `hold` | 需要人决策，Worker 暂停 | state.json.status = "hold" + hold.json |
| `completed` | 任务完成 | done/{task}.yaml + last-result.json |
| `blocked` | 任务被阻塞（技术原因） | blocked/{task}.yaml |
| `failed` | 任务失败 | failed/{task}.yaml |

### 3.1 hold 机制（新增）

Worker 执行到需要人决策时：

1. 写 `ai-workspace/{task-id}/hold.json`：
```json
{
  "task_id": "xxx",
  "reason": "需要确认是否 push 到 main 分支",
  "options": ["push", "skip", "改分支名"],
  "held_at": "ISO timestamp",
  "phase": "04-development"
}
```

2. 更新 `state.json` status 为 `hold`
3. Worker 退出（不阻塞调度器）
4. 调度器检测到 hold → 记入晨报 / dashboard
5. 用户决策后 → `resume-task.sh <project> <task-id> --decision "push"` → 重新 spawn Worker 从断点继续

---

## 4. 跨环境兼容协议

### 4.1 统一完成信号（已实现）

不管 Worker 是 CodeBuddy 还是 Claude Code，完成时都检查 4 种信号：

1. `last-result.json`（CodeBuddy 原生信号）
2. `state.json` status 字段
3. lock 文件状态
4. lock + dispatch 文件都消失

### 4.2 统一 Worker 协议

Worker 不管在哪个环境运行，都遵循同一套协议：

```
1. 读 .weiyige/PROTOCOL.md 了解项目协议
2. 读 ai-workspace/{task-id}/state.json 了解当前进度
3. 如果 state.phase != "initialized"，从断点继续（断点续做）
4. 按任务类型选角色链路执行
5. 每完成一个阶段更新 state.json
6. 完成后写 last-result.json
7. 遇到需要人决策的点 → 写 hold.json → 退出
```

### 4.3 环境感知

调度器自动感知当前环境：

```python
def detect_environment():
    """感知当前运行环境"""
    if os.environ.get("CODEBUDDY_SESSION"):
        return "codebuddy"
    elif shutil.which("claude"):
        return "claude_code"
    else:
        return "manual"
```

也可以通过 CLI 参数显式指定：`--executor codebuddy` 或 `--executor claude_code`

---

## 5. 与 v1 设计的兼容性

| v1 设计 | v2 更新 | 兼容性 |
|---------|---------|--------|
| 三层架构 | 保持，补全 L0 控制中心 + L3 回收层 | ✅ 兼容 |
| projects.yaml | 保持不变 | ✅ 兼容 |
| 任务得分排序 | 保持不变 | ✅ 兼容 |
| queue/running/done/blocked 流转 | 新增 hold 状态 | ✅ 向后兼容 |
| OpenClaw 作为 Worker | 改为多执行器（CodeBuddy/Claude Code/OpenClaw） | ⚠️ 扩展 |
| 写 dispatch 文件等 pick up | 改为主动 spawn Worker | ⚠️ 行为变更 |
| scheduler-state.json | 新增 spawned 状态 | ✅ 向后兼容 |
| 晨报 | 新增 hold 项 | ✅ 向后兼容 |

---

## 6. 待实现清单

| # | 模块 | 内容 | 优先级 |
|---|------|------|--------|
| 1 | **spawn 机制** | run-once.py dispatch 后自动 spawn Worker | P0 |
| 2 | **CodeBuddy spawner** | 通过 team_create + team member spawn（**禁止 task 同步模式**） | P0 |
| 3 | **Claude Code spawner** | 通过 `claude -p` 启动子进程 | P0 |
| 4 | **hold 机制** | hold.json 写入 + 调度器检测 + resume-task.sh | P1 |
| 5 | **resume-task.sh** | 从断点恢复任务，支持两条路径（项目内 / 调度中心） | P1 |
| 6 | **环境自动感知** | detect_environment() 或 --executor 参数 | P1（已部分实现） |
| 7 | **Worker 统一协议** | Worker prompt 模板，读协议 → 断点续做 → 角色链路 | P1 |
| 8 | **并行 spawn** | 支持同时 spawn 多个 Worker 到不同项目 | P2 |
| 9 | **Dashboard hold 展示** | board.sh / dashboard 展示 hold 队列 | P2 |
| 10 | **超时回收** | Worker spawn 后超时未完成 → zombie 回收 | P2 |

---

## 7. 一句话总结

> v1 解决了"怎么选任务"，v2 要解决"选完以后谁来干"。
> 调度器不再是写文件等人来拿的公告板，而是**主动 spawn Worker 的指挥官**。
