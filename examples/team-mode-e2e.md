# 示例：Team 模式端到端流程

## 用户输入

```text
@team auto 我想做一个“毛孩子人格测试”新版本。请从想法评估、需求、设计、开发、测试、安全审计走完整流程。
```

## 主 Agent 动作

1. 读取 `执事_启/start.md`。
2. 创建团队：`team_create(team_name="weiyige-pet-personality")`。
3. 并行 spawn 需要的成员，`name` 使用角色单字：启、砺、锋、枢、矩、绘、铸、鉴、盾。
4. 启接管调度。

## 推荐链路

```text
启
 ├─ 唤醒砺：Office Hours v2，输出 01-ideation 设计文档
 ├─ 必要时唤醒隐：独立二评
 ├─ UI 类想法唤醒绘：低保真视觉草图
 ├─ 唤醒锋：方向审批
 ├─ 唤醒枢：PRD
 ├─ 并行唤醒矩 + 绘：工程审查 + 设计审查
 ├─ 唤醒铸：代码实现 + 左移检查
 ├─ 唤醒鉴：QA 测试
 ├─ 唤醒盾：安全审计
 └─ 汇总 summary，关闭团队
```

## 产物路径

```text
ai-workspace/{task_id}/
├── state.json
├── progress-board.md
└── artifacts/
    ├── 01-ideation/     # 砺 Office Hours 设计文档
    ├── 02-requirement/  # 枢 PRD
    ├── 03-design/       # 矩/绘审查报告和草图
    ├── 04-development/  # 铸实现记录和左移检查
    ├── 05-testing/      # 鉴/盾测试与安全报告
    └── 06-summary/      # 启汇总报告
```

## 成员交接块要求

每个成员输出都必须包含：来源、阶段、产出类型、产物文件、状态、关键决策、开放问题、下游建议、阻塞项。

## 失败处理

- 产物文件不可读：启打回上游成员。
- `未通过` 且未达迭代上限：启按 Review Response 机制要求重做。
- 迭代超限 / 需要用户信息 / 破坏性操作：启暂停并向用户报告。
- 不支持 team 工具：直接报告阻塞，禁止伪装成 team。
