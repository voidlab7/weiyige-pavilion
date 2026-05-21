# QA（鉴）— Skills 卡片

> 版本: v2.0 | 创建: 2026-04-13 | 更新: 2026-05-20

---

## Skill-01: 验收标准驱动测试（核心 Skill）

- **触发条件**: 收到 PRD（含 Given/When/Then 验收标准）后需要验证功能；或用户说「验收测试」「验证 PRD」「功能做完了测一下」
- **输入**:
  - PRD 文档路径或验收标准列表（必填）
  - 目标 URL（必填）
  - 测试深度: Quick / Deep（默认 Deep）
- **输出**: 验收测试报告（每条验收标准的 PASS/FAIL + 证据 + 补充边界用例结果）
- **工具**: `read_file`（读 PRD）、`execute_command`（计算型检查）、`browser_take_screenshot`、`browser_click`、`browser_console_messages`
- **执行流程**:
  1. 读取 PRD 验收标准（Given/When/Then）
  2. 将每条验收标准转为测试用例（1:1 映射）
  3. 补充边界用例（空数据/异常/并发）
  4. 执行计算型检查（Lint/类型/单元测试）
  5. 逐条执行测试用例（浏览器操作）
  6. 记录实际结果 + 截图证据
  7. 持久化测试用例到项目库
  8. 产出验收报告
- **约束**:
  - PRD 验收标准**逐条必测**，不允许跳过
  - 每条用例必须有证据（截图/日志/返回值）
  - 补充边界用例至少覆盖：空数据、错误输入、首次用户、网络异常
  - **完成条件**：全部 PASS → 交接确认；有 FAIL → 触发 Skill-03 修复

---

## Skill-02: 探索性测试（承接枢的测试验证请求）

- **触发条件**: 收到枢产出的「测试验证请求」文档；或用户说「探索性测试」「帮我查一下这个模块」「全面测一下」
- **输入**:
  - 测试验证请求文档（来自枢 Skill-07）或模块名称
  - 目标 URL（必填）
- **输出**: 探索性测试报告（测试用例清单 + 执行结果 + Bug 报告 + 健康结论）
- **工具**: `codebase_search`、`read_file`（读代码推导预期行为）、`browser_take_screenshot`、`browser_click`、`execute_command`
- **执行流程**:
  1. 确定预期行为来源（声明：基于 PRD/设计稿/代码推导/常识）
  2. 读取已有测试用例（`ai-workspace/{project}/test-cases/{module}.test-cases.md`）
  3. 如无已有用例 → 读代码推导预期行为 → 生成测试用例清单
  4. 如有已有用例 → 在此基础上补充新用例
  5. 逐条执行（浏览器操作 + 代码审查 + 计算型检查）
  6. 对 FAIL 项产出结构化 Bug 报告
  7. 持久化测试用例
  8. 回传枢确认
- **约束**:
  - **第一步必须声明预期行为来源**
  - 测试用例必须在执行之前列出（先列后执行）
  - 覆盖维度：正常流程 / 边界条件 / 异常处理 / 数据状态
  - 无 Bug 时也必须产出健康确认
  - **完成条件**：报告产出 → 回传枢

---

## Skill-03: Bug 修复

- **触发条件**: 测试中发现 Bug 且允许修复；或用户说「修Bug」「fix」
- **输入**:
  - Bug 描述/复现步骤（必填）
- **输出**: 原子提交（定位 + 最小修复 + before/after 验证）
- **工具**: `codebase_search`、`read_file`、`replace_in_file`、`browser_take_screenshot`
- **约束**:
  - 最小修复——不重构、不加功能、不改无关文件
  - 每个修复一个原子提交: `fix(qa): BUG-NNN — 描述`
  - 修复后必须重测（before/after 截图）
  - WTF-likelihood 规则严格执行
  - **完成条件**：修复验证通过 → 触发 Skill-04 回归

---

## Skill-04: 回归测试

- **触发条件**: Bug 修复后需要验证不引入新问题；或用户说「回归测试」「regression」
- **输入**:
  - 修复的功能点（必填）
  - 关联功能列表（可选，默认从代码依赖推断）
- **输出**: 回归测试报告（关联功能验证结果 + 新增问题清单）
- **工具**: `read_file`（读回归套件）、`browser_take_screenshot`、`browser_click`
- **执行流程**:
  1. 读取 `ai-workspace/{project}/test-cases/regression-suite.md`
  2. 执行回归套件中与修复相关的用例
  3. 补充执行修复功能的直接关联功能用例
  4. 将本次 Bug 的复现用例加入回归套件
  5. 产出回归报告
- **约束**:
  - 必须验证修复功能本身 + 数据流依赖的关联功能
  - 新增问题单独列清单
  - 回归引入新 Bug → WTF-likelihood +15%
  - **完成条件**：回归通过 → 更新回归套件

---

## Skill-05: 7 维度健康评分

- **触发条件**: 用户说「健康评分」「质量评分」「打分」或需要量化评估质量时
- **输入**:
  - 目标 URL（必填）
- **输出**: 健康评分卡（7 维度 0-10 分 + 关键发现 + 改进建议）
- **工具**: `browser_take_screenshot`、`browser_console_messages`、`browser_network_requests`、`browser_click`
- **约束**:
  - 7 维度全部评分: Console/Links/Visual/Functional/UX/Performance/Accessibility
  - 每个维度必须有具体证据支撑
  - < 5 分 = 严重问题必须修复；5-7 分 = 需改进；7+ 分 = 可接受

---

## Skill-06: 金丝雀监控

- **触发条件**: 用户说「部署后检查」「canary」「金丝雀」或部署后需要监控时
- **输入**:
  - 生产 URL（必填）
  - 监控轮数: 默认 5 轮（每 60 秒一轮）
- **输出**: 金丝雀报告（每轮结果 + 最终裁定: HEALTHY / HAS ISSUES）
- **工具**: `browser_take_screenshot`、`browser_console_messages`、`browser_network_requests`
- **约束**:
  - Alert on changes, not absolutes——基线有错误是正常的，新增才告警
  - Don't cry wolf——连续 2 次异常才告警
  - 最终裁定只有两种: DEPLOY IS HEALTHY / DEPLOY HAS ISSUES

---

## Skill-07: 测试用例持久化管理

- **触发条件**: 任何测试完成后自动触发；或用户说「更新测试用例」「维护回归套件」
- **输入**:
  - 本次测试产出的用例清单（必填）
  - 项目名称（必填）
- **输出**: 更新后的测试用例文件
- **工具**: `read_file`、`replace_in_file`
- **存储路径**:
  ```
  ai-workspace/{project}/test-cases/
    ├── {module-name}.test-cases.md    # 模块级测试用例
    ├── regression-suite.md            # 回归测试套件
    └── bug-patterns.md                # 已知 Bug 模式
  ```
- **约束**:
  - 新功能测试后 → 写入 `{module}.test-cases.md`
  - Bug 修复后 → 复现用例加入 `regression-suite.md`
  - 发现 Bug 模式 → 记录到 `bug-patterns.md`
  - 已有用例不重复添加，只更新状态
  - 用例格式必须统一（ID/描述/前置/步骤/预期/来源/状态）

---

## Skill 流转规则（自动触发链）

| 当前 Skill | 完成条件 | 自动触发 |
|-----------|---------|----------|
| Skill-01（验收测试） | 有 FAIL 项 | → Skill-03（Bug 修复） |
| Skill-01（验收测试） | 全部 PASS | → Skill-07（持久化）→ 交接确认 |
| Skill-02（探索性测试） | 发现 Bug | → Skill-03（Bug 修复） |
| Skill-02（探索性测试） | 无 Bug | → Skill-07（持久化）→ 回传枢 |
| Skill-03（Bug 修复） | 修复完成 | → Skill-04（回归测试） |
| Skill-04（回归测试） | 回归通过 | → Skill-07（持久化）→ 产出报告 |

---

## 跨 Skill 协作模式

| 协作链 | 触发场景 | Skill 组合 | 输出 |
|--------|---------|-----------|------|
| PRD 验收 | 功能开发完成 | Skill-01 → 03 → 04 → 07 | 验收报告 + 修复 + 回归 |
| 探索 → 修复 | 枢发来测试验证请求 | Skill-02 → 03 → 04 → 07 | Bug报告 + 修复 + 回归 |
| 部署监控 | 部署后 | Skill-06 | 金丝雀报告 |
| 质量评估 | 需要量化 | Skill-05 | 健康评分 |
| 纯报告 | qa-only 模式 | Skill-02（不触发03） | Bug 报告（不修复） |

---

## Skill 质量指标

| 指标 | 定义 | 目标 |
|------|------|------|
| 验收标准覆盖率 | PRD 验收标准被转为测试用例的比例 | 100% |
| Bug 发现率 | 测试发现的 Bug 占总 Bug 的比例 | > 80% |
| 修复零回归率 | Bug 修复不引入新 Bug 的比例 | > 90% |
| 测试用例复用率 | 下次测试时复用已有用例的比例 | > 60% |
| 预期行为来源声明率 | 测试前声明预期行为来源的比例 | 100% |
| Bug 报告结构化率 | Bug 报告包含完整字段的比例 | 100% |

---

*每个 Skill 就是一根线束——描述越清楚，模型传导动力越高效。*
