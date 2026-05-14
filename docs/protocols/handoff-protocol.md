# 交接机制解读

> 为什么交接要这么做？协议本身在 `PROTOCOL.md §二`，这里是设计意图。

---

## 解决的问题

Agent 之间传递信息时"丢上下文"——上游做了什么决策、产出了什么文件、有什么未解决问题，下游完全不知道。

## 三层交接保障

### 1. 交接块（Handoff Block）

每个 Agent 完成工作后输出结构化交接块：

```
来源 → 阶段 → 产出类型 → 产物文件路径 → 状态 → 关键决策 → 开放问题 → 下游建议
```

**为什么不是自由文本**：结构化格式让下游 Agent 可以精确提取需要的信息，不用从长文本中猜。

### 2. CLI handoff 命令

```bash
weiyige-cli handoff <task_id> --from 铸 --to 鉴 --phase 04-development --artifact <path>
```

CLI 做三件事：
1. **验证产物文件存在且非空**（不存在则拒绝交接）
2. **写 JSONL 日志**（`handoff-log.jsonl`，可追溯）
3. **更新状态 + 同步 ops**

**为什么不靠 AI 自觉**：AI 经常"忘记"输出交接块。CLI 强制——不调 handoff 命令，阶段就不流转。

### 3. 产物落盘验证

启在 spawn 下一个 Agent 前 `read_file` 验证上游产物可读。不可读则暂停。

**为什么不信任 AI 说"我已经写了"**：规则 W12——禁止不执行就声称"检查通过"。

## 交接日志格式

`handoff-log.jsonl`（追加写入，每行一条记录）：

```json
{"timestamp":"2026-05-14T10:30:00Z","from":"铸","to":"鉴","phase":"04-development","artifact":"artifacts/04-development/shift-left-report.md","status":"pass","summary":"左移检查全通过"}
```

## 信息不丢失四原则

1. 交接块**必填**
2. STATUS.md **必更新**
3. 决策**必记录**
4. 开放问题**必追踪**（不允许"静默丢失"）
