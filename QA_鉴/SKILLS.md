# QA（鉴）— Skills 卡片

> 版本: v1.0 | 创建: 2026-04-13 | 基于 Harness Engineering 范式

---

## Skill-01: 浏览器功能测试

- **触发条件**: 用户说「测试」「QA」「找Bug」「测试并修复」或功能开发完成后需要验证时
- **输入**:
  - 目标 URL（必填）
  - 测试深度: Quick / Standard / Deep（默认 Standard）
- **输出**: 测试报告（7 维度健康评分 + Bug 清单 + 修复提交）
- **工具**: `browser_take_screenshot`、`browser_snapshot`、`browser_click`、`browser_console_messages`、`browser_network_requests`、`replace_in_file`
- **约束**:
  - 必须像真实用户一样操作——启动浏览器、点击、输入、导航
  - 7 维度健康评分必须逐项检查
  - Bug 按严重度排序: Critical > High > Medium > Low
  - Quick 模式只修 Critical+High
  - Standard 模式修到 Medium
  - Deep 模式修到 Low
- **示例**:
  ```
  用户: "测试一下毛孩子测试"
  输出: 🐛 QA测试 | Standard 模式
        Phase 3-6 基线: 7维度评分 Console:9/10 Visual:7/10 Functional:6/10
        🐛 BUG-001 [HIGH] 第5题点击后无响应
        🐛 BUG-002 [MEDIUM] 结果页分享按钮偏移
        修复: fix(qa): BUG-001 — 第5题事件绑定修复
  ```

---

## Skill-02: Bug 修复

- **触发条件**: 用户说「修Bug」「修复这个问题」「fix」或 QA 测试中发现 Bug 时
- **输入**:
  - Bug 描述/截图/复现步骤（必填）
- **输出**: 原子提交（定位源码 + 最小修复 + before/after 验证）
- **工具**: `codebase_search`、`search_content`、`read_file`、`replace_in_file`
- **约束**:
  - 最小修复——不重构、不加功能
  - 每个修复一个原子提交: `fix(qa): BUG-NNN — 描述`
  - 修复后必须重新测试（before/after 截图）
  - 涉及 >3 个文件的修复: WTF-likelihood +5%
  - revert: WTF-likelihood +15%
  - WTF-likelihood >20%: 停止，问用户
- **示例**:
  ```
  用户: "修一下分享按钮偏移"
  输出: 🐛 Bug修复 | BUG-002
        定位: ResultPage.tsx L45 分享按钮CSS
        修复: margin-left: 0 → margin-left: auto
        提交: fix(qa): BUG-002 — 结果页分享按钮居中
        验证: ✅ before/after截图已保存
  ```

---

## Skill-03: 金丝雀监控

- **触发条件**: 用户说「部署后检查」「canary」「监控」「金丝雀」或部署后需要持续监控生产环境时
- **输入**:
  - 生产 URL（必填）
  - 监控时长: 默认 5 轮（每 60 秒一轮）
- **输出**: 金丝雀报告（每轮检查结果 + 最终裁定: HEALTHY / HAS ISSUES）
- **工具**: `browser_take_screenshot`、`browser_console_messages`、`browser_network_requests`
- **约束**:
  - Alert on changes, not absolutes——基线有 3 个错误是正常的，多 1 个才告警
  - Don't cry wolf——连续 2 次检查都异常才告警
  - 每轮: 页面加载 → 截图 → 控制台检查 → 性能检测
  - 最终裁定只有两种: DEPLOY IS HEALTHY / DEPLOY HAS ISSUES
- **示例**:
  ```
  用户: "部署后检查一下"
  输出: 🐛 金丝雀监控 | 5轮
        R1: ✅ 页面正常 / 0 新错误 / LCP 1.1s
        R2: ✅ 页面正常 / 0 新错误 / LCP 1.2s
        ...
        裁定: ✅ DEPLOY IS HEALTHY
  ```

---

## Skill-04: 回归测试

- **触发条件**: 用户说「回归测试」「regression」「修了这个会不会影响别的」或 Bug 修复后需要验证不引入新问题时
- **输入**:
  - 修复的功能点（必填）
  - 关联功能列表（可选，默认自动推断）
- **输出**: 回归测试报告（关联功能验证结果 + 新增问题清单）
- **工具**: `browser_take_screenshot`、`browser_snapshot`、`browser_click`
- **约束**:
  - 必须验证修复的功能本身
  - 必须验证与修复功能有数据流依赖的关联功能
  - 新增问题单独列清单，不混入原 Bug 修复
  - 如果回归引入新 Bug → WTF-likelihood +15%
- **示例**:
  ```
  用户: "回归测试一下分享功能"
  输出: 🐛 回归测试 | 分享功能
        ✅ 分享按钮正常工作
        ✅ 结果页显示正常
        ✅ 题目流程未受影响
        ⚠️ 新发现: iOS上分享弹窗偶尔不出现 → 新BUG-003
  ```

---

## Skill-05: 7 维度健康评分

- **触发条件**: 用户说「健康评分」「质量评分」「打分」或需要量化评估页面/应用质量时
- **输入**:
  - 目标 URL（必填）
  - 评分维度: 全部7维度 / 指定维度（默认全部）
- **输出**: 健康评分卡（7 维度 0-10 分 + 关键发现 + 改进建议）
- **工具**: `browser_take_screenshot`、`browser_console_messages`、`browser_network_requests`、`browser_click`
- **约束**:
  - 7 维度必须全部评分: Console/Links/Visual/Functional/UX/Performance/Accessibility
  - 低于 5 分 = 严重问题，必须立即修复
  - 5-7 分 = 需改进
  - 7+ 分 = 可接受
  - 每个维度的评分必须有具体证据支撑
- **示例**:
  ```
  用户: "给首页打个健康分"
  输出: 🐛 7维度健康评分 | 首页
        Console:  9/10 ✅ — 0 错误
        Links:    8/10 ✅ — 1个404(外部链接)
        Visual:   6/10 ⚠️ — 移动端布局重叠
        Functional: 9/10 ✅
        UX:       7/10 ✅ — 加载时无指示器
        Perf:     8/10 ✅ — LCP 1.2s
        A11y:     5/10 ❌ — 缺alt text + 对比度不足
        总分: 52/70 — 需改进
  ```

---

## 跨 Skill 协作模式

| 协作链 | 触发场景 | Skill 组合 | 输出 |
|--------|---------|-----------|------|
| 测试 → 修复 → 回归 | 「测试并修复」 | Skill-01 → 02 → 04 | Bug清单 + 修复 + 回归验证 |
| 修复 → 金丝雀 | 「修完部署」 | Skill-02 → 03 | 修复 + 部署监控 |
| 健康评分 → 测试 | 「先打分再测」 | Skill-05 → 01 | 评分 + 深度测试 |
| 测试 → 盾升级 | 「发现安全问题」 | Skill-01 → 通知盾 | Bug清单 + 安全升级 |

---

## Skill 质量指标（待采集基线）

| 指标 | 定义 | 目标 |
|------|------|------|
| Bug 发现率 | 测试发现的 Bug 占总 Bug 的比例 | > 80% |
| 修复零回归率 | Bug 修复不引入新 Bug 的比例 | > 90% |
| 原子提交率 | 修复按原子提交规范的比例 | 100% |
| 金丝雀误报率 | 健康部署被标记为有问题的比例 | < 10% |
| WTF-likelihood 触发率 | 自我调节机制被触发的比例 | < 20% |

---

*每个 Skill 就是一根线束——描述越清楚，模型传导动力越高效。*
