# 两层门禁（Layer 0 + Layer 1）

> 每个阶段审核必须走两层。Layer 0 先过滤，Layer 1 再深审。

---

## Layer 0：确定性检查（0 Token 成本）

用 `execute_command` 或 `read_file` 做确定性检查，**不通过直接打回**，不进 Layer 1。

### 各阶段 Layer 0 检查项

| 阶段 | Layer 0 检查 | 方法 |
|------|-------------|------|
| 01-构思 | 方向确认文件存在 | `read_file` |
| 02-需求 | PRD 包含必填章节（问题&假设、MVP定义、验收标准） | `read_file` + 关键词检查 |
| 03-设计 | 审查报告存在；评分字段非空 | `read_file` |
| 04-开发 | 左移检查通过（Lint/类型检查/快速测试）；代码文件存在 | `execute_command` |
| 05-测试 | 测试报告存在；无 Critical Bug 未修 | `read_file` + 关键词检查 |
| 06-发布 | 所有上游阶段 state.json 状态为 completed | `read_file` state.json |

### Layer 0 结果

```
PASS → 继续 Layer 1
WARN → 继续 Layer 1（附警告）
FAIL → 直接打回，不进 Layer 1（节省 Token）
```

---

## Layer 1：AI 语义审查

调用 `use_skill("artifact-review")` + 阶段门禁 `gates/gate-*.md` 检查项。

### 审核流程

```
1. 读取 gates/review-reminder.md（审核入口强制指令）
2. 调用 use_skill("artifact-review") — 多维度评分
3. 读取 gates/gate-{阶段编号}.md — 额外检查项
4. 逐项验证实际执行证据（禁止善意推断）
5. 输出评分 + 通过/有条件通过/打回
```

### 审核诚实性约束

- **必须验证实际执行证据**：Agent 说"已完成 Lint 检查"，Leader 必须看到命令输出日志
- **禁止善意推断**：没有证据 = 没有完成
- **打回必须具体**：附带文件名 + 行号/章节名 + 修改建议

---

## 评分落盘

每阶段审核评分写入两处：
1. `ai-workspace/{task_id}/state.json` 的 `phases.{阶段}.review_score`
2. `ai-workspace/{task_id}/artifacts/{阶段}/review-report.md`
