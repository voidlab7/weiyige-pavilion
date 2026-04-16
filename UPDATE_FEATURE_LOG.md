# 维弈阁更新日志（Changelog）

> 从 0 到 1 的完整成长记录。每一次升级都是一次认知迭代。

---

## v1.6 — 2026-04-16 · Team Mode + 产物验证

**主题：墨 · 执事的大脑升级**

墨从"能调度"进化到"智能调度"——支持 CodeBuddy Team Mode 运行时，阶段门禁增加产物验证机制。

### 变更

- **墨 · 执事 v3.0**：三种编排模式上线（auto / confirm / step）
  - auto：全链路自动执行，仅失败或需要信息时停下
  - confirm：阶段切换时暂停等用户确认
  - step：每个 Agent 后暂停
  - 平台无关——不依赖 CodeBuddy Team Mode 也能工作
- **Team Mode 支持**：墨可以利用 CodeBuddy `task` 工具的 `name` / `team_name` 参数，并行 spawn Agent
- **产物验证机制**：阶段门禁从"Agent 说通过就通过"升级为"见文件才过门禁"
- **CodeBuddy Agent 目录修正**：`agent/` → `agents/`（匹配 CodeBuddy 实际目录名）
- **AGENTS.md**：新增团队全员索引文件

### 思考

> 调度器的价值不在于它自己能干什么，而在于它能让其他人更高效地干活。墨的三种模式让用户可以在"完全信任"和"逐步确认"之间自由选择。

---

## v1.5 — 2026-04-15 · Harness 进化（Phase 6）

**主题：从"全靠 LLM 判断"到"计算型检查 + LLM 审查"双层约束**

这是维弈阁工程质量的分水岭。受 Martin Fowler / Birgitta Böckeler 的 Harness Engineering 论文启发，一次性落地 8 个 Harness 进化项。

### 变更

- **[H-01] 计算型检查前置**：矩（工程审查）和鉴（QA）的 Skill 流程第一步改为先跑 Lint / 类型检查 / 单元测试，再做 LLM 审查
- **[H-02] 开发阶段左移检查**：PROTOCOL.md 开发阶段增加"代码生成后立即跑计算型检查"原则
- **[H-03] 教训→规则自动升级**：MEMORY.md 增加规则升级触发器——同类 lesson 出现 2 次，自动转化为 `.mdc` 规则文件
- **[H-04] 墨串联 Agent 链**：执事_墨/SOUL.md 完善编排逻辑，支持无人值守的全链路自动执行
- **[H-05] 多 Agent 并行审查**：无依赖关系的审查步骤并行执行（矩+绘并行），总耗时缩短 40%+
- **[H-06] 驾驭性评估**：矩新增 Skill——评估项目的 AI 友好度（强类型覆盖、模块边界、测试覆盖率）
- **[H-07] PRD→可测试规格→自动测试**：枢的 PRD 模板增加 Given/When/Then 验收标准，鉴据此自动生成测试
- **[H-08] Token 成本看板**：算（财务）新增成本报告 Skill

### 思想来源

- [Harness Engineering](https://martinfowler.com/articles/harness-engineering.html) — Birgitta Böckeler (Martin Fowler's blog, 2026-04-02)

### 思考

> Martin Fowler 文章的核心洞察：Agent = Model + Harness。Harness 分两类——前馈（Guides，提前告诉 Agent 该怎么做）和反馈（Sensors，事后检查做得对不对）。维弈阁之前只有前馈（SOUL.md / PROTOCOL.md），没有反馈（计算型检查）。补上这一层，同一模型的成功率就能从 42% 跳到 78%。

---

## v1.4 — 2026-04-14 · 执事 · 墨（自动编排器）

**主题：从"人肉路由"到"一句话全链路"**

维弈阁终于有了自己的调度器。不再需要用户手动 @枢 → @矩 → @绘 → @鉴 逐个串联。

### 变更

- **新增角色：执事 · 墨**（第 12 个角色）
  - 定位：自动编排器（AI Harness），不干活只调度
  - 接收用户顶层任务，通过 CodeBuddy `task` 工具自动 spawn 子 Agent
  - 解析交接块（Handoff Block）驱动下一步，直到全链路完成
  - 预设链路：新功能开发、Bug 修复、设计审查、内容创作、安全审计
- **ROUTER.md 更新**：增加墨的路由入口
- **辞 · 内容新增技能**：热文解构 Skill
- **安装脚本修复**：`SKILLS.md` 未被安装 + `install_update_mode` 函数缺失
- **update 模式上线**：一键更新已安装的维弈阁，保留用户 memory 数据

### 灵感来源

> 墨的设计灵感来自 Sigrid Jin 的 AI Harness 理念——Agent 不需要人肉一个个 @，需要一个调度器把它们串起来。墨不写代码、不审方案、不做设计，它只做一件事：确保正确的 Agent 在正确的时机被调用。

---

## v1.3 — 2026-04-13 · Harness Engineering 标准化

**主题：58 张 Skill 卡片 + 新角色「寻 · 探索」**

这是维弈阁从"人设集合"到"标准化 Harness"的关键转折。每个角色不再只有 SOUL.md 的自由文本，而是有了结构化的 Skill 卡片。

### 变更

- **全员 Skills 标准化**：11 个角色（不含墨）共 58 张 Skill 卡片，每张包含触发条件、输入、输出、工具、约束、示例
- **新增角色：寻 · 探索**（第 11 个角色）
  - 8 个 Skills：热点雷达、趋势研判、竞品监控、AI前沿追踪、学术文献分析、选题弹药供给、信号交叉验证、关联信号发现
- **Windows 支持**：新增 `install.ps1` PowerShell 安装脚本
- **README 大改**：增加 Skills 全景图、思想脉络、相关链接

### 为什么是 Harness Engineering

> 汤道生在[《人工智能正式进入 Harness 时代》](https://mp.weixin.qq.com/s/nJS1qMGiR7gWl1A7tchy1Q)中提出：大模型 = 发动机，Harness = 线束。关键数据：同一模型 + 不同 Harness，Terminal Bench 2.0 从 52.8% → 66.5%。
>
> 维弈阁的 Skills 标准化就是在给发动机装线束——同样的 Claude/GPT，有标准化 Skill 卡片的维弈阁比裸跑 prompt 的成功率高一倍。

---

## v1.2 — 2026-04-12 · 多 Agent 模式 + 开源

**主题：CodeBuddy 原生多 Agent + GPL-3.0 开源**

### 变更

- **新增 `agents_for_codebuddy/` 目录**：为 CodeBuddy 的多 Agent 模式提供适配文件
  - 每个 `.md` 文件通过 YAML frontmatter 定义 Agent 的 name、description、model、tools
  - Agent 被激活后自动读取 `.weiyige/` 下的完整知识库
  - 两种模式（规则模式 / 多 Agent 模式）可以共存
- **CLAUDE.md 更新**：增加多 Agent 模式说明、CodeBuddy Agent 入口
- **安装脚本更新**：支持拷贝 `agents_for_codebuddy/` 到项目 `.codebuddy/agents/`
- **正式开源**：添加 GPL-3.0 LICENSE + CONTRIBUTING.md + README 版权声明

### 思考

> 规则模式的 CLAUDE.md 是"单入口路由"——所有请求走同一个 AI 实例，靠 prompt 切换角色。多 Agent 模式是"多实例隔离"——每个 Agent 是独立的 AI 会话，有自己的工具权限和模型配置。前者简单通用，后者更强更灵活。

---

## v1.1 — 2026-04-11 · 协作协议 + 记忆系统 + 路由器

**主题：从 10 个孤岛到一个团队**

这是维弈阁最大的一次升级。一天之内完成了工程深度评估提出的几乎所有 P0 和 P1 项。

### 变更

- **PROTOCOL.md**（TODO-001 ✅）：定义 Agent 间的协作协议
  - RACI 矩阵：每个决策类型的负责/审批/咨询/知会角色
  - 交接块格式：结构化的 Agent 间信息传递
  - 阶段门禁：产出必须审查通过才能流转
  - 冲突解决链：用户 > 锋 > 矩 > 其他
  - 反馈闭环：审查不过→修改→再审，最多 3 轮
- **MEMORY.md**（TODO-002 ✅）：三层记忆系统
  - 长期（Agent memory/）、中期（项目 memory/）、短期（对话上下文）
  - 自动沉淀偏好、教训、知识
  - 教训→规则升级路径
- **ROUTER.md**（TODO-004 ✅）：智能路由器
  - 基于意图信号词的自动路由
  - 层级路由：先判断层（战略/执行/质量），再判断 Agent
  - 支持复合意图（串行+并行）
- **反馈闭环**（TODO-003 ✅）：审查流程增加迭代循环
- **职责边界清理**（TODO-006 ✅）：消除 Agent 间的职责重叠
- **Quick 模式**（TODO-007 ✅）：三档模式（Quick / Standard / Deep）
- **硬编码定价修复**（TODO-008 ✅）：相对定价替代绝对价格
- **QUICKSTART.md**（TODO-009 ✅）：5 分钟上手教程
- **待装载 Skills**（TODO-010 ✅）：PM_枢 PRD 模板 + 辞的 copywriting 等
- **版本管理**（TODO-011 ✅）：每个 SOUL.md 增加版本号和变更日志
- **README 去 AI 味重写**（辞出品）
- **安装脚本迭代**：
  - 一键安装（curl | bash 远程安装）
  - Bash 3.x 兼容（macOS 默认）
  - 多工具支持（不覆盖用户配置）
  - 自动备份用户配置文件

### 触发事件

> 2026-04-11 做了一次工程深度评估（第一性原理 + 查理·芒格多元思维模型），发现当时的维弈阁有 10 个 Agent 但 0 条协作协议、0 条记忆、0 个路由器。评估报告的结论是："10 个 Agent 就是 10 个孤岛，用户被迫充当人肉路由器"。当天就把 P0-P2 的 10 个 TODO 全部落地。

---

## v1.0 — 2026-04-11 · 初始提交

**主题：10 个 Agent 的第一次呼吸**

维弈阁正式诞生。基于 gstack 思想，从零设计了 10 个角色的多 Agent 团队系统。

### 包含

- **10 个角色**：CEO_锋、PM_枢、架构_矩、设计_绘、QA_鉴、安全_盾、财务_算、内容_辞、顾问_隐、合伙人_砺
- **每个角色**：IDENTITY.md（身份）+ SOUL.md（灵魂）+ memory/（空目录）
- **CLAUDE.md**：路由中枢入口
- **install.sh**：一键安装脚本

### 已知不足（v1.0 的诚实自评）

- 10 个 Agent 是 10 个孤岛，没有协作协议
- memory 全空，从未跑过真实项目
- 没有路由器，用户要手动 @ 每个 Agent
- 没有反馈闭环，审查是单向输出
- 没有版本管理

> 这些不足在 v1.1 中全部解决。

---

## 思想演进时间线

```
2026-04-11  v1.0    种子 — gstack 启发，10 角色诞生
     │
     │  ← 工程深度评估（第一性原理 + 芒格多元思维）
     │  ← 发现致命缺陷：0 协议、0 记忆、0 路由
     │
2026-04-11  v1.1    骨架 — 协作协议 + 记忆系统 + 路由器（一天完成 10 个 TODO）
     │
2026-04-12  v1.2    开源 — CodeBuddy 多 Agent 模式 + GPL-3.0
     │
2026-04-13  v1.3    标准化 — 58 张 Skill 卡片 + 探索(寻)角色 + Windows 支持
     │
     │  ← Harness Engineering 范式影响
     │  ← "同一模型 + 不同 Harness，成功率 42% → 78%"
     │
2026-04-14  v1.4    编排 — 执事(墨)自动编排器上线，从人肉路由到一句话全链路
     │
     │  ← Martin Fowler Harness Engineering 论文
     │
2026-04-15  v1.5    双层约束 — 8 个 Harness 进化，计算型检查 + LLM 审查
     │
2026-04-16  v1.6    智能调度 — 墨 v3.0 三模式 + Team Mode + 产物验证
     │
     ▼
    下一步…
```

---

## 核心指标

| 指标 | v1.0 | v1.6（当前） |
|------|------|-------------|
| 角色数 | 10 | 12（+探索寻、+执事墨） |
| Skill 卡片 | 0 | 58 |
| 协作协议 | 无 | PROTOCOL.md（RACI + 交接块 + 门禁 + 闭环） |
| 记忆系统 | 空目录 | 三层记忆 + 教训→规则升级 |
| 路由器 | 无 | ROUTER.md（意图 + 信号词 + 层级路由） |
| 自动编排 | 无 | 墨·执事（auto/confirm/step 三模式） |
| 支持平台 | macOS/Linux | + Windows + CodeBuddy 多 Agent |
| 计算型检查 | 0 | Lint/类型检查/测试左移 |
| 开源协议 | 无 | GPL-3.0 |

---

*每一次升级，都是在同一个核心信念上加砖：**一个人 + AI = 一个团队**。*
