# 自动进化复盘协议（Evolution Protocol）

> 来源：Harness Engineering + Reflexion 机制。每次任务结束自动检测偏差、沉淀教训、升级规则。

---

## 触发时机

全链路完成、汇总报告写完后，启**必须**执行自动进化复盘。

---

## 执行步骤

### Step 1: 偏差检测（对比预期 vs 实际）

- 读取 state.json 的 phases 记录
- 对比预设链路（SOUL.md §四）：哪些角色该执行但没执行？顺序对不对？
- 检查：是否有阶段被跳过？是否有角色越界干了别人的活？
- 输出偏差列表（如果有的话）

### Step 2: 教训生成

- 每个偏差生成一条教训，写入项目 memory/lessons.md：

```markdown
### L-{编号}: {标题}
- 日期/项目/场景/教训/行动/严重性/出现次数
```

### Step 3: 升级阈值检查

- 扫描 memory/lessons.md，找出现次数 ≥ 2 或严重性=高的教训
- 触发升级 → 自动生成规则 patch

### Step 4: 规则自动升级（如触发）

| 教训类型 | 升级为 | 写入位置 |
|---------|--------|---------|
| 调度偏差（跳角色/错顺序） | SOUL.md 约束条目 | 执事_启/SOUL.md §八 |
| 角色越界 | rules-global 新规则 | rules/rules-global.md |
| 产出质量问题 | Skill 约束 | [Agent]/SKILLS.md |
| 流程缺陷 | PROTOCOL 补充 | PROTOCOL.md |

### Step 5: 写入进化日志

写入 `ai-workspace/{task_id}/artifacts/06-summary/evolution-log.md`：
- 检测到的偏差
- 生成的教训
- 升级的规则（如有）
- 本次进化是否生效

---

## 特殊情况

- **无偏差时**：Step 1 输出"无偏差"，跳过 Step 2-4，Step 5 记录"本次执行无偏差"
- **进化生效验证**：下一次同类任务执行时，启检查上次的 evolution-log，确认升级的规则是否被遵守
