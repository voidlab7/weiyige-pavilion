# 调度器

> dispatch → spawn → hold → resume 的完整流程。

---

## 调度模型

```
任务队列（queue/）
    │ pick-task.sh / 调度器
    ▼
dispatch（选任务 + 分配）
    │ spawn Worker
    ▼
Worker 进入项目
    │ 读 .weiyige 协议
    │ 角色开始工作
    ▼
    ├── 正常完成 → finish-task → done/
    ├── 需人决策 → 写 hold.json → 退出（不阻塞调度）
    └── 失败 → blocked/
```

## 三种 Worker 环境

| 环境 | spawn 方式 | 特点 |
|------|-----------|------|
| CodeBuddy | `team_create` + `team member spawn` | 异步并行，send_message 通信 |
| Claude Code | `claude -p` 子进程 | 独立进程 |
| 手动 | 用户在项目目录开新会话 | 最灵活 |

## hold 机制

Worker 遇到需人决策的情况：
1. 写 `hold.json`（原因 + 需要什么决策）
2. 退出（不阻塞调度器）
3. 调度器继续处理其他任务
4. 用户决策后 `resume-task.sh` 重新 spawn

## 关键约束

- **task(subagent_name=...) 严禁用于角色调度**：同步子 Agent 异常缓慢，仅 code-explorer 搜索例外
- **小任务不用 team 模式**：overhead 远超任务本身
- 调度器的五个能力目标：C1 自动执行、C2 hold 不影响其他任务、C3 队列动态追加、C4 全局观察、C5 不中断调度
