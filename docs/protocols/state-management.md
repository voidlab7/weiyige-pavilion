# 状态管理解读

> 为什么用 CLI 管状态？协议本身在 `SHARED.md §4`，这里是设计意图。

---

## 解决的问题

两个核心痛点：

1. **AI 对协议的遵从度**：靠 Markdown 文字约束 AI "禁止手动写 state.json"，AI 经常忽略
2. **角色状态不同步到 ops**：AI 忘记更新 `project-status.json`，Dashboard 看不到实时状态

## 从"文档约束"到"代码约束"

```
旧方案：AI 读协议 → 自觉遵守 → 手动写文件（经常忘）
新方案：AI 调 CLI → CLI 强制执行检查 + 自动写文件（不可能忘）
```

### 为什么 CLI 比 Markdown 规则有效

| 维度 | Markdown 约束 | CLI 约束 |
|------|-------------|---------|
| 状态更新 | AI 自觉写 12 个字段 → 经常漏 | CLI 自动写 → 不可能漏 |
| 产物验证 | AI 说"已检查" → 可能造假 | `fs.existsSync` → 确定性 |
| Layer 0 门禁 | AI 读 gate.md 自己勾选 | CLI 执行返回结果 |
| 交接记录 | AI 输出 Markdown → 可能忘 | CLI 写 JSONL → 结构化 |
| ops 同步 | AI 记得更新 project-status.json | CLI 每次命令自动同步 |
| 跳阶段 | AI 可能忽略依赖 | CLI 检测前置阶段 → exit 1 |

## 状态文件分层

```
state.json            ← 任务级状态（CLI 管理）
project-status.json   ← 项目级状态（CLI 自动同步）
progress-board.md     ← 人可读看板（CLI 自动重生成）
handoff-log.jsonl     ← 交接日志（CLI 追加）
history/*.json        ← 变更历史（CLI 记录 diff）
```

**所有这些文件都由 CLI 写入，禁止 `write_to_file` 直接操作。**

## CLI 命令与状态流转

```
init-task → state.json 创建 + running/ lock + ops 同步
    │
update-phase → 依赖检查 + 状态更新 + ops 同步 + progress-board
    │
handoff → 产物验证 + JSONL 日志 + 状态推进 + ops 同步
    │
gate → Layer 0 确定性检查
    │
finish-task → 前置检查 + running/ 清理 + queue→done + ops 同步
```

## ops Dashboard 数据流

```
CLI 命令 → 写 project-status.json
                │
health-checker → 轮询读取
                │
Dashboard (Electron) → 渲染卡片
```

Dashboard 不直接读 state.json，只读 project-status.json——这是 CLI 每次命令的副产品。

## 设计决策记录

- **finish-task 自动清理 running/**：不把自己创建的文件当异常拦截（教训：曾因过度防御导致阻塞）
- **`skipped` 算作已完成**：进度统计中 skipped 和 completed 同等对待（教训：skipped 阶段进度条显示 bug）
- **阶段依赖检查**：`update-phase --status in_progress` 自动检查前置阶段已完成/跳过
