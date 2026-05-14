# ai-workspace 统一协议 v1.0

> 无论任务由 **ops 全局调度** 还是 **@启 项目内执行** 触发，都必须遵守本协议。

---

## 一、目录结构（唯一标准）

```
ai-workspace/
├── project-status.json          ← 项目级状态（health-checker 读取）
├── last-result.json             ← 最近一次完成/失败的任务摘要
├── last-interrupted.json        ← 最近一次中断的任务索引（断点续做用）
├── queue/                       ← 待调度的任务 yaml
├── running/                     ← 正在执行的任务 lock + yaml（ops 调度写入）
├── done/                        ← 已完成任务 yaml（唯一完成归档目录）
├── blocked/                     ← 被阻塞任务 yaml
└── {task_id}/                   ← 任务工作区（每个任务一个目录）
    ├── state.json               ← 唯一状态真相源
    ├── progress-board.md
    ├── runtime-knowledge/
    └── artifacts/
        ├── 01-ideation/
        ├── 02-requirement/
        ├── 03-design/
        ├── 04-development/
        ├── 05-testing/
        └── 06-summary/
```

**禁止创建的目录**: `completed/`、`results-archive/`

---

## 二、state.json 必填字段

```json
{
  "task_id": "必填",
  "task_title": "必填",
  "project_id": "必填（从 .weiyige/project.yaml 或目录名推断）",
  "status": "必填: running | completed | abandoned | failed | blocked",
  "current_phase": "当前阶段",
  "started_at": "ISO timestamp",
  "updated_at": "ISO timestamp（每次变更必须更新）"
}
```

### 状态机

```
running → completed（正常完成）
running → abandoned（中断超时未恢复 / 被替代）
running → failed（执行失败）
running → blocked（需要人决策 / 外部依赖）
blocked → running（resume）
```

### 判定规则（health-checker 使用）

| status 值 | 是否占用项目 | 计入 |
|-----------|------------|------|
| running | ✅ | runningCount |
| completed | ❌ | — |
| abandoned | ❌ | — |
| failed | ❌ | — |
| blocked | ❌ | blockedCount |
| （无 status 字段，current_phase=06-summary/completed）| ❌ | 推断为 completed |
| （无 status 字段，其他 current_phase）| ⚠️ | 推断为 running |

---

## 三、两条触发路径的写入协议

### 路径 A：ops 全局调度

```
1. run-once.py 从 queue/ 取出 yaml
2. executor 写 running/{task_id}.lock + running/{task_id}.yaml
3. executor 创建 {task_id}/ 目录 + state.json（status: running）
4. Worker 执行…
5. 完成后：
   - state.json → status: completed
   - 移动 running/{task_id}.yaml → done/
   - 删除 running/{task_id}.lock
   - 更新 project-status.json
   - 写 last-result.json
```

### 路径 B：@启 项目内执行

```
1. 用户 @启 触发任务
2. 启 Phase 0：
   - 创建 {task_id}/ 目录 + state.json（status: running）
   - 写 running/{task_id}.lock（让 health-checker 可感知）
   - 更新 project-status.json（active_task）
3. 启串行执行各阶段…
4. 完成后：
   - state.json → status: completed
   - 删除 running/{task_id}.lock
   - 更新 project-status.json（active_task: null）
   - 写 last-result.json
```

### 共同约定

- **state.json 是唯一状态真相源**（health-checker 只读 state.json 判断状态）
- **running/{task_id}.lock 是辅助信号**（快速判断有无活跃任务，但最终以 state.json 为准）
- **project-status.json 是项目级聚合**（health-checker 读取后合并展示）
- **完成后 yaml 统一归档到 done/**（不是 completed/）

---

## 四、自动清理规则

| 条件 | 动作 |
|------|------|
| state.json status=running + 更新时间 >2h + project-status.active_task=null | 自动标记 abandoned |
| running/ 里有 .lock 但对应 state.json 已是终态 | 删除 .lock |
| done/ 里的 yaml 对应目录的 state.json 已是 completed | 正常状态，无需动作 |

---

## 五、版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2026-05-05 | 初始版本：统一两条路径协议，status 必填，禁止 completed/ 目录 |
