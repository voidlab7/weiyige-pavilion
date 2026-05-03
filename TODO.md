# TODO — 维弈阁近期完善清单

> 更新：2026-05-04  
> 当前状态：Milestone 1~3 全部完成。新增 weiyige-ops v2 全局调度相关 Backlog。

---

## 0. 本轮优先级

### P0：先补"砺·合伙人 Office Hours v2"主链路

| ID | 事项 | 目标文件 | 状态 |
|---|---|---|---|
| T-001 | Context Gathering 标准化 | `合伙人_砺/SOUL.md`、`合伙人_砺/SKILLS.md` | 已完成 |
| T-002 | Startup 六问升级为 v2 | `合伙人_砺/SOUL.md` | 已完成 |
| T-003 | Builder 模式补齐 5 问 | `合伙人_砺/SOUL.md` | 已完成 |
| T-004 | Premise Challenge 增强 | `合伙人_砺/SOUL.md`、`合伙人_砺/SKILLS.md` | 已完成 |
| T-005 | Related Design Discovery | `合伙人_砺/SOUL.md`、`PROTOCOL.md` | 已完成 |
| T-006 | Landscape Awareness | `合伙人_砺/SOUL.md`、`合伙人_砺/SKILLS.md` | 已完成 |
| T-007 | Cross-Agent Second Opinion | `PROTOCOL.md`、`ROUTER.md` | 已完成 |
| T-008 | UI 想法触发 Visual Sketch Handoff | `合伙人_砺/SOUL.md`、`设计_绘/SKILLS.md` | 已完成 |
| T-009 | Startup / Builder 双模板设计文档 | `合伙人_砺/SOUL.md`、`PM_枢/skills/` | 已完成 |
| T-010 | Spec Review Loop | `PROTOCOL.md`、`rules/review-scoring.md`、`skills/artifact-review/` | 已完成 |

### P1：修正项目级一致性

| ID | 事项 | 目标文件 | 状态 |
|---|---|---|---|
| T-011 | 文档中的角色数量统一为 13 | `QUICKSTART.md`、`README.md`、`CLAUDE.md` | 已完成 |
| T-012 | 快速入门补 `@启`、`@铸` 和 team 模式说明 | `QUICKSTART.md` | 已完成 |
| T-013 | CodeBuddy 适配层交接块统一到 `PROTOCOL.md §2.2` | `agents_for_codebuddy/*.md` | 已完成 |
| T-014 | `.weiyige/` 与根目录 Agent 定义同步规则明确 | `PACKAGING.md`、`install.sh` | 已完成 |
| T-015 | `TODO.md` 从临时分析文档转为长期 Backlog | `TODO.md` | 已完成 |

### P2：补验证和示例

| ID | 事项 | 目标文件 | 状态 |
|---|---|---|---|
| T-016 | 增加 Office Hours v2 示例对话 | `examples/` 或 `合伙人_砺/examples/` | 已完成 |
| T-017 | 增加 team 模式端到端示例 | `examples/`、`执事_启/start.md` | 已完成 |
| T-018 | 安装脚本验证清单 | `PACKAGING.md`、`install.sh` | 已完成 |
| T-019 | 质量指标采集口径 | `合伙人_砺/SKILLS.md`、`MEMORY.md` | 已完成 |

---

## 1. P0 详细任务

### T-001：Context Gathering 标准化

问题：砺现在只有"读取项目相关文档 / 查看 git 历史 / 问目标"，缺少可执行清单。

待补：

- [x] 明确启动前必须读取：`CLAUDE.md`、`TODO.md`、`README.md`、`PROTOCOL.md`、`ROUTER.md`、相关 Agent 的 `SOUL.md` / `SKILLS.md`。
- [x] 明确 git 上下文检查：`git status --short`、`git log --oneline -30`、`git diff origin/main --stat`。
- [x] 明确历史产物发现：搜索 `ai-workspace/*/artifacts/01-ideation/*.md`、`artifacts/**/*.md`、`docs/designs/**/*.md`。
- [x] 输出固定 `Context Summary`：当前目标、项目阶段、已有证据、历史相似设计、明显风险。
- [x] 如果上下文不足，先问一个最关键问题，不直接生成方案。

验收：

- [x] 用户说"我有个想法"时，砺不会直接进入方案，而是先完成上下文总结。
- [x] 上下文总结里能看见"已读文件 / git 状态 / 历史相关设计 / 当前阶段"。

---

### T-002：Startup 六问升级为 v2

问题：当前六问有主干，但缺少每问的诊断细节。

待补：

- [x] 每个问题增加 `听到什么才算过关`。
- [x] 每个问题增加 `红旗信号`。
- [x] 每个问题增加 `可追问句式`。
- [x] 增加 `framing check`：语言是否精确、是否是真实用户、是否有隐藏假设。
- [x] 增加按产品阶段跳问：`pre-product`、`has users`、`paying customers`。
- [x] 增加内部创业适配：如果用户是在公司内部做项目，需求证据可替换为真实业务方行为、排期承诺、资源投入。

验收：

- [x] 六问不只是列表，而是能指导模型"该追问到什么程度"。
- [x] 对模糊回答会继续追问，不会礼貌放过。

---

### T-003：Builder 模式补齐 5 问

问题：当前 Builder 模式只有 3 问，缺差异化和 10x 视角。

待补 5 问：

1. 这个东西最酷的版本是什么？
2. 你会给谁看这个？什么会让他们说"哇"？
3. 到达一个你能真正使用或分享的东西，最快路径是什么？
4. 最接近的现有产品是什么？你的差异在哪里？
5. 如果时间无限，你会加什么？10x 版本是什么？

额外规则：

- [x] 如果 Builder 回答里出现明确用户、付费、强痛点，允许升级到 Startup 模式。
- [x] 如果只是好玩项目，不强行商业化。

验收：

- [x] Builder 模式能保护创造性，不被 Startup 的商业拷问过早压死。
- [x] 但当用户实际在做产品时，能自动切换到更严格的 Startup 诊断。

---

### T-004：Premise Challenge 增强

问题：当前前提挑战只有 3 个问题，缺少前提列表化和用户确认。

待补：

- [x] 输出 `PREMISES`：把方案成立所依赖的前提列成明确陈述。
- [x] 每个前提标注脆弱度：高 / 中 / 低。
- [x] 每个前提给验证方法：最小实验、访谈、数据查询、代码探查。
- [x] 如果是新产物，补问分发计划：用户如何知道、如何拿到、为什么会转发或付费。
- [x] Startup 模式必须给诊断综合：需求强度、现状替代成本、目标楔子、商业风险。
- [x] 关键前提必须让用户 `agree / disagree / revise`，不能默默假设成立。

验收：

- [x] 每份设计文档都有 `PREMISES`。
- [x] 最脆弱前提有下一步验证动作。

---

### T-005：Related Design Discovery

问题：砺现在不会主动查历史设计，容易重复造轮子。

待补：

- [x] 在 Phase 2 后、方案生成前，搜索历史设计文档。
- [x] 搜索范围：`ai-workspace/*/artifacts/01-ideation/*.md`、`artifacts/**/*.md`、`docs/**/*.md`。
- [x] 如果找到相似设计，输出：可复用内容、冲突点、废弃原因、是否 supersede。
- [x] 设计文档模板增加 `Supersedes / Related Docs` 字段。

验收：

- [x] 新设计不会忽略已有相似方案。
- [x] 如果覆盖旧方案，能说明为什么。

---

### T-006：Landscape Awareness

问题：砺现在偏内部质疑，缺外部世界校准。

待补：

- [x] 对"值不值得做 / 创业 / 竞品 / 市场"类请求，允许使用 `web_search` 做轻量景观搜索。
- [x] 输出三层综合：
  - Layer 1：这个领域的常识是什么。
  - Layer 2：当前搜索结果 / 讨论热度 / 竞品在说什么。
  - Layer 3：结合用户上下文，常识是否可能是错的。
- [x] 禁止把搜索结果当结论；必须回到用户的具体楔子。

验收：

- [x] 对市场判断不只凭直觉。
- [x] 输出里能区分"外部共识"和"我们自己的反共识机会"。

---

### T-007：Cross-Agent Second Opinion

问题：缺少独立二评，砺容易单模型自洽。

待补：

- [x] 对 Deep 模式设计文档，调用 `隐·智囊` 做独立二评。
- [x] 二评输入必须包含：问题陈述、目标用户、前提、方案、风险、开放问题。
- [x] 二评输出聚焦：盲点、反例、替代解释、长期后果。
- [x] 设计文档增加 `Second Opinion` 字段。

验收：

- [x] Deep 模式不是砺单人闭门造车。
- [x] 如果二评反对，砺必须回应采纳 / 不采纳理由。

---

### T-008：Visual Sketch Handoff

问题：UI 类想法没有低成本视觉草图，后续设计容易跑偏。

待补：

- [x] 砺识别"网页 / App / UI / 页面 / 体验"类想法时，交给 `绘·设计` 生成 rough sketch。
- [x] 交接给绘的 Context Block 包含：目标用户、核心场景、不可做事项、情绪关键词、最小路径。
- [x] 砺不亲自做视觉稿，只提出设计判断和验收标准。

验收：

- [x] UI 类设计文档都有"是否需要视觉草图"的判断。
- [x] 需要时能自然流转到绘。

---

### T-009：Startup / Builder 双模板设计文档

问题：当前模板只有骨架，缺可追踪字段。

Startup 模板至少包含：

- [x] Branch / Repo / Status / Mode
- [x] Problem Statement
- [x] Demand Evidence
- [x] Target User & Narrowest Wedge
- [x] Current Alternative
- [x] Premises
- [x] Landscape Awareness
- [x] Options Considered
- [x] Recommended Path
- [x] Distribution Plan
- [x] Risks / Non-goals
- [x] The Assignment
- [x] Second Opinion
- [x] What I Noticed

Builder 模板至少包含：

- [x] Coolest Version
- [x] Intended Audience
- [x] Fastest Shareable Path
- [x] Closest Existing Thing
- [x] 10x Version
- [x] Prototype Plan
- [x] What I Noticed

验收：

- [x] 设计文档能直接交给 `锋` / `枢` / `矩` 使用。
- [x] 不再只是想法记录，而是可执行任务输入。

---

### T-010：Spec Review Loop

问题：设计文档现在写完就交，缺审查闭环。

待补：

- [x] 设计文档完成后进入 review loop。
- [x] 审查维度：完整性、一致性、清晰度、范围控制、可行性。
- [x] 最多 3 轮迭代，避免无限润色。
- [x] 可复用 `skills/artifact-review/` 或由 `矩` / `隐` 独立审查。
- [x] 审查结论写回设计文档：通过 / 有条件通过 / 需要重写。

验收：

- [x] Deep 模式的设计文档必须经过至少一次独立审查。
- [x] 审查意见有处理状态，不是只贴在聊天里。

---

## 2. P1 详细任务

### T-011：角色数量统一为 13

问题：部分文档仍写"10 个 AI Agent"，与当前 13 角色不一致。

待查文件：

- [x] `QUICKSTART.md`
- [x] `README.md`
- [x] `CLAUDE.md`
- [x] `AGENTS.md`
- [x] `PACKAGING.md`

验收：

- [x] 所有总览文档统一为 13 角色。
- [x] `寻`、`铸`、`启` 都出现在快捷指令表。

---

### T-012：快速入门补 `@启`、`@铸` 和 team 模式

待补：

- [x] `@启` / `@team`：完整流程自动编排。
- [x] `@铸` / `@dev` / `@forge`：代码实现。
- [x] 新会话直连、inline、team mode 三种运行方式的选择建议。
- [x] "不要 task / 不要 subagent"时的行为说明。

验收：

- [x] 新用户 5 分钟内能知道什么时候手动点角色，什么时候用 `@启`。

---

### T-013：CodeBuddy 适配层交接块统一

问题：部分 `agents_for_codebuddy/*.md` 的交接块过短，和 `PROTOCOL.md §2.2` 不完全一致。

待补：

- [x] 全部适配层使用统一字段：来源、阶段、产出类型、产物文件、状态、关键决策、开放问题、下游建议、阻塞项。
- [x] team 模式成员名统一使用单字：锋、砺、隐、枢、辞、寻、矩、绘、铸、鉴、盾、算、启。
- [x] 待命协议统一：初始化后不执行业务，等待 Leader 唤醒。

验收：

- [x] Leader 能稳定解析每个 Agent 的交接块。

---

### T-014：`.weiyige/` 与根目录同步规则明确

问题：当前项目同时有根目录角色定义、`.weiyige/`、`.codebuddy/agents/`，需要明确唯一编辑源和同步方式。

待补：

- [x] 在 `PACKAGING.md` 说明：根目录角色定义是源，`.weiyige/` 和 `.codebuddy/agents/` 是安装产物。
- [x] `install.sh --mode update` 的覆盖范围写清楚：覆盖核心定义，保留 memory。
- [x] 明确哪些文件不应手改：安装产物、memory、运行时状态。

验收：

- [x] 以后改 Agent 不会出现"改了源文件但运行时没生效"的混乱。

---

## 3. 建议执行顺序

### Milestone 1：砺 Office Hours v2

1. T-001 Context Gathering 标准化
2. T-002 Startup 六问 v2
3. T-003 Builder 5 问
4. T-004 Premise Challenge 增强
5. T-005 Related Design Discovery
6. T-006 Landscape Awareness
7. T-009 双模板设计文档
8. T-010 Spec Review Loop

完成标准：

- [x] `@砺 我有个想法...` 能先做上下文收集，再按 Startup / Builder 分流。
- [x] Deep 模式能产出可审查、可交接的设计文档。
- [x] UI 类想法能交给 `绘`，重大方案能交给 `隐` 做二评。

### Milestone 2：路由和适配层一致性

1. T-011 角色数量统一
2. T-012 快速入门更新
3. T-013 适配层交接块统一
4. T-014 同步规则明确

完成标准：

- [x] 新用户读 `QUICKSTART.md` 不会看到过期角色数量。
- [x] team 模式消息链路可追踪。

### Milestone 3：示例和验证

1. T-016 Office Hours v2 示例
2. T-017 team 模式端到端示例
3. T-018 安装脚本验证清单
4. T-019 质量指标采集口径

完成标准：

- [x] 有可复制的示例输入输出。
- [x] 安装 / 更新后能验证 13 个 Agent、3 个 Skill、协议文件都齐全。

---

## 4. Definition of Done

本轮完善真正完成，必须同时满足：

- [x] `合伙人_砺/SOUL.md` 中有完整 Office Hours v2 流程。
- [x] `合伙人_砺/SKILLS.md` 与 `SOUL.md` 不冲突。
- [x] `agents_for_codebuddy/砺·合伙人.md` 能正确加载 `.weiyige/合伙人_砺/` 并遵守待命协议。
- [x] `PROTOCOL.md` 能解释二评、视觉草图、Spec Review Loop 的交接方式。
- [x] `ROUTER.md` 能正确区分 `@砺`、`@锋`、`@隐`、`@启` 的使用边界。
- [x] `QUICKSTART.md` 不再出现 10 角色旧描述。
- [x] 至少有 1 个 Startup 示例和 1 个 Builder 示例。
- [x] 所有新增规则都有明确验收条件，而不是只写理念。

---

## 5. 非目标

- [x] 砺不写代码，不做实现。
- [x] Office Hours 不替代 `枢` 的 PRD，也不替代 `矩` 的工程方案。
- [x] 不把所有小问题都强制升级为 Deep 模式。
- [x] 不为了流程完整而牺牲速度；Quick 模式仍应保留。
- [x] 不在 team 不可用时静默降级为假团队流程。

---

## 6. 原始分析摘要

| 模块 | 当前完成度 | 目标 |
|---|---:|---|
| Office Hours 核心定位 | 90% | 保留 |
| Startup 六问 | 60% | 升级到可追问、可判断、可跳问 |
| Builder 模式 | 55% | 补齐 5 问和模式升级判断 |
| 上下文收集 | 35% | 标准化工具与输出 |
| 相关设计发现 | 0% | 新增 |
| 市场 / 景观搜索 | 0% | 新增 |
| 前提挑战 | 50% | 新增 PREMISES 与确认机制 |
| 跨 Agent 二评 | 0% | 新增 `隐` 二评 |
| 视觉草图联动 | 0% | 新增 `绘` 交接 |
| 设计文档模板 | 45% | Startup / Builder 双模板 |
| Spec Review Loop | 0% | 新增最多 3 轮审查 |
| Handoff / 后续建议 | 50% | 对齐 `PROTOCOL.md §2.2` |

结论：近期最值得做的是把 `砺·合伙人` 升级成真正的 `Office Hours v2`，再统一文档、路由和 CodeBuddy 适配层。

---

## 7. weiyige-ops v2 全局调度 Backlog（2026-05-04 新增）

> 背景：weiyige-ops 全局调度中心 v2 需求已在 `设计方案/weiyige-global-ops-design-v2.md` 中定义。
> 2026-05-04 首次全链路跑通：6 项目 6 任务并行 dispatch + team spawn + Worker 执行 + 收尾。

### P0：已实现（2026-05-04）

| ID | 事项 | 状态 |
|---|---|---|
| T-OPS-001 | spawn 机制：dispatch 后自动 spawn Worker | ✅ 已实现 |
| T-OPS-002 | CodeBuddy spawner：team_create + team member spawn（acceptEdits 模式） | ✅ 已实现 |
| T-OPS-003 | Claude Code spawner：claude -p 自动启动子进程 | ✅ 已实现 |
| T-OPS-004 | hold 机制：hold.json + poll 检测 + board 展示 | ✅ 已实现 |
| T-OPS-005 | resume-task.sh：中断恢复 + 决策注入 | ✅ 已实现 |
| T-OPS-006 | 环境自动感知：detect_environment() + --executor CLI | ✅ 已实现 |
| T-OPS-007 | Worker 统一协议：worker-prompt-template.md | ✅ 已实现 |
| T-OPS-008 | 并行 spawn：多 Worker 异步执行 | ✅ 已实现 |
| T-OPS-009 | Dashboard hold 展示：board.sh hold 计数 + badge | ✅ 已实现 |
| T-OPS-010 | 超时回收：zombie 检测 + 自动回收 | ✅ 已实现 |

### P1：待实现

| ID | 事项 | 说明 |
|---|---|---|
| T-OPS-011 | finish-task 日志回流 | finish-task.sh 执行结果不写 ops 日志文件 |
| T-OPS-012 | Worker 执行日志收集 | Worker 产出回流到 ops/logs/ |
| T-OPS-013 | Electron Dashboard 调度页增强 | 显示 Worker 实时进度、支持 team spawn 触发 |
| T-OPS-014 | 调度器自动 team spawn | dispatch 后自动调用 team_create + spawn，不需要主会话手动执行 |
| T-OPS-015 | project-status.json 自动刷新 | finish-task 后自动刷新对应项目的 status |

### P2：未来

| ID | 事项 | 说明 |
|---|---|---|
| T-OPS-016 | 晨报自动生成增强 | 汇总所有 Worker 产出、hold 队列、决策待办 |
| T-OPS-017 | 预算和 Token 追踪 | 每个 Worker 的 Token 消耗记录 |
| T-OPS-018 | 多用户 / 多机器调度 | Mac mini / 云主机常驻 |
| T-OPS-019 | CodeBuddy automation 定时轮询 | 定时检测 queue 有新任务时自动触发调度 |

### 已知限制

| 限制 | 说明 |
|---|---|
| CodeBuddy team member 标签 | UI 显示 "code-explorer subagent" 但实际有写权限（acceptEdits 模式） |
| CodeBuddy 无法自动触发 team spawn | dispatch 写了 spawn-command.json，但需要主会话手动读取并执行 team_create |
| WIP 上限需手动调整 | 6 个并行任务需临时改 projects.yaml max_parallel_tasks |