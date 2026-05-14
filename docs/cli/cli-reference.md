# CLI 命令手册

> weiyige-cli v2 完整命令参考。

---

## 核心命令（状态管理）

### init-task

创建任务：state.json + 目录结构 + running/ lock + ops 同步。

```bash
weiyige-cli init-task <task_id> --title "任务标题" [--project-root <path>]
```

| 参数 | 必填 | 说明 |
|------|------|------|
| `task_id` | 是 | 任务 ID（如 `task-0514-docs-t1`） |
| `--title` | 是 | 任务标题 |
| `--project-root` | 否 | 项目根目录（默认: 环境变量 > cwd） |

**自动执行**：创建 `ai-workspace/{task_id}/` 目录 + state.json + progress-board.md + artifacts/01~06 + running/*.lock + 同步 project-status.json

### update-phase

更新阶段状态。自动检查前置阶段依赖。

```bash
weiyige-cli update-phase <task_id> --phase <phase> --status <status> [--agent <name>] [--step <step>] [--description <text>]
```

| 参数 | 必填 | 可选值 |
|------|------|--------|
| `--phase` | 是 | `01-ideation` `02-requirement` `03-design` `04-development` `05-testing` `06-summary` |
| `--status` | 是 | `pending` `in_progress` `completed` `skipped` |
| `--agent` | 否 | 角色名（锋/砺/隐/枢/辞/寻/矩/绘/铸/鉴/盾/算/启） |

**阶段依赖检查**：`--status in_progress` 时自动检查前置阶段已 completed 或 skipped，否则拒绝。

### finish-task

完成任务。前置检查 + 清理 + 归档。

```bash
weiyige-cli finish-task <task_id> [--no-commit]
```

**前置检查**：所有阶段已 completed/skipped。
**自动执行**：清理 running/ → queue yaml 移到 done/ → 同步 ops。`--no-commit` 跳过自动 git commit。

### handoff

原子交接：产物验证 + JSONL 日志 + 状态推进。

```bash
weiyige-cli handoff <task_id> --from <角色> --to <角色> --phase <phase> --artifact <path> [--status pass|conditional|fail|need-info] [--summary <text>]
```

**产物验证**：`--artifact` 指定的文件必须存在且非空，否则拒绝交接。
**JSONL 日志**：追加写入 `handoff-log.jsonl`。
**状态推进**：pass/conditional 时标记当前阶段 completed，推进到下一个 pending 阶段。

---

## 质量门禁

### gate

Layer 0 确定性门禁检查。

```bash
weiyige-cli gate <task_id> --phase <phase>
```

**检查项**：state.json 合法 + 前置阶段依赖 + 阶段专属产物存在 + 关键词检查。
FAIL → exit 1，不进入 Layer 1。

### artifact

验证产物文件存在且非空。

```bash
weiyige-cli artifact <task_id> --path <artifact_relative_path>
```

输出：文件大小、行数、词数、修改时间。

---

## 状态查看

### status

```bash
weiyige-cli status                 # 项目概况
weiyige-cli status <task_id>       # 任务详情（阶段明细 + 交接记录）
```

### validate

校验 state.json 结构完整性。

```bash
weiyige-cli validate <task_id>
```

### history

查看任务状态变更历史。

```bash
weiyige-cli history <task_id>
```

---

## 队列管理

### add-queue

```bash
weiyige-cli add-queue --title "标题" --priority 80 [--type feature|refactor|docs] [--id <task_id>]
```

---

## 运维工具

| 命令 | 说明 |
|------|------|
| `snapshots` | 列出所有快照 |
| `rollback <snapshot-id>` | 恢复到指定快照 |
| `scan-workspace [--workspace <path>]` | 扫描工作区项目 |
| `register-project <path> [--name X]` | 注册项目 |
| `cost-report --period weekly\|monthly` | 成本快报 |
| `budget-check` | 预算预警 |

---

## 通用选项

| 选项 | 说明 |
|------|------|
| `--project-root <path>` | 指定项目根目录（默认: `$CODEBUDDY_PROJECT_DIR` > `$CLAUDE_PROJECT_DIR` > cwd） |
| `--verbose` / `-v` | 显示环境检测信息（平台、projectRoot、环境变量） |
| `--no-commit` | finish-task 时跳过自动 git commit |
