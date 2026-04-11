# 维弈阁（Weiyige Pavilion）

> 一个人，一个 AI 团队，10x 生产效率。

维弈阁是一个**多角色 AI Agent 团队**，基于 [gstack](https://github.com/garrytan/gstack) 的设计思想构建。每个 Agent 拥有独立的人格、思维框架和专业知识，协同完成从战略规划到产品交付的全流程。

灵感来源：[gstack](https://github.com/garrytan/gstack) — Garry Tan 的开源软件工厂，将 Claude Code 变成虚拟工程团队。

---

## 核心优势

### 🎯 专业化分工，术业有专攻

每个 Agent 只做自己最擅长的事：

| Agent | 角色 | 核心职责 |
|-------|------|---------|
| CEO_锋 | 战略决策者 | 范围审查、计划审查、方向把控 |
| PM_枢 | 项目协调者 | 任务拆解、进度管理、交付节奏 |
| QA_鉴 | 测试专家 | 用例设计、缺陷发现、质量把关 |
| 安全_盾 | 安全审计 | OWASP/STRIDE 威胁模型、渗透测试 |
| 财务_算 | 财务分析 | ROI 评估、成本核算、预算把控 |
| 顾问_隐 | 战略顾问 | 深度研究、战略建议 |
| 合伙人_砺 | 魔鬼代言人 | YC 风格质疑、挑战前提、守住底线 |
| 架构_矩 | 架构师 | 系统设计、技术评审、技术债务 |
| 内容_辞 | 内容运营 | 文案创作、品牌内容、去 AI 味儿 |
| 设计_绘 | 设计评审 | UX 评审、设计规范、可访问性 |

### 🧠 每个 Agent 都有灵魂

每个 Agent 目录包含：

- **`IDENTITY.md`** — 身份定义：名字、角色、性格、沟通风格
- **`SOUL.md`** — 思维框架：核心工作流、专业方法论、决策模式
- **`rules/`** — 评审规则（部分 Agent）
- **`skills/`** — 技能定义（部分 Agent）

### 🔗 基于 gstack 的设计思想

gstack 的核心哲学是**让 AI Agent 像真实团队一样协作**，维弈阁继承并扩展了这一理念：

```
gstack 理念                      | 维弈阁实现
---------------------------------|---------------------------
SKILL.md 标准（Markdown 角色定义）| 每个 Agent 的 IDENTITY.md/SOUL.md
/plan-ceo-review（CEO 审查）    | CEO_锋 的计划审查流程
/plan-eng-review（架构审查）     | 架构_矩 的技术评审
/plan-design-review（设计评审）   | 设计_绘 的 UX 评审
/office-hours（顾问时间）        | 顾问_隐 + 合伙人_砺 的质疑流程
/qa（质量保障）                  | QA_鉴 的测试评审
/guard（安全审计）               | 安全_盾 的威胁建模
```

维弈阁与 gstack 的区别在于：**gstack 是个人生产力工具箱，维弈阁是多角色团队协作系统**。每个角色不只是工具调用，而是拥有完整人格的 Agent。

---

## 架构

```
weiyige-pavilion/
├── CEO_锋/           # 战略层：范围决策、计划审查
│   ├── IDENTITY.md
│   └── SOUL.md
├── PM_枢/            # 执行层：任务拆解、交付协调
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── rules/
├── 架构_矩/         # 技术层：系统设计、代码评审
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── rules/eng-review/
├── 设计_绘/         # 设计层：UX 评审、设计规范
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── rules/design-review/
├── QA_鉴/           # 质量层：测试策略、缺陷分析
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── rules/qa/
├── 安全_盾/         # 安全层：威胁模型、安全审计
│   ├── IDENTITY.md
│   └── SOUL.md
├── 财务_算/         # 财务层：ROI 分析、成本评估
│   ├── IDENTITY.md
│   └── SOUL.md
├── 内容_辞/         # 内容层：文案创作、技能库
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── skills/
│       ├── de-ai-ify.md   # 去 AI 味儿
│       └── humanizer.md   # 人类化写作
├── 顾问_隐/         # 战略层：深度研究、方向建议
│   ├── IDENTITY.md
│   └── SOUL.md
├── 合伙人_砺/       # 挑战层：魔鬼代言人、质疑一切
│   ├── IDENTITY.md
│   └── SOUL.md
└── README.md
```

### 协作流程

```
用户输入
   │
   ▼
┌──────────┐    战略方向     ┌──────────┐
│ CEO_锋   │ ─────────────▶ │ 顾问_隐  │
│ 战略决策  │                │ 深度研究  │
└────┬─────┘                └────┬─────┘
     │                           │
     ▼                           ▼
┌──────────┐    质疑挑战     ┌──────────┐
│ 合伙人_砺 │ ◀───────────── │ (输入)   │
│ 魔鬼代言  │                └──────────┘
└────┬─────┘
     │ 方案确定
     ▼
┌──────────┐    技术评审     ┌──────────┐
│ 架构_矩  │ ─────────────▶ │  PM_枢   │
│ 系统设计  │                │ 任务拆解  │
└────┬─────┘                └────┬─────┘
     │                           │
     ▼                           ▼
┌──────────┐                ┌──────────┐
│ 设计_绘  │                │  QA_鉴   │
│ UX 评审  │                │ 测试策略  │
└────┬─────┘                └────┬─────┘
     │                           │
     ▼                           ▼
┌──────────┐                ┌──────────┐
│ 安全_盾  │                │ 财务_算  │
│ 威胁建模  │                │ ROI 评估  │
└──────────┘                └──────────┘
```

---

## 与 gstack 的关系

[gstack](https://github.com/garrytan/gstack) 是维弈阁的思想源头。Garry Tan 将自己的工程经验编码为一套 AI Agent 协作框架——CEO 审查计划、架构师评审设计、QA 打开真实浏览器测试。

**维弈阁的定位**：将这套思想产品化，构建一个**开箱即用的多 Agent 团队**。你可以直接使用这套角色定义，也可以 fork 后根据自己的工作流定制。

核心继承：
- **SKILL.md 标准**：用 Markdown 定义 Agent 身份和技能
- **角色专业化**：每个 Agent 有且只有一个核心职责
- **协作评审**：计划不经审查不执行，代码不经评审不发布
- **可观测性**：每个决策和评审结果都输出为结构化文档

---

## 快速开始

```bash
# Clone 仓库
git clone https://github.com/voidlab7/weiyige-pavilion.git
cd weiyige-pavilion

# 查看所有 Agent
ls -la */

# 查看特定 Agent 的身份
cat CEO_锋/IDENTITY.md
cat CEO_锋/SOUL.md
```

每个 `IDENTITY.md` + `SOUL.md` 组合就是一个完整的 Agent 定义，可直接导入任何支持 SKILL.md 标准的 AI Agent 系统（如 Claude Code、OpenClaw）。

---

## 相关链接

- **gstack**: https://github.com/garrytan/gstack
- **OpenClaw**: https://github.com/openclaw/openclaw
- **维弈阁 GitHub**: https://github.com/voidlab7/weiyige-pavilion

---

*维弈阁 — 用 AI Agent 重建一个人的团队。*
