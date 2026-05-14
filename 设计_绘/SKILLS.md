# 设计（绘）— Skills 卡片

> 版本: v1.2 | 创建: 2026-04-13 | 更新: 2026-05-08 | 基于 Harness Engineering 范式

---

## Skill-01: 设计系统构建

- **触发条件**: 用户说「设计系统」「Design System」「DESIGN.md」「视觉规范」或新产品/大版本开始前需要建立设计语言时
- **输入**:
  - 产品/项目名称（必填）
  - 参考风格/竞品（可选）
  - 深度: Quick / Standard / Deep（默认 Standard）
- **输出**: DESIGN.md（色彩 + 排版 + 间距 + 组件 + 图标 + 动画规范）
- **工具**: `web_search`（竞品设计调研）、`web_fetch`（获取设计灵感）、`read_file`（读取 UI-Prompt 风格 Prompt + TDesign 规范）
- **知识库**:
  - UI-Prompt 风格 Prompt: `/workspace/UI-Prompt/public/data/prompts/styles/{category}/{family}/style.md`
  - UI-Prompt 详细规范: `/workspace/UI-Prompt/public/data/prompts/styles/{category}/{family}/custom.md`
  - TDesign 设计规范: `/workspace/tdesign/docs/design/`
  - TDesign 组件清单: `/workspace/tdesign-react/packages/components/`
- **约束**:
  - 必须通过 AI 烂俗 10 反模式检查
  - 必须执行三层竞品综合法（共识→趋势→第一性原理）
  - SAFE/RISK 分层——安全选择保证可用，风险选择创造辨识度
  - SAFE 层优先参考 TDesign 设计规范（品类基线）
  - RISK 层从 UI-Prompt 80+ 风格中选择差异化方向
  - 无障碍不是可选项——对比度、键盘导航、触摸目标
  - 默认做减法——如果一个元素没赢得它的像素，砍掉
- **示例**:
  ```
  用户: "给毛孩子测试建立设计系统"
  输出: 🎨 设计系统 | 毛孩子人格测试
        色彩: 暖棕+奶油白(主色) + 珊瑚橙(强调色) — 避开紫色渐变(#1反模式)
        排版: 圆体+无衬线 — 有温度但不幼稚
        组件: 卡片式答题 → 非三列网格(#2反模式)
        RISK: 圆体字体选择 — 品类内无人用，但传达温暖感
  ```

---

## Skill-02: 设计计划评审

- **触发条件**: 用户说「设计审查」「plan-design-review」「UI审查」「0-10评分」或设计稿/实现需要评审时
- **输入**:
  - 待评审的设计/页面（必填）
  - 评审维度: 7 维度全评 / 指定维度（默认全评）
- **输出**: 7 维度评分表（0-10 × 层次/信息/视觉/交互/边界/信任/AI味）+ 发现清单
- **工具**: `browser_take_screenshot`、`browser_snapshot`（浏览器级评审）
- **约束**:
  - 7 维度必须逐个评分，不跳过
  - 每个低于 7 分的维度必须有 FINDING + 修复建议
  - AI 烂俗检测必须单独列项
  - 判断标准：一个受人尊敬的设计工作室的人类设计师，会发布这个吗？
  - 评分不能全是 7-8——必须有区分度
- **示例**:
  ```
  用户: "审查一下首页设计"
  输出: 🎨 设计评审 | 首页
        层次: 6/10 — 标题和副标题权重接近
        信息: 8/10 — 核心信息清晰
        AI味: 4/10 — 三列特性网格(反模式#2)+紫色渐变(反模式#1)
        🔴 FINDING-001: 三列特性网格 → 改为交错全宽布局
        🔴 FINDING-002: 紫色渐变 → 换暖色系
  ```

---

## Skill-03: 设计审计修复

- **触发条件**: 用户说「设计审计」「修UI」「视觉QA」「修复设计问题」或实现与设计意图不符时
- **输入**:
  - 目标 URL 或页面（必填）
  - 审计范围: 指定页面 / 全站（默认指定页面）
- **输出**: 审计报告 + 原子修复（before/after 截图）
- **工具**: `browser_take_screenshot`、`browser_snapshot`、`search_content`、`replace_in_file`
- **约束**:
  - 定位源码 → 最小修复 → 原子提交 → 重新验证
  - CSS 优先于结构变更
  - 原子提交格式: `style(design): FINDING-NNN — 描述`
  - 自我调节: 每 5 个修复评估风险，>20% 改动停止
  - before/after 截图是强制证据
- **示例**:
  ```
  用户: "审计一下结果页的设计"
  输出: 🎨 设计审计 | 结果页
        🔴 FINDING-001: 标题字重太轻 → font-weight:600→700
        🟡 FINDING-002: 间距不均匀 → padding统一为16px
        修复: style(design): FINDING-001 — 结果页标题字重增强
        验证: ✅ before/after截图已保存
  ```

---

## Skill-04: AI 烂俗检测

- **触发条件**: 用户说「AI味」「烂俗」「反模式」「太模板了」「AI生成感太强」或需要快速检查设计是否落入 AI 套路时
- **输入**:
  - 目标 URL 或截图（必填）
- **输出**: AI 烂俗 10 反模式检查报告（命中项 + 严重度 + 修复建议）
- **工具**: `browser_take_screenshot`、`browser_snapshot`
- **约束**:
  - 10 大反模式必须逐项检查
  - 命中 3+ 项 = 严重 AI 味，必须全面重构
  - 命中 1-2 项 = 局部修复
  - 0 项 = 通过
  - 判断标准严格——宁可误报不可漏报
- **示例**:
  ```
  用户: "检查一下有没有AI味"
  输出: 🎨 AI烂俗检测
        ✅ #1 紫色渐变 — 未命中
        🔴 #2 三列特性网格 — 命中（首页特性区）
        ✅ #3 彩色圆圈图标 — 未命中
        🔴 #5 统一超大圆角 — 命中（所有卡片16px）
        评分: D（2/10命中）→ 需要修复
  ```

---

## Skill-05: 竞品设计综合

- **触发条件**: 用户说「竞品设计」「参考设计」「设计灵感」「别人怎么做」或需要了解品类设计趋势时
- **输入**:
  - 品类/竞品名称（必填）
  - 分析维度: 全维度 / 指定维度（默认全维度）
- **输出**: 竞品设计综合报告（Layer1共识 + Layer2趋势 + Layer3第一性原理）
- **工具**: `web_search`、`web_fetch`、`browser_take_screenshot`、`read_file`（读取 UI-Prompt 风格模板）
- **知识库**:
  - UI-Prompt 风格注册表: `/workspace/UI-Prompt/src/data/styles/_registry.json`
  - UI-Prompt 完整页面: `/workspace/UI-Prompt/public/data/content/styles/{category}/{family}/{templateId}/fullpage.html`
- **约束**:
  - 必须三层分析——缺任何一层都不完整
  - Layer1 共识层参考 TDesign 设计规范（行业验证的设计模式）
  - Layer2 趋势层参考 UI-Prompt 80+ 风格分类（当前设计话语）
  - Layer3 如果发现真正洞察 → 标记 EUREKA
  - 不抄竞品——知道他们做什么是为了不重蹈覆辙
  - SAFE/RISK 标注每个设计决策
- **示例**:
  ```
  用户: "看看宠物测试竞品的设计"
  输出: 🎨 竞品设计综合
        Layer1 共识: 答题卡片+进度条+结果分享 → SAFE
        Layer2 趋势: 圆角卡片+暖色系+插画风格
        Layer3 第一性原理: 宠物测试的核心是"趣味"不是"科学"
        → EUREKA: 用漫画分镜代替传统问答卡片
  ```

---

## Skill-06: Visual Sketch Handoff（低保真视觉草图）

- **触发条件**: `砺` 的 Office Hours 判断需要 UI 草图；用户说「视觉草图」「wireframe」「粗稿」「页面雏形」「先画一下」时
- **输入**:
  - 目标用户（必填）
  - 核心场景（必填）
  - 最小路径（必填）
  - 情绪关键词（可选）
  - 不可做事项 / 反模式（可选）
- **输出**: 低保真草图说明或线框稿（信息架构 + 页面区块 + 关键交互 + 验收标准）
- **工具**: `read_file`（读砺的设计文档）、必要时 `write_to_file` 落盘草图文档
- **约束**:
  - 草图服务于验证，不追求像素完美
  - 必须标注 SAFE / RISK 设计选择
  - 必须避开 AI 烂俗 10 反模式
  - 输出应能交给 `铸` 实现或交 `鉴` 做 UI 验证

---

## Skill-07: 风格素材检索

- **触发条件**: 用户说「找个风格」「风格参考」「组件参考」「UI 模板」「换个风格」「有没有 XX 风格的」或需要从素材库中获取具体设计资源时
- **输入**:
  - 风格名称或描述（必填）
  - 资源类型: 风格模板 / 组件 / Prompt / 图标（默认自动判断）
  - 技术栈: React / Vue / HTML（默认 HTML）
- **输出**: 匹配的设计资源（代码片段 / Prompt 文本 / 文件路径）+ 使用建议
- **知识库路径**:
  ```
  UI-Prompt（80+ 风格 × 25+ 组件）:
    风格 Prompt:    /workspace/UI-Prompt/public/data/prompts/styles/{category}/{family}/style.md
    风格详细规范:   /workspace/UI-Prompt/public/data/prompts/styles/{category}/{family}/custom.md
    风格完整页面:   /workspace/UI-Prompt/public/data/content/styles/{category}/{family}/{templateId}/fullpage.html
    组件代码:       /workspace/UI-Prompt/public/data/content/components/{category}/{component}/{variant}/demo.html
    组件 Prompt:    /workspace/UI-Prompt/public/data/prompts/components/{category}/{component}/{variant}/custom.md
    风格注册表:     /workspace/UI-Prompt/src/data/styles/_registry.json
    组件注册表:     /workspace/UI-Prompt/src/data/components/_registry.json

  TDesign（中后台设计规范 + 60+ 组件 + 2350 图标）:
    设计规范文档:   /workspace/tdesign/docs/design/
    React 组件库:   /workspace/tdesign-react/packages/components/
    Pro 组件:       /workspace/tdesign-react/packages/pro-components/
    AIGC 组件:      /workspace/tdesign-react/packages/tdesign-react-aigc/
    图标 SVG:       /workspace/tdesign-icons/svg/
  ```
- **工具**: `read_file`（读取素材文件）、`search_content`（搜索组件/风格名）
- **约束**:
  - 优先从 UI-Prompt 获取风格灵感和 Prompt
  - 优先从 TDesign 获取中后台组件和规范
  - 返回资源时必须附带使用建议（适配技术栈、避免冲突）
  - 推荐风格时必须标注 SAFE/RISK 属性
  - 推荐时排除 AI 烂俗高风险风格（gradients、glow、particle 需警告）
- **风格速查**:
  | 分类 | 可选风格 | SAFE/RISK |
  |------|---------|----------|
  | Core | flatDesign, fluent2, materialDesign, minimalism, typography | SAFE |
  | Visual-推荐 | neoBrutalism, inkWash, wabiSabi, glassmorphism, bentoGrids, scandi | RISK-中 |
  | Visual-慎用 | gradients, glow, particle, neon | RISK-高(AI味) |
  | Retro | bauhaus, artDeco, swissDesign, midCenturyModern | RISK-中 |
  | Layout | brokenGrid, magazine, masonry, splitScreen | SAFE |
- **示例**:
  ```
  用户: "找一个适合宠物产品的温暖风格"
  输出: 🎨 风格素材检索
        推荐 1: visual/kawaiiMinimal [RISK-中]
          → 可爱极简，圆润形状+暖色调，适合宠物品类
          → Prompt: prompts/styles/visual/kawaiiMinimal/style.md
          → 完整页面: content/styles/visual/kawaiiMinimal/...
        推荐 2: visual/organic [RISK-中]
          → 有机自然风，柔和曲线+大地色系
        推荐 3: core/minimalism [SAFE]
          → 极简主义作为安全基底
        ⚠️ 排除: visual/gradients（AI烂俗反模式#1）
  ```

---

## Skill-08: 组件风格适配

- **触发条件**: 用户说「这个组件换个风格」「组件不好看」「组件太普通」「给组件加点设计感」或需要将现有组件适配到特定设计风格时
- **输入**:
  - 目标组件（必填）
  - 目标风格（必填，可从 Skill-07 获取）
  - 技术栈（可选，默认从项目推断）
- **输出**: 适配后的组件代码 + 设计说明
- **知识库路径**:
  ```
  组件多风格参考:
    /workspace/UI-Prompt/public/data/content/components/{category}/{component}/{variant}/demo.html
    /workspace/UI-Prompt/public/data/content/components/{category}/{component}/{variant}/demo.css
  组件设计 Prompt:
    /workspace/UI-Prompt/public/data/prompts/components/{category}/{component}/{variant}/custom.md
  TDesign 组件基线:
    /workspace/tdesign-react/packages/components/{component}/
  ```
- **工具**: `read_file`（读取参考代码和 Prompt）、`replace_in_file`（修改组件样式）
- **约束**:
  - 先确认 TDesign 是否有现成组件 → 有则基于 TDesign 做风格覆盖
  - 无现成组件 → 从 UI-Prompt 获取对应风格变体的 demo 代码
  - 适配时保持功能不变，只改视觉层
  - 必须通过 AI 烂俗检查
  - 输出代码必须可直接运行
- **组件速查**:
  | 分类 | 组件 | 可用风格变体 |
  |------|------|-------------|
  | 数据展示 | table-basic | bootstrap5, glassmorphism, minimalism, neo-brutalism, neumorphism |
  | 数据展示 | statistics-card | ant-design, bootstrap5, glassmorphism, minimalist, neumorphism |
  | 数据展示 | animated-counter | cyberpunk, material-design, minimalism, skeuomorphism, terminal-cli |
  | 反馈 | modal-dialog | bootstrap, cyberpunk, glassmorphism, material, minimalism, neo-brutalism, neumorphism |
  | 反馈 | toast-notifications | bootstrap, glassmorphism, material, minimalism, neumorphism |
  | 反馈 | loading-animate | bounce, dots, progress, pulse, ring, skeleton, spinner, wave |
  | 高级 | kanban-board | default, modern-detailed |
  | 高级 | range-slider | bootstrap-price-filter, glassmorphism-dual, material-brightness, neumorphism-volume |
- **示例**:
  ```
  用户: "把表格组件换成玻璃态风格"
  输出: 🎨 组件风格适配 | table-basic → glassmorphism
        参考: UI-Prompt/content/components/dataDisplay/table-basic/glassmorphism/
        适配: 背景 rgba(255,255,255,0.1) + backdrop-filter: blur(10px)
        代码: [适配后的完整组件代码]
  ```

---

## 跨 Skill 协作模式

| 协作链 | 触发场景 | Skill 组合 | 输出 |
|--------|---------|-----------|------|
| 系统构建 → 评审 | 「设计系统建好了，帮我评」 | Skill-01 → Skill-02 | DESIGN.md + 评审结果 |
| 评审 → 审计修复 | 「评审发现问题，帮我修」 | Skill-02 → Skill-03 | 评审 + 修复提交 |
| AI味 → 审计修复 | 「太AI味了，修掉」 | Skill-04 → Skill-03 | 检测 + 修复 |
| 竞品 → 系统构建 | 「参考竞品建设计系统」 | Skill-05 → Skill-01 | 竞品分析 + 设计系统 |
| 风格检索 → 系统构建 | 「找个风格然后建设计系统」 | Skill-07 → Skill-01 | 风格选择 + 设计系统 |
| 风格检索 → 组件适配 | 「找个风格然后改组件」 | Skill-07 → Skill-08 | 风格选择 + 组件代码 |
| AI味 → 风格检索 | 「太AI味了，换个风格」 | Skill-04 → Skill-07 | 检测 + 替代风格推荐 |

---

## Skill 质量指标（待采集基线）

| 指标 | 定义 | 目标 |
|------|------|------|
| AI 烂俗命中率 | 检测出的反模式中确认的比例 | > 80% |
| 修复零回归率 | 设计修复不引入新问题的比例 | > 90% |
| 评审覆盖维度 | 7 维度全部评分的比例 | 100% |
| 设计系统采纳率 | DESIGN.md 规范被遵循的比例 | > 80% |
| 原子提交率 | 修复按原子提交规范的比例 | 100% |

---

*每个 Skill 就是一根线束——描述越清楚，模型传导动力越高效。*
