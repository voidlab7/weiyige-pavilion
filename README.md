# 维弈阁

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](./LICENSE) [![Based on gstack](https://img.shields.io/badge/Based%20on-gstack-green.svg)](https://github.com/garrytan/gstack)

> 一个人，一个 AI 团队。

你一个人干活，但身后站着一群人。

CEO 帮你拿方向，PM 帮你拆任务，架构师帮你审方案，QA 帮你找 bug，安全帮你堵漏洞，财务帮你算账，内容帮你写东西，设计帮你把关体验，合伙人专门挑刺，顾问帮你做研究。

11 个角色，各管一摊。你只需要说需求，剩下的事它们自己协调。

灵感来自 [gstack](https://github.com/garrytan/gstack) — Garry Tan 把自己当 CEO，让 Claude Code 当虚拟工程团队。维弈阁把这个思路做成了一个开箱即用的东西。

---

## 11 个角色

| 角色 | 干什么 |
|------|--------|
| 锋 · CEO | 方向对不对？该不该做？他拍板 |
| 枢 · PM | 任务怎么拆？什么时候交？他盯节奏 |
| 矩 · 架构 | 系统怎么设计？技术债多少？他审 |
| 绘 · 设计 | 体验行不行？设计规范了吗？她看 |
| 鉴 · QA | 哪里有 bug？用例覆盖了吗？他查 |
| 盾 · 安全 | 有没有漏洞？威胁模型建了吗？他堵 |
| 算 · 财务 | 划不划算？ROI 多少？她算 |
| 辞 · 内容 | 文案怎么写？AI 味去了吗？她润色 |
| 寻 · 探索 | 热点在哪？趋势怎样？他侦察 |
| 隐 · 顾问 | 需要深度研究？他钻进去 |
| 砺 · 合伙人 | YC 风格质疑，专门唱反调 |

### 每个角色不只是名字

```
CEO_锋/
├── IDENTITY.md    ← 性格、说话风格、沟通习惯
├── SOUL.md        ← 思维框架、决策逻辑、工作流
├── memory/        ← 记住的偏好、踩过的坑、积攒的知识
└── skills/        ← 专属技能（不是每个角色都有）
```

不是简单的 prompt，是一套完整的人设 + 方法论 + 记忆系统。

### Skills 全景图

基于 [Harness Engineering](https://mp.weixin.qq.com/s/nJS1qMGiR7gWl1A7tchy1Q) 范式，每个角色都有标准化的 Skill 卡片 —— 触发条件、输入、输出、工具、约束、示例，一张卡片说清楚一个能力。

> 同一模型，Skills 描述清楚的 Harness 比没有的，成功率从 42% 跳到 78%。

| 角色 | Skills | 能力概览 |
|------|--------|---------|
| 锋 · CEO | 5 | 战略审查 · 范围决策 · 不可逆决策审批 · 长期轨迹评估 · 优先级裁决 |
| 砺 · 合伙人 | 4 | YC办公时间 · 魔鬼代言人 · 前提挑战 · 替代方案生成 |
| 枢 · PM | 5 | 需求消歧义 · PRD撰写 · 优先级排序 · 进度管理 · 产品三角审查 |
| 矩 · 架构 | 5 | 工程审查 · 架构决策 · 性能基线 · 技术债评估 · 范围挑战 |
| 绘 · 设计 | 5 | 设计系统构建 · 设计计划评审 · 设计审计修复 · AI烂俗检测 · 竞品设计综合 |
| 鉴 · QA | 5 | 浏览器功能测试 · Bug修复 · 金丝雀监控 · 回归测试 · 7维度健康评分 |
| 盾 · 安全 | 5 | 安全审计 · 威胁建模 · 秘密考古 · 依赖供应链审计 · AI安全专项 |
| 辞 · 内容 | 6 | 内容创作 · De-AI-ify · Humanizer · 选题策划 · 爆款复盘 · 平台适配 |
| 算 · 财务 | 5 | 成本估算 · ROI分析 · 预算管理 · 模型选型优化 · 月度财务报告 |
| 寻 · 探索 | 8 | 热点雷达 · 趋势研判 · 竞品监控 · AI前沿追踪 · 学术文献分析 · 选题弹药供给 · 信号交叉验证 · 关联信号发现 |
| 隐 · 顾问 | 5 | 芒格多元思维 · 逆向思考 · 能力圈评估 · 历史案例映射 · 复利分析 |

**11 个角色，58 张 Skill 卡片。** 详见每个角色目录下的 `SKILLS.md`。

---

## 装上就能用

一条命令，装到你的项目里：

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex
```

装完打开项目，AI 会自动读取配置，激活整个团队。

### 不同工具

```bash
# Cursor (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash -s -- --tool cursor

# GitHub Copilot
curl -fsSL ... | bash -s -- --tool copilot

# Windows Cursor
irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex -Tool cursor
```

不指定 `--tool`，脚本自己检测你用的是哪个。

| 工具 | 配置文件 |
|------|---------|
| CodeBuddy / Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Windsurf | `.windsurfrules` |
| Cline | `.clinerules` |

### 已有配置文件？

不会覆盖。脚本会：

1. 备份原文件（`.weiyige-backup`）
2. 将维弈阁配置追加到原 `CLAUDE.md` 末尾
3. 恢复时用备份文件即可

### 试试

```
@辞 帮我写一篇公众号文章
@锋 这个方向靠谱吗
@矩 帮我审一下架构
```

懒得 @？直接说需求，路由器自动分发：

```
帮我优化这篇文章    → 辞
这个架构有问题吗    → 矩
有什么风险          → 砺
```

### 其他安装方式

```bash
# 装到指定项目 (macOS/Linux)
curl -fsSL ... | bash -s -- --target ~/my-project

# 最轻量（只要配置文件，不要角色定义）
curl -fsSL ... | bash -s -- --mode claude

# Windows 装到指定项目
irm ... | iex -Target "D:\my-project"

# 手动
git clone https://github.com/voidlab7/weiyige-pavilion.git
cd weiyige-pavilion && ./install.sh --target /path/to/your-project    # macOS/Linux
cd weiyige-pavilion && .\install.ps1 -Target "D:\your-project"        # Windows
```

---

## 思想脉络

维弈阁不是凭空造的。它站在几个关键思想的交汇点上：

### gstack — 种子

[gstack](https://github.com/garrytan/gstack) 是 Garry Tan 把工程经验编码成 AI Agent 协作框架 — CEO 审计划，架构师审设计，QA 打开浏览器真测。

维弈阁继承了这些：
- Markdown 定义角色（不是代码，是人设文档）
- 角色只管一件事（CEO 不管写代码，QA 不管方向）
- 评审不过不能往下走（计划不审不执行，代码不审不发）
- 每个决策都有文档留痕

不一样的地方：gstack 是工具箱，维弈阁是团队系统。每个角色有记忆，能成长，不是无状态的 prompt。

### Harness Engineering — 当前范式

2026 年，AI 行业的焦点从"造更强的发动机"转向"造更好的车"。汤道生在[《人工智能正式进入 Harness 时代》](https://mp.weixin.qq.com/s/nJS1qMGiR7gWl1A7tchy1Q)中提出：

> 大模型 = 发动机（原始动力），Harness = 线束（把动力传导到车轮的完整工作环境）。

关键数据：
- 同一模型 + 不同 Harness，编程成功率从 42% → 78%
- 同一模型 + 不同 Harness，Terminal Bench 2.0 从 52.8% → 66.5%
- 约束即引导 — 清晰的边界约束反而提高 Agent 生产力

维弈阁的 Skills 标准化（58 张 Skill 卡片）就是 Harness Engineering 的直接实践。每张卡片把"能干什么、怎么调用、约束在哪"写清楚，让同一个模型在维弈阁的线束里跑出更高的成功率。

### 工程进化脉络

```
2022-2025  Prompt Engineering     写指令 / 给地图
2025       Context Engineering    动态构建上下文 / 给导航
2026       Harness Engineering    搭建完整工作环境 / 造一辆车
```

维弈阁在做的就是第三步 — 不是写更好的 prompt，是搭建一个完整的工作环境：角色定义 + 协作协议 + 路由系统 + 标准化 Skills + 记忆系统 + 质量闭环。

---

## 目录结构

```
weiyige-pavilion/
├── CEO_锋/              # 方向决策（5 Skills）
├── PM_枢/               # 任务拆解 + 交付（5 Skills）
│   └── skills/prd-template.md
├── 架构_矩/             # 技术评审（5 Skills）
│   └── rules/eng-review/
├── 设计_绘/             # UX 评审（5 Skills）
│   └── rules/design-review/
├── QA_鉴/               # 测试（5 Skills）
│   └── rules/qa/
├── 安全_盾/             # 安全审计（5 Skills）
├── 财务_算/             # ROI + 成本（5 Skills）
├── 内容_辞/             # 文案 + 去 AI 味（6 Skills）
│   └── skills/          # de-ai-ify / humanizer / copywriting / wechat-html-writer
├── 探索_寻/             # 热点 + 趋势 + 竞品（8 Skills）
├── 顾问_隐/             # 深度研究（5 Skills）
├── 合伙人_砺/           # 魔鬼代言人（4 Skills）
├── CLAUDE.md            # 路由配置（冷启动入口）
├── install.sh           # 一键安装
└── .weiyige/            # 安装后的工作目录
```

---

## 相关链接

**思想源头**
- [gstack](https://github.com/garrytan/gstack) — Garry Tan 的 AI 虚拟工程团队框架
- [人工智能正式进入 Harness 时代](https://mp.weixin.qq.com/s/nJS1qMGiR7gWl1A7tchy1Q) — 汤道生，Harness Engineering 范式

**Agent 生态**
- [Claude Code](https://docs.anthropic.com/en/docs/agents) — Anthropic 的 Agent 文档
- [Cursor Rules](https://docs.cursor.com/context/rules-for-ai) — Cursor 的 AI 规则系统
- [OpenClaw](https://github.com/openclaw/openclaw) — Agent 框架

**维弈阁**
- [GitHub](https://github.com/voidlab7/weiyige-pavilion) — 源码和文档
- [成长日记](./成长日记/) — 维弈阁从 0 到 1 的设计过程和踩坑记录

---

## 署名与版权

- **维弈阁**（Weiyige Pavilion）由 [voidlab7](https://github.com/voidlab7) 独立设计与开发
- 思想源头：[gstack](https://github.com/garrytan/gstack) by [Garry Tan](https://github.com/garrytan)
- 本项目以 [GPL-3.0](./LICENSE) 协议开源
- 基于本项目创建衍生作品，必须以 GPL-3.0 发布，并保留对 gstack 和维弈阁的署名
- 详见 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

*维弈阁 — 一个人的团队。*
