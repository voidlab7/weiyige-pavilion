我来看看 gstack 项目的整体结构，了解它目前有哪些功能，再判断是否缺少协作或记忆系统。
[查找目录中]
[读取文件中]
[读取文件中]
[读取文件中]
[读取文件中]
现在我对 gstack 有了全面的了解，可以给你一个深入的分析。

---

## gstack 的协作与记忆系统现状分析

### 现有的"协作"能力

gstack 目前的协作支持是**有限但存在的**：

1. **Conductor 集成**（README 提到）：通过 [Conductor](https://conductor.build) 可以并行运行多个 Claude Code 会话，每个会话跑不同的 skill。这是目前最接近"多 agent 协作"的机制，但它是外部工具，不是 gstack 内置的。

2. **跨 agent 支持**：`/codex` skill 可以让 Claude 调用 OpenAI Codex 做独立 code review，实现了有限的跨模型协作。

3. **团队共享 skills**：通过 `cp -Rf ~/.claude/skills/gstack .claude/skills/gstack` 把 skills 提交到 repo，让队友共享同一套工作流。

---

### 现有的"记忆"能力

gstack 有**分散的、文件级别的记忆**，但没有统一的记忆系统：

| 记忆类型 | 实现方式 | 位置 |
|---------|---------|------|
| 设计决策 | `/office-hours` 写 design doc | `~/.gstack/projects/$SLUG/` |
| 发布历史 | `/retro` 写 JSON 快照 | `.context/retros/*.json` |
| QA 基线 | `/qa` 写 `baseline.json` | 项目根目录 |
| Greptile 历史 | `/review` 写 false positive 记录 | `greptile-history.md` |
| 遥测数据 | 本地 JSONL + Supabase | `~/.gstack/` |
| 会话追踪 | touch 文件 | `~/.gstack/sessions/$PPID` |

这些记忆是**孤岛式的**——每个 skill 自己管自己的状态，没有统一的跨 skill 记忆层。

---

### 真正缺少的是什么

**1. 团队共享记忆（Team Memory）**

TODOS.md 里有一条 `Design docs → Supabase team store sync`（P2），说明作者自己也意识到了这个问题：

> "Cross-team design discovery at scale. Local `~/.gstack/projects/$SLUG/` keyword-grep discovery works for same-machine users now, but Supabase sync makes it work across the whole team."

目前 design docs、retro 快照、QA 报告都是本地的，多人协作时无法共享。

**2. 跨 skill 的上下文传递**

虽然 README 说"每个 skill 知道前一步做了什么"（design doc → plan → review），但这个传递是**约定式的**（靠 skill 自己去读文件），不是系统级的。如果某个 skill 没有读上一步的输出，信息就断了。

**3. 多 agent 实时协作**

目前没有内置的机制让两个 agent 同时工作在同一个任务上（比如一个写代码，另一个实时 review）。Conductor 是外部工具，且需要额外付费。

**4. 持久化的项目知识库**

没有类似"这个项目的架构决策历史"、"这个模块的已知坑"这样的长期知识积累机制。每次新会话，agent 都要重新从代码里推断上下文。

---

### 总结

gstack 的定位是**单人 solo founder 的 AI 工程团队**，协作和记忆都是围绕这个场景设计的——够用，但不是重点。

如果你的场景是**真实的多人团队协作**，gstack 目前确实有明显缺口：
- 没有共享的团队记忆层（Supabase sync 还在 TODO）
- 没有内置的多 agent 实时协调机制
- 跨 skill 的上下文传递依赖文件约定，容易断链

这些在 TODOS.md 里有部分规划（P2 级别），但尚未实现。