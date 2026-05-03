# 维弈阁全局调度中心方案

> 日期：2026-05-03  
> 主题：让「数字分身」在多个项目之间 7×24 轮转起来  
> 结论：**新开一个 `weiyige-ops` 项目更好。`weiyige-pavilion` 继续作为维弈阁开源框架与能力建设仓库。**

---

## 1. 背景问题

当前维弈阁已经具备：

- 13 个角色的组织能力
- `.weiyige/` 项目内执行协议
- `ai-workspace/{task-id}/` 任务级产物落盘
- `state.json` 断点续做
- `progress-board.md` 进度看板
- 两层门禁、runtime-knowledge、异常矩阵

但这些能力主要解决的是：

> **一个项目内，一个任务如何被规范执行。**

你真正想要的是：

> **人离开电脑后，多个项目能自动轮转推进，第二天给你晨报。**

这不是单项目内的 Agent 流程问题，而是一个 **跨项目 Agent Ops 调度问题**。

---

## 2. 核心结论

维弈阁应该分成两层：

```text
全局维弈阁 / weiyige-ops
  = 多项目调度中心、夜巡、资源分配、晨报、预算、安全策略

项目内 .weiyige
  = 单项目执行协议、角色方法论、产物落盘、state.json、progress-board
```

不建议每个项目自己独立轮转一套完整系统。

原因：

1. 每个项目无法知道全局优先级
2. 多项目会抢机器、模型、Token、测试资源
3. 你早上 review 的精力有限
4. push/deploy 等高风险动作必须集中管控
5. 多个项目各自跑会导致状态分散、晨报分散、阻塞分散

---

## 3. 推荐架构

```text
┌──────────────────────────────────────────────┐
│              weiyige-ops 全局调度中心          │
│  projects.yaml / nightly-runner / morning     │
└──────────────────────┬───────────────────────┘
                       │ 选择项目 + 选择任务
                       ▼
┌──────────────────────────────────────────────┐
│                OpenClaw Worker                │
│  Headless 执行器 / 强模型入口 / 夜班工程师       │
└──────────────────────┬───────────────────────┘
                       │ 进入项目执行
                       ▼
┌──────────────────────────────────────────────┐
│           project/.weiyige + ai-workspace     │
│  单项目协议 / state.json / artifacts / gates   │
└──────────────────────┬───────────────────────┘
                       │ 产物落盘
                       ▼
┌──────────────────────────────────────────────┐
│              morning report 全局晨报           │
│  完成 / 阻塞 / 需要你决策 / 本地 commit          │
└──────────────────────────────────────────────┘
```

---

## 4. 为什么建议新开 `weiyige-ops`

### 4.1 `weiyige-pavilion` 的定位

`weiyige-pavilion` 应该继续是：

- 开源工程
- 角色定义仓库
- 协议与安装脚本
- `.weiyige/` 的来源
- 面向所有用户的通用能力建设

它应该尽量保持：

- 不含个人项目绝对路径
- 不含私有 token / API key
- 不含个人任务队列
- 不含私人项目优先级
- 不含夜间运行日志

### 4.2 `weiyige-ops` 的定位

`weiyige-ops` 应该是你的私人数字分身运营中心：

- 管多个项目
- 放绝对路径
- 放优先级
- 放夜巡日志
- 放 OpenClaw 调用脚本
- 放晨报
- 放全局调度状态
- 放个人偏好与预算策略

这部分强烈建议独立仓库，甚至可以是 private。

---

## 5. 目录设计

### 5.1 全局调度中心

```text
~/workspace/weiyige-ops/
├── projects.yaml                 # 所有项目注册表
├── scheduler-state.json          # 全局调度状态
├── run-once.sh                   # 手动跑一次
├── nightly-runner.sh             # 夜巡循环
├── openclaw-worker-prompt.md     # OpenClaw 固定执行提示词
├── task-template.yaml            # 任务模板
├── morning/
│   └── 2026-05-04.md             # 每日晨报
├── logs/
│   └── 2026-05-03-night.log
└── rules/
    ├── safety.md                 # 夜间安全策略
    └── scheduling.md             # 调度策略
```

### 5.2 每个项目内部

```text
project/
├── .weiyige/                     # 从 weiyige-pavilion 安装
├── ai-workspace/
│   ├── queue/                    # 项目待办
│   ├── running/
│   ├── done/
│   ├── blocked/
│   └── {task-id}/
│       ├── state.json
│       ├── progress-board.md
│       ├── runtime-knowledge/
│       └── artifacts/
│           ├── 01-ideation/
│           ├── 02-requirement/
│           ├── 03-design/
│           ├── 04-development/
│           ├── 05-testing/
│           └── 06-summary/
└── src/
```

---

## 6. projects.yaml 示例

```yaml
version: 1

global:
  max_parallel_tasks: 2
  max_minutes_per_task: 60
  nightly_window: "00:30-08:30"
  default_forbidden_actions:
    - push
    - deploy
    - delete_data

projects:
  - id: microlab
    name: Microlab 官网
    path: /Users/voidzhang/Documents/workspace/microlab
    priority: 90
    type: product
    max_parallel_tasks: 1
    allowed_actions:
      - read
      - edit
      - test
      - local_commit
    forbidden_actions:
      - push
      - deploy

  - id: weiyige
    name: 维弈阁开源工程
    path: /Users/voidzhang/Documents/workspace/weiyige-pavilion
    priority: 80
    type: infra
    max_parallel_tasks: 1
    allowed_actions:
      - read
      - edit
      - test
      - local_commit
    forbidden_actions:
      - push_unless_explicit

  - id: t_chrome
    name: IMA Chromium
    path: /Users/voidzhang/Documents/workspace/t_chrome_dev_138
    priority: 70
    type: chromium
    max_parallel_tasks: 1
    allowed_actions:
      - read
      - edit
      - test_light
      - local_commit
    forbidden_actions:
      - full_compile
      - push
      - deploy
```

---

## 7. 任务模板

```yaml
id: weiyige-install-ps1-audit
title: 检查 install.ps1 是否与 install.sh 功能一致
project: weiyige-pavilion
type: maintenance
priority: 70
max_minutes: 45

allowed_actions:
  - read
  - edit
  - test
  - local_commit

forbidden_actions:
  - push
  - deploy
  - delete_data

instructions:
  - 对比 install.sh 和 install.ps1 的安装文件列表
  - 找出遗漏项
  - 修复 install.ps1
  - 用临时目录模拟安装
  - 产物写入 ai-workspace/weiyige-install-ps1-audit/

acceptance:
  - bash install.sh 临时安装通过
  - install.ps1 逻辑与 install.sh 对齐
  - 生成 review-report.md
  - 生成 workflow-summary.md
```

---

## 8. OpenClaw 的角色

OpenClaw 不应该取代维弈阁。

它应该作为：

> **Headless Worker / 夜班工程师 / 强模型执行器**

固定提示词应该类似：

```text
你不是聊天助手。
你是维弈阁夜间 worker。

读取当前项目的 .weiyige/执事_启/start.md。
读取 ai-workspace/queue/{task}.yaml。
按维弈阁协议执行。
所有产物必须写入 ai-workspace/{task-id}/。
每完成一阶段更新 state.json 和 progress-board.md。
禁止 push、deploy、删除数据。
遇到权限不足、信息不足、破坏性操作，停止并写 blocked.md。
```

---

## 9. 调度策略

全局调度器根据任务得分选择夜间任务：

```text
任务得分 =
  项目优先级 × 0.4
+  任务优先级 × 0.3
+  可完成度 × 0.2
+  阻塞解除价值 × 0.1
- 风险惩罚
```

适合夜间自动跑：

- 文档整理
- 安装脚本验证
- 小 bug 修复
- 测试补充
- 代码审查报告
- 技术方案草稿
- 公众号选题/初稿

不适合夜间自动跑：

- 大规模重构
- 线上部署
- 数据迁移
- 主分支 push
- t_chrome 全量编译
- 没有验收标准的需求

---

## 10. 安全权限分层

| 权限 | 夜间默认 | 说明 |
|---|---|---|
| read | 允许 | 读代码、读文档 |
| edit | 允许 | 本地修改 |
| test | 允许 | 跑 lint/build/test |
| local_commit | 允许 | 可生成本地 commit |
| push | 默认禁止 | 早上人工确认 |
| deploy | 禁止 | 永不夜间自动部署 |
| delete_data | 禁止 | 永不允许 |

夜间最理想产出：

```text
代码已改
测试已跑
本地 commit 已生成
PR/MR 草稿说明已写
等待主人早上 review + push/deploy
```

---

## 11. 晨报模板

```markdown
# 维弈阁夜巡晨报 — 2026-05-04

## 昨晚完成

### microlab
- ✅ 修复 dashboard 白屏
- 产物: ai-workspace/dashboard-fix/artifacts/06-summary/workflow-summary.md
- 测试: npm run build 通过
- 本地 commit: abc123

### weiyige
- ✅ 清理 install.ps1 路径问题
- 测试: 临时目录安装通过

## 阻塞

### t_chrome
- ⚠️ 编译环境不可用
- 需要你确认是否触发 143 流水线

## 需要你决策

1. 是否 push microlab dashboard 修复？
2. 是否继续 t_chrome 的 TASK-04 测试？
```

---

## 12. 落地路线

### Phase 1：单项目夜巡 MVP

- 创建 `weiyige-ops/`
- 注册 1 个项目
- 创建 1 个 task.yaml
- 用 OpenClaw 执行一次
- 产物落盘 + 本地 commit + 晨报

### Phase 2：多项目轮转

- `projects.yaml` 注册 3 个项目
- 每晚最多跑 2 个任务
- 加锁，避免同项目并发
- 汇总全局晨报

### Phase 3：常驻化

- Mac 用 `launchd` 或 `tmux loop`
- 真 7×24 建议上 Mac mini / 云主机 / devbox
- 加预算限制和失败告警

---

## 13. 三层架构细化

整体应分为三层，而不是简单的“全局调度 + 项目执行”两层。

```text
第一层：全局项目调度中心（weiyige-ops）
  看所有项目：项目状态、优先级、预算、风险、阻塞、夜间可跑任务

第二层：项目工作流（project/.weiyige + project/ai-workspace）
  管一个项目：项目内任务队列、任务流转、角色协作、项目级状态

第三层：单个任务进度（project/ai-workspace/{task-id}）
  管一个需求/bug/文档任务：state.json、progress-board、artifacts、review-report
```

### 13.1 第一层：全局项目调度中心

全局层不直接写业务代码，它负责“看盘”和“调度”。

```text
weiyige-ops/
├── projects.yaml              # 项目注册表：路径、优先级、策略、权限
├── scheduler-state.json       # 全局调度状态：正在跑什么、上次跑到哪里
├── run-once.sh                # 跑一个任务
├── nightly-runner.sh          # 夜间循环
├── morning/                   # 全局晨报
└── logs/                      # 调度日志
```

它回答这些问题：

- 今晚有哪些项目可以跑？
- 每个项目现在健康吗？
- 哪个项目优先级最高？
- 哪个任务最适合夜间自动执行？
- 哪些任务需要白天人工确认？
- OpenClaw 现在是否空闲？
- 这次运行是否超预算/超时/高风险？

**关键原则：全局层只调度，不替项目内 Agent 做判断。**

### 13.2 第二层：项目工作流

每个项目都有自己的 `.weiyige/` 和 `ai-workspace/`。

```text
project/
├── .weiyige/                 # 维弈阁协议和角色定义
└── ai-workspace/
    ├── project-status.json   # 项目级状态摘要，给全局调度中心读
    ├── queue/                # 待处理任务
    ├── running/              # 正在执行任务锁
    ├── done/                 # 已完成任务记录
    ├── blocked/              # 阻塞任务记录
    └── {task-id}/            # 单任务工作区
```

项目层回答：

- 本项目有哪些任务？
- 哪个任务正在跑？
- 本项目是否被锁？
- 最近一次成功任务是什么？
- 是否存在阻塞任务？
- 项目内的产物在哪里？

项目层可以有自己的 workflow，但 workflow 是从 `.weiyige/执事_启/start.md` 启动的，不需要每个项目重新发明一套。

### 13.3 第三层：单个任务进度

每个任务一个独立目录：

```text
project/ai-workspace/{task-id}/
├── task.yaml
├── state.json
├── progress-board.md
├── runtime-knowledge/
└── artifacts/
    ├── 01-ideation/
    ├── 02-requirement/
    ├── 03-design/
    ├── 04-development/
    ├── 05-testing/
    └── 06-summary/
```

任务层回答：

- 当前任务到了哪个阶段？
- 哪个 Agent 做了什么？
- 产物文件在哪里？
- 评分多少？
- 是否通过 Layer 0 / Layer 1？
- 是否需要打回？
- 是否已完成或阻塞？

---

## 14. `projects.yaml` 具体怎么“流转”

`projects.yaml` 不是进度文件，它是**项目注册表 + 调度策略**。

它不频繁写入；真正频繁变化的是：

- 全局：`scheduler-state.json`
- 项目：`project/ai-workspace/project-status.json`
- 任务：`project/ai-workspace/{task-id}/state.json`

### 14.1 推荐字段

```yaml
version: 1

global:
  max_parallel_tasks: 2
  max_minutes_per_task: 60
  nightly_window: "00:30-08:30"
  day_window: "09:00-23:30"
  default_forbidden_actions: [push, deploy, delete_data]

projects:
  - id: weiyige
    name: 维弈阁开源工程
    path: /Users/voidzhang/Documents/workspace/weiyige-pavilion
    priority: 80
    owner_agent: 启·执事
    product_agent: 枢·PM
    tech_agent: 矩·架构
    content_agent: 辞·内容
    status_file: ai-workspace/project-status.json
    queue_dir: ai-workspace/queue
    max_parallel_tasks: 1
    allowed_night_task_types:
      - docs
      - test
      - small_fix
      - review
      - content_draft
    forbidden_night_actions:
      - push
      - deploy
      - delete_data
    health:
      stale_after_hours: 48
      blocked_alert_after_hours: 12
```

### 14.2 `projects.yaml` 的流转逻辑

```text
nightly-runner 启动
  ↓
读取 projects.yaml
  ↓
遍历 projects[]
  ↓
读取每个项目的 ai-workspace/project-status.json
  ↓
扫描 ai-workspace/queue/*.yaml
  ↓
过滤：是否允许夜间跑？是否被锁？是否超预算？
  ↓
按任务得分排序
  ↓
选择 1~2 个任务交给 OpenClaw
  ↓
OpenClaw 进入项目执行任务
  ↓
项目内更新 task state.json / progress-board / artifacts
  ↓
全局层读取结果，更新 scheduler-state.json 和 morning report
```

### 14.3 项目进度怎么更新？

项目进度不靠聊天总结，也不靠 Agent 口头汇报，必须**文件优先**。

推荐每个项目都有：

```text
project/ai-workspace/project-status.json
```

示例：

```json
{
  "project_id": "weiyige",
  "updated_at": "2026-05-03T15:40:00+08:00",
  "health": "green",
  "active_task": "office-hours-v2-upgrade",
  "queue_count": 3,
  "blocked_count": 1,
  "last_completed_task": "micropen-skill-install",
  "last_success_at": "2026-05-03T10:20:00+08:00",
  "next_recommended_task": "install-ps1-audit",
  "requires_human_decision": [
    "是否 push 6c03e86 到 GitHub"
  ]
}
```

谁更新它？

- 项目内的 `启·执事` 在每个任务完成/阻塞后更新
- 全局 `weiyige-ops` 可以在读取任务结果后补充更新
- 如果状态过期，调度器自动创建一个 `status-refresh` 只读任务，让 OpenClaw/启刷新项目状态

**所以不是靠“不同 Agent 汇总”作为唯一来源，而是：Agent 负责写文件，全局调度器读文件。**

---

## 15. 不同角色是否要管理不同项目？

不建议把角色固定绑定到项目。

错误理解：

```text
枢 管 microlab
矩 管 t_chrome
辞 管公众号
启 管 weiyige
```

这会让角色职责和项目边界混在一起。

正确理解：

```text
项目由全局调度器管理。
角色按能力进入项目。
```

例如：

| 项目 | 任务 | 进入的角色 |
|---|---|---|
| microlab | 新功能 | 枢 → 矩+绘 → 铸 → 鉴 |
| weiyige | 安装脚本修复 | 矩 → 铸 → 鉴 |
| t_chrome | Chromium bug | 矩 → 铸 → 鉴 → 盾 |
| 内容号 | 公众号文章 | 辞 / MicroPen → 锋 |

可以有“项目偏好角色”，但不是“项目负责人角色”。

`projects.yaml` 里可以配置推荐角色：

```yaml
agent_preferences:
  planning: 枢·PM
  architecture: 矩·架构
  coding: 铸·开发
  qa: 鉴·QA
  content: 辞·内容
```

但调度时仍按任务类型选择角色。

---

## 16. 项目中怎么流转工作流？

项目内部仍然使用维弈阁的工作流。

```text
task.yaml
  ↓
.project/.weiyige/执事_启/start.md
  ↓
启创建/恢复 ai-workspace/{task-id}
  ↓
按任务类型选择链路
  ↓
角色执行 + 产物落盘
  ↓
两层门禁审核
  ↓
更新 task state.json / progress-board
  ↓
任务完成后更新 project-status.json
```

### 16.1 项目内部是否也有一套 agents？

有，但不是“另一套独立大脑”。

每个项目安装 `.weiyige/` 后，本项目拥有同一套角色定义：

```text
project/.weiyige/
├── 枢·PM
├── 矩·架构
├── 铸·开发
├── 鉴·QA
└── ...
```

这些角色是“项目内执行角色”。

全局 `weiyige-ops` 不直接替它们做工作，只负责把任务交给这个项目，然后由项目内的启和角色按协议执行。

---

## 17. 白天和夜间怎么区分？

白天和夜间不是时间上的唯一差异，而是**权限和交互模式**不同。

### 17.1 白天模式（Human-in-the-loop）

适合：

- 方向决策
- 产品范围确认
- 需求澄清
- push / deploy
- 大重构批准
- 线上风险操作

运行方式：

```text
你在 CodeBuddy 里交互
  ↓
维弈阁 Agent 给方案/提问/执行
  ↓
你随时确认、改方向、批准 push/deploy
```

特点：

- 可以问你问题
- 可以做高风险决策
- 可以 push / deploy（经你确认）
- 可以跑探索性任务
- 更适合战略和产品判断

### 17.2 夜间模式（Autonomous-safe）

适合：

- 小 bug 修复
- 文档整理
- 测试补充
- 安装验证
- 代码审查报告
- 公众号选题/初稿
- 技术方案草稿

运行方式：

```text
weiyige-ops nightly-runner
  ↓
选择安全任务
  ↓
OpenClaw headless 执行
  ↓
本地修改 + 测试 + local commit
  ↓
生成晨报，等待你早上确认
```

夜间禁止：

- push
- deploy
- 删除数据
- 数据迁移
- 大规模重构
- 无验收标准的任务
- 需要实时问你的任务

### 17.3 白天 / 夜间交接

```text
白天：你把任务写入 queue，并标注是否允许夜间跑
  ↓
夜间：OpenClaw 按安全策略执行
  ↓
早上：morning report 告诉你完成/阻塞/需决策
  ↓
白天：你 review、push、部署、补充下一批任务
```

---

## 18. 最终层次架构

```text
L1 全局调度层：weiyige-ops
│
├── 看所有项目
├── 读取 projects.yaml
├── 读取每个 project-status.json
├── 选择项目 + 任务
├── 控制 WIP / 时间 / Token / 权限
├── 调用 OpenClaw
└── 生成全局晨报

        ↓ 调度某个项目任务

L2 项目工作流层：project/.weiyige + project/ai-workspace
│
├── 项目任务队列 queue/
├── 项目状态 project-status.json
├── 项目内启·执事 Leader
├── 项目内角色协作
└── 项目内门禁与产物规范

        ↓ 执行一个具体任务

L3 单任务执行层：ai-workspace/{task-id}
│
├── task.yaml
├── state.json
├── progress-board.md
├── artifacts/
├── review-report.md
└── workflow-summary.md
```

一句话总结：

> **全局层管“今晚谁最值得跑”，项目层管“这个项目怎么跑”，任务层管“这个任务跑到哪了”。**

---

## 19. 最终建议

**新开 `weiyige-ops`。**

`weiyige-pavilion` 继续做开源能力建设，不应该塞入你的私人调度配置。

推荐最终形态：

```text
weiyige-pavilion          # 开源：角色、协议、安装包
weiyige-ops               # 私有：多项目调度、OpenClaw、夜巡、晨报
project-A/.weiyige        # 项目内执行协议
project-B/.weiyige        # 项目内执行协议
```

一句话：

> `weiyige-pavilion` 是公司制度，`weiyige-ops` 是 COO 办公室，OpenClaw 是夜班工程师。