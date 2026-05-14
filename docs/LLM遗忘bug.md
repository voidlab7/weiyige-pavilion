这是一个核心问题——**如何让 LLM 不偷懒、不跳过协议**。让我先看当前 AGENTS.md 和加载链路的实际情况：
分析非常详细。现在直接给你结论：

---

## 核心问题：LLM 偷懒的本质

LLM 不是"故意偷懒"，而是**在多份指令互相矛盾时，选择了消耗最少 token 的路径**。当前维弈阁的加载体系有 3 个结构性缺陷：

### 缺陷 1：同一规则多处定义，版本不一致

| 文件 | 位置 A（根目录） | 位置 B（.weiyige/） | 差异 |
|------|----------------|-------------------|------|
| SHARED.md | v2（含 CLI 闭环） | v1（无 CLI 闭环） | 内容不同 |
| ROUTER.md | 根目录 | .weiyige/ | 可能不同步 |
| SOUL.md | 根目录（空模板） | .weiyige/{角色}/ | 根级是 OpenClaw 空壳 |

**结果**：AI 读到根级空 SOUL.md → "这角色没方法论" → 跳过。

### 缺陷 2：CLAUDE.md 和 LOADER.md 自相矛盾

- **CLAUDE.md**："SOUL.md 必读，不可跳过"
- **LOADER.md**："Quick 模式只加载 IDENTITY.md，不加载 SOUL.md"

AI 面对矛盾指令，选择哪个？**取决于它当时 context 窗口里哪个离用户请求更近**。

### 缺陷 3：入口文件太长，关键规则被淹没

CLAUDE.md 240 行——路由表、意图映射、加载清单、技能映射、交接块标准全塞一起。LLM 的注意力机制对**开头和结尾**权重高，中间部分容易被"软忽略"。

---

## 解决方案：三层防线

### 防线 1：单一真相源（消除矛盾）

```
当前：根目录 SHARED.md ≠ .weiyige/SHARED.md，AI 不知道该听谁的
改后：根目录只放 symlink 或直接删除，.weiyige/ 是唯一真相源
```

需要做：
- 删除根目录 `SHARED.md`、`ROUTER.md`、`SOUL.md`（空模板）、`IDENTITY.md`（空模板）
- 或改为 symlink 指向 `.weiyige/` 下的对应文件
- CLAUDE.md 和 LOADER.md **二选一作为加载规范**，另一个引用它

### 防线 2：CLAUDE.md 精简为"10 条铁律"（注意力聚焦）

当前 240 行的 CLAUDE.md 应该拆分：

```
CLAUDE.md（≤50 行）— 只放"绝对不可违反的铁律"
  │
  ├── 铁律 1: 禁止直接写 state.json，必须走 weiyige-cli
  ├── 铁律 2: 每个角色激活必须读 .weiyige/{角色}/IDENTITY.md
  ├── 铁律 3: 产出文件必须实际写入，不可只在对话中输出
  ├── 铁律 4: 交接时必须调用 weiyige-cli handoff
  ├── 铁律 5: 门禁不可跳过，weiyige-cli gate 先过 Layer 0
  ├── ...
  └── 详细路由规则 → 见 .weiyige/ROUTER.md
      详细加载规则 → 见 .weiyige/LOADER.md
      完整协议 → 见 .weiyige/PROTOCOL.md
```

**原理**：LLM 对 system prompt 前 50 行的遵从度远高于第 200 行。把最关键的规则放在最前面、最短的文件里。

### 防线 3：CLI 强制（代码约束 > 文字约束）

这是上轮已经实现的——把关键规则从"Markdown 文字"变成"CLI 拒绝执行"：

```
文字约束："禁止跳阶段"        → AI 可能忽略
代码约束：update-phase 检测依赖 → exit 1，阻止写入
```

**三层防线的关系**：

```
防线 1（单一真相源）→ AI 没有"选择性理解"的空间
防线 2（铁律精简）  → AI 的注意力集中在最关键的规则上
防线 3（CLI 强制）  → 即使 AI 想偷懒，代码也拦住
```

---

## 具体行动建议

| 优先级 | 行动 | 效果 |
|--------|------|------|
| **P0** | CLAUDE.md 精简到 ≤50 行铁律，详细规则外链 | 遵从度从 ~60% → ~90% |
| **P0** | 删除/symlink 根目录重复文件（SHARED/ROUTER/SOUL/IDENTITY） | 消除矛盾指令 |
| **P0** | LOADER.md 统一为 CLAUDE.md 的权威加载规范（CLAUDE.md 引用它而非重复它） | 消除 SOUL.md 是否必读的歧义 |
| **P1** | weiyige-ops 添加 CLAUDE.md（引用 pavilion 的规则 + ops 专属规则） | ops 单独开会话时也有规则 |
| **P1** | `.codebuddy/agents/*.md` 的加载清单与 CLAUDE.md 对齐 | 两个入口一套规则 |

要现在开始做 P0 吗？