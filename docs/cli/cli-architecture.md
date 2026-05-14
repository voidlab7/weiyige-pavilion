# CLI 架构

> weiyige-cli v2 模块拆分说明。

---

## 目录结构

```
bin/cli/
├── weiyige-cli.mjs          ← 入口（路由 switch，72 行）
└── lib/
    ├── context.mjs           ← 共享上下文（args, getArg, getProjectRoot, detectPlatform, now）
    ├── constants.mjs         ← 枚举常量（VALID_PHASES, VALID_AGENTS, PHASE_LABELS）
    ├── validate.mjs          ← validateState + validateCommand
    ├── sync.mjs              ← syncProjectStatus, calcProgress, regenerateProgressBoard
    ├── history.mjs           ← recordHistory, historyCommand, snapshotsCommand, rollbackCommand
    ├── cmd-task.mjs          ← initTask, updatePhase, finishTask
    ├── cmd-handoff.mjs       ← handoffCommand
    ├── cmd-gate.mjs          ← gateCheck, artifactCheck
    ├── cmd-status.mjs        ← statusCommand
    ├── cmd-queue.mjs         ← addQueue
    └── cmd-ops.mjs           ← scanWorkspace, registerProject, costReport, budgetCheck
```

## 依赖关系

```
weiyige-cli.mjs（入口）
  ├── context.mjs          ← 所有模块都依赖
  ├── constants.mjs        ← 大部分模块依赖
  ├── cmd-task.mjs ──→ validate, sync, history, constants
  ├── cmd-handoff.mjs ──→ validate, sync, history, constants
  ├── cmd-gate.mjs ──→ validate, constants
  ├── cmd-status.mjs ──→ constants, sync(calcProgress)
  ├── cmd-queue.mjs ──→ context
  ├── cmd-ops.mjs ──→ context
  ├── validate.mjs ──→ constants
  ├── history.mjs ──→ context
  └── sync.mjs ──→ constants, context
```

## 关键函数

| 函数 | 所在文件 | 职责 |
|------|---------|------|
| `syncProjectStatus()` | sync.mjs | 每次命令后同步 project-status.json |
| `regenerateProgressBoard()` | sync.mjs | 根据 state.json 重写 progress-board.md |
| `validateState()` | validate.mjs | 校验 state.json 结构（写入前自动调用） |
| `recordHistory()` | history.mjs | 记录状态变更 diff（before/after） |
| `detectPlatform()` | context.mjs | 检测运行环境（codebuddy/claudecode/openclaw/local） |

## 设计原则

1. **入口只做路由**：72 行的 switch，不含业务逻辑
2. **按职责域拆分**：不按单函数拆，每个文件是一个逻辑域
3. **共享基础设施独立**：context/constants/validate/sync/history 被多个 cmd 引用
4. **每个模块自给自足**：import 需要的 lib，不依赖全局变量
