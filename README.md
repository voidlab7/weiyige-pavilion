# 维弈阁

> 一个人，一个 AI 团队。

你一个人干活，但身后站着一群人。

CEO 帮你拿方向，PM 帮你拆任务，架构师帮你审方案，QA 帮你找 bug，安全帮你堵漏洞，财务帮你算账，内容帮你写东西，设计帮你把关体验，合伙人专门挑刺，顾问帮你做研究。

10 个角色，各管一摊。你只需要说需求，剩下的事它们自己协调。

灵感来自 [gstack](https://github.com/garrytan/gstack) — Garry Tan 把自己当 CEO，让 Claude Code 当虚拟工程团队。维弈阁把这个思路做成了一个开箱即用的东西。

---

## 10 个角色

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

---

## 装上就能用

一条命令，装到你的项目里：

```bash
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash
```

装完打开项目，AI 会自动读取配置，激活整个团队。

### 不同工具

```bash
# Cursor
curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash -s -- --tool cursor

# GitHub Copilot
curl -fsSL ... | bash -s -- --tool copilot

# Windsurf / Cline 同理
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
2. 生成独立的 `CLAUDE-weiyige.md`
3. 提示你在原文件里加一行引用

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
# 装到指定项目
curl -fsSL ... | bash -s -- --target ~/my-project

# 最轻量（只要配置文件，不要角色定义）
curl -fsSL ... | bash -s -- --mode claude

# 手动
git clone https://github.com/voidlab7/weiyige-pavilion.git
cd weiyige-pavilion && ./install.sh --target /path/to/your-project
```

---

## 和 gstack 的关系

[gstack](https://github.com/garrytan/gstack) 是种子。Garry Tan 把工程经验编码成 AI Agent 协作框架 — CEO 审计划，架构师审设计，QA 打开浏览器真测。

维弈阁做了什么？把它产品化了。角色定义、协作协议、路由系统、技能库……直接拿来用，或者 fork 后改。

继承的东西：
- Markdown 定义角色（不是代码，是人设文档）
- 角色只管一件事（CEO 不管写代码，QA 不管方向）
- 评审不过不能往下走（计划不审不执行，代码不审不发）
- 每个决策都有文档留痕

不一样的地方：gstack 是工具箱，维弈阁是团队系统。每个角色有记忆，能成长，不是无状态的 prompt。

---

## 目录结构

```
weiyige-pavilion/
├── CEO_锋/              # 方向决策
├── PM_枢/               # 任务拆解 + 交付
│   └── skills/prd-template.md
├── 架构_矩/             # 技术评审
│   └── rules/eng-review/
├── 设计_绘/             # UX 评审
│   └── rules/design-review/
├── QA_鉴/               # 测试
│   └── rules/qa/
├── 安全_盾/             # 安全审计
├── 财务_算/             # ROI + 成本
├── 内容_辞/             # 文案 + 去 AI 味
│   └── skills/          # de-ai-ify / humanizer / copywriting
├── 顾问_隐/             # 深度研究
├── 合伙人_砺/           # 魔鬼代言人
├── CLAUDE.md            # 路由配置（冷启动入口）
├── install.sh           # 一键安装
└── .weiyige/            # 安装后的工作目录
```

---

## 相关链接

- [gstack](https://github.com/garrytan/gstack) — 思想源头
- [OpenClaw](https://github.com/openclaw/openclaw) — Agent 框架
- [维弈阁 GitHub](https://github.com/voidlab7/weiyige-pavilion)

---

*维弈阁 — 一个人的团队。*
