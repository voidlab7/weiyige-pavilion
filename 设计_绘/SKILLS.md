# 设计（绘）— Skills 执行手册

> v3.0 | 2026-05-20 | AI 可执行格式

---

## §0 路径常量（所有 Skill 引用此处）

```
$TD   = /Users/voidzhang/Documents/workspace/MicroDesign/tdesign
$TDR  = /Users/voidzhang/Documents/workspace/MicroDesign/tdesign-react
$UIP  = /Users/voidzhang/Documents/workspace/MicroDesign/UI-Prompt
$OD   = /Users/voidzhang/Documents/workspace/MicroDesign/open-design

# UI-Prompt 风格
UIP_STYLE_PROMPT  = $UIP/public/data/prompts/styles/{category}/{family}/style.md
UIP_STYLE_CUSTOM  = $UIP/public/data/prompts/styles/{category}/{family}/custom.md
UIP_STYLE_PAGE    = $UIP/public/data/content/styles/{category}/{family}/{templateId}/fullpage.html
UIP_STYLE_REG     = $UIP/src/data/styles/_registry.json

# UI-Prompt 组件
UIP_COMP_DEMO     = $UIP/public/data/content/components/{category}/{component}/{variant}/demo.html
UIP_COMP_CSS      = $UIP/public/data/content/components/{category}/{component}/{variant}/demo.css
UIP_COMP_PROMPT   = $UIP/public/data/prompts/components/{category}/{component}/{variant}/custom.md
UIP_COMP_REG      = $UIP/src/data/components/_registry.json

# TDesign
TD_DESIGN_DOCS    = $TD/docs/design/
TD_COMPONENTS     = $TDR/packages/components/
TD_PRO            = $TDR/packages/pro-components/
TD_AIGC           = $TDR/packages/tdesign-react-aigc/

# Open Design
OD_CRAFT          = $OD/craft/
OD_DESIGN_SYS     = $OD/design-systems/{brand}/DESIGN.md
OD_SCHEMA         = $OD/docs/design-systems.md
OD_TEMPLATES      = $OD/design-templates/{type}/SKILL.md
OD_TEMPLATES_HTML = $OD/design-templates/{type}/example.html
```

---

## §1 路由器（Skill Router）

设计师被激活时，先执行路由逻辑，再进入具体 Skill。

```python
def route(user_input):
    signal = extract_signal(user_input)

    # 模式判断
    if signal in ["看一下", "检查", "AI味", "评审", "审计", "修一下", "不对"]:
        mode = "Check"
    elif signal in ["设计系统", "新产品", "页面Spec", "出图", "风格", "草图", "从零开始"]:
        mode = "Build"
    else:
        mode = "Check"  # 默认

    # Check 模式路由
    if mode == "Check":
        if "AI味" or "烂俗" or "模板" in signal:
            run(C3_AI_SLOP_DETECT)
            if findings >= 3:
                suggest_switch_to_build()
            elif findings >= 1:
                run(C2_AUDIT_FIX)
        elif "评审" or "评分" in signal:
            run(C1_DESIGN_REVIEW)
            if any_score < 7:
                run(C2_AUDIT_FIX)
        elif "修" or "审计" in signal:
            run(C2_AUDIT_FIX)
        else:
            run(C3_AI_SLOP_DETECT)  # 模糊时默认先检测

    # Build 模式路由
    if mode == "Build":
        has_design_md = check_file_exists("DESIGN.md")
        has_style = check_context("风格已选定")
        has_spec = check_file_exists("page-spec-*.md")

        if "竞品" in signal:
            run(B1_COMPETITOR)
        if "风格" in signal or not has_style:
            run(B2_STYLE_SEARCH)
        if "设计系统" in signal or not has_design_md:
            run(B3_DESIGN_SYSTEM)
        if "组件" in signal:
            run(B4_COMPONENT_ADAPT)
        if "草图" or "wireframe" in signal:
            run(B5_VISUAL_SKETCH)
        if "Spec" or "交给铸" in signal:
            if not has_design_md:
                run(B3_DESIGN_SYSTEM)  # 前置依赖
            run(B6_PAGE_SPEC)
        if "出图" or "参考图" or "Stitch" in signal:
            run(B7_STITCH_VISUAL)

    # 中断条件
    # - 风格选型需用户确认（多选一）
    # - 审计修复累计改动 > 20% 时停止
    # - 缺少产品信息无法自动构建 DESIGN.md 时询问用户
```

---

## §2 Check 模式

### C1: 设计评审（7 维度评分）

**触发**: "设计审查"、"评审"、"评分"、"UI审查"

**执行步骤**:
1. `browser_take_screenshot` 获取目标页面截图
2. 逐项评分 7 维度（0-10）：层次 / 信息 / 视觉 / 交互 / 边界 / 信任 / AI味
3. 每个 < 7 分的维度输出 FINDING + 修复建议
4. 汇总评分表 + 发现清单
5. 低分项自动触发 C2

**硬性约束**:
- 7 维度全部评分，不跳过
- 评分必须有区分度（禁止全 7-8）
- AI 烂俗维度必须单独列项

**输出格式**:
```
| 维度 | 分数 | FINDING |
|------|------|---------|
| 层次 | X/10 | ...     |
```

---

### C2: 设计审计修复

**触发**: "修UI"、"审计"、"视觉QA"；或由 C1/C3 自动触发

**执行步骤**:
1. `browser_take_screenshot` 获取 before 截图
2. `grep_search` 定位相关 CSS/组件源码
3. 执行最小修复（CSS 优先于结构变更）
4. 原子提交：`style(design): FINDING-NNN — 描述`
5. `browser_take_screenshot` 获取 after 截图
6. 对比验证

**硬性约束**:
- 每 5 个修复评估累计改动量，> 20% 停止
- before/after 截图是强制证据
- CSS-only 改动 +0% 风险，组件级 +5%

---

### C3: AI 烂俗检测

**触发**: "AI味"、"烂俗"、"太模板了"；或 Check 模式默认首步

**执行步骤**:
1. `browser_take_screenshot` 获取目标截图
2. 逐项检查 10 大反模式：
   - [1] 紫色/靛蓝渐变背景
   - [2] 三列特性网格（圆图标+粗标题+两行描述 ×3）
   - [3] 彩色圆圈中的图标装饰
   - [4] 所有内容居中
   - [5] 统一超大圆角
   - [6] 装饰性 blob/浮动圆圈/波浪 SVG
   - [7] Emoji 作为设计元素
   - [8] 卡片左边框彩色条
   - [9] 模板化英雄文案 "Welcome to X"
   - [10] 千篇一律节奏（英雄→三特性→推荐→价格→CTA）
3. 输出命中项 + 严重度 + 修复建议

**判定规则**:
- 命中 0 项 → 通过
- 命中 1-2 项 → 局部修复（触发 C2）
- 命中 3+ 项 → 建议切 Build 模式重构

---

## §3 Build 模式

### B1: 竞品设计综合

**触发**: "竞品设计"、"参考设计"、"别人怎么做"

**执行步骤**:
1. `web_search` 搜索品类竞品的设计截图/分析文章
2. 三层分析：
   - Layer1 共识：品类内所有产品共有的设计模式
   - Layer2 趋势：`read_file(UIP_STYLE_REG)` 对照当前流行风格
   - Layer3 第一性原理：基于用户特征，传统方案为什么可能是错的
3. 如果 Layer3 发现真正洞察 → 标记 **EUREKA**
4. 每个设计决策标注 SAFE / RISK

**输出**: 竞品综合报告（三层结构）

---

### B2: 风格素材检索

**触发**: "找个风格"、"风格参考"、"换个风格"、"有没有XX风格"

**执行步骤**:
1. `read_file(UIP_STYLE_REG)` 获取可用风格列表
2. 根据用户描述匹配风格 family
3. `read_file(UIP_STYLE_PROMPT)` 读取匹配风格的 style.md
4. 如需详细规范：`read_file(UIP_STYLE_CUSTOM)` 读取 custom.md
5. 返回风格名 + Prompt 文本 + SAFE/RISK 标注 + 使用建议

**风格速查表**:

| 分类 | 风格 | SAFE/RISK |
|------|------|-----------|
| Core | flatDesign, fluent2, materialDesign, minimalism, typography | SAFE |
| Visual-推荐 | neoBrutalism, inkWash, wabiSabi, glassmorphism, bentoGrids, scandi | RISK-中 |
| Visual-慎用 | gradients, glow, particle, neon | RISK-高(AI味) |
| Retro | bauhaus, artDeco, swissDesign, midCenturyModern | RISK-中 |
| Layout | brokenGrid, magazine, masonry, splitScreen | SAFE |

**约束**: 推荐 RISK-高 风格时必须附带 AI 烂俗警告

---

### B3: 设计系统构建

**触发**: "设计系统"、"DESIGN.md"、"视觉规范"

**前置检查**: 项目已有 DESIGN.md → 跳过

**执行步骤**:
1. 确定品类，从 OD 151 个品牌中选基座：
   ```
   工具类 → $OD/design-systems/linear-app/DESIGN.md
   电商   → $OD/design-systems/shopify/DESIGN.md
   开发者 → $OD/design-systems/vercel/DESIGN.md
   金融   → $OD/design-systems/stripe/DESIGN.md
   社交   → $OD/design-systems/discord/DESIGN.md
   内容   → $OD/design-systems/notion/DESIGN.md
   ```
2. `read_file(OD_DESIGN_SYS)` 读取选定基座
3. `read_file(OD_SCHEMA)` 读取 9 章节 Schema 规范
4. 按 9 章节逐章改造：
   - §1 Visual Theme → 从 B2 选定的风格注入
   - §2 Color → 按 `read_file($OD/craft/color.md)` 四层规则配色
   - §3 Typography → 按 `read_file($OD/craft/typography.md)` 校准
   - §4 Components → 从 TDesign 选型
   - §5 Layout → 参照 `read_file($TD/docs/design/offices_zh-CN.md)`
   - §6-§9 → 按 Schema 填充
5. 用 Craft 12 条规则逐项质检
6. `write_to_file` 输出 DESIGN.md

**硬性约束**:
- 必须通过 C3 反模式检查
- SAFE/RISK 分层标注
- 无障碍：对比度 ≥ 4.5:1

---

### B4: 组件风格适配

**触发**: "组件换风格"、"组件不好看"、"给组件加设计感"

**执行步骤**:
1. 确认目标组件和目标风格
2. 检查 TDesign 是否有现成组件：`read_file($TDR/packages/components/{component}/)`
3. 如有 → 基于 TDesign 做风格覆盖
4. 如无 → `read_file(UIP_COMP_DEMO)` 获取 UI-Prompt 对应风格变体
5. `read_file(UIP_COMP_PROMPT)` 获取组件设计 Prompt
6. 输出适配后的组件代码 + 设计说明

**组件速查**:

| 组件 | 可用风格变体 |
|------|-------------|
| table-basic | bootstrap5, glassmorphism, minimalism, neo-brutalism, neumorphism |
| statistics-card | ant-design, bootstrap5, glassmorphism, minimalist, neumorphism |
| animated-counter | cyberpunk, material-design, minimalism, skeuomorphism, terminal-cli |
| modal-dialog | bootstrap, cyberpunk, glassmorphism, material, minimalism, neo-brutalism |
| toast-notifications | bootstrap, glassmorphism, material, minimalism, neumorphism |
| loading-animate | bounce, dots, progress, pulse, ring, skeleton, spinner, wave |
| kanban-board | default, modern-detailed |
| range-slider | bootstrap-price-filter, glassmorphism-dual, material-brightness, neumorphism-volume |

**约束**: 只改视觉层，保持功能不变；输出代码必须可直接运行

---

### B5: 低保真视觉草图

**触发**: "视觉草图"、"wireframe"、"粗稿"、"先画一下"

**执行步骤**:
1. 确认输入：目标用户 + 核心场景 + 最小路径
2. 输出信息架构（页面区块划分）
3. 输出 ASCII 线框稿或结构描述
4. 标注 SAFE / RISK 设计选择
5. 标注关键交互 + 验收标准
6. `write_to_file` 落盘草图文档

**约束**: 服务于验证，不追求像素完美；必须避开 AI 烂俗 10 反模式

---

### B6: 页面设计 Spec

**触发**: "页面Spec"、"设计交付"、"交给铸"、"开发规格"

**前置检查**: 无 DESIGN.md → 先触发 B3

**执行步骤**:
1. `read_file` 读取 DESIGN.md + 需求文档
2. 按 10 章节模板输出 Spec：
   ```
   §1 视觉参考
   §2 布局结构（含 ASCII 布局图）
   §3 色彩应用（引用 CSS 变量，禁止硬编码 hex）
   §4 排版规格
   §5 间距系统
   §6 组件清单（来源 + 变体 + props）
   §7 交互规格（时长 + 缓动函数）
   §8 状态设计（五态：Loading/Empty/Error/Populated/Edge）
   §9 响应式断点
   §10 反例（不要做）
   ```
3. `write_to_file` 输出到 `{项目}/ai-workspace/{task-id}/artifacts/page-spec-{页面名}.md`

**硬性约束**:
- 色值/间距/字号必须引用 DESIGN.md CSS 变量
- 组件必须标注来源（TDesign / 自定义）
- 交互必须有时长和缓动
- 状态必须覆盖五态
- 反例必须引用 DESIGN.md §10

---

### B7: 视觉参考生成（Stitch）

**触发**: "生成参考图"、"Stitch出图"、"让我看看效果"

**执行步骤**:
1. 从 B6 输出的页面 Spec 提取 Stitch prompt：
   - 页面用途（一句话）
   - 布局结构（§2 转自然语言）
   - 色彩方案（§3 主要色值）
   - 关键组件（§6 列表）
   - 风格关键词（DESIGN.md §1）
   - 反例约束（§10 禁止项）
2. 调用 Stitch MCP `generate_screen_from_text`
3. 展示截图给用户确认
4. 确认后将 URL 回写到页面 Spec §1

**约束**:
- 生成后必须人工确认
- 参考图是"方向参考"非"像素规格"
- 如 Stitch 项目已有 Design System，优先使用

---

## §4 Craft 工艺规则（质检用）

Build 模式产出前，必须用以下规则逐项检查。Check 模式引用相关项。

| 规则 | 文件 | 核心约束 |
|------|------|---------|
| 色彩 | `$OD/craft/color.md` | 中性色 70-90%，强调色 5-10%，每屏最多 2 处 accent |
| 排版 | `$OD/craft/typography.md` | 比例 1.2/1.25，Body 15-18px，行高 1.5-1.6 |
| 排版层级 | `$OD/craft/typography-hierarchy.md` | 唯一主导入口，层级间有意节奏 |
| 动效 | `$OD/craft/animation-discipline.md` | 仅用于空间/时间重定向 |
| 反AI | `$OD/craft/anti-ai-slop.md` | 七宗罪 |
| 无障碍 | `$OD/craft/accessibility-baseline.md` | WCAG 2.2 AA，对比度 ≥ 4.5:1 |
| 状态 | `$OD/craft/state-coverage.md` | 五态必覆盖 |
| 表单 | `$OD/craft/form-validation.md` | 验证生命周期 |
| UX法则 | `$OD/craft/laws-of-ux.md` | Hick/Miller/Fitts/Gestalt |

**执行方式**: `read_file($OD/craft/{rule}.md)` 读取规则 → 对照产出逐项检查

---

## §5 OD 页面模板（特定场景加载）

当用户需求匹配以下场景时，`read_file` 对应 SKILL.md + example.html 作为执行指引：

| 场景 | SKILL.md 路径 | example.html |
|------|--------------|--------------|
| Dashboard | `$OD/design-templates/dashboard/SKILL.md` | ✅ |
| Landing Page | `$OD/design-templates/landing-page/SKILL.md` | ✅ |
| SaaS 营销 | `$OD/design-templates/saas-marketing/SKILL.md` | ✅ |
| 定价页 | `$OD/design-templates/pricing/SKILL.md` | ✅ |
| 博客 | `$OD/design-templates/blog/SKILL.md` | ✅ |
| 电商 | `$OD/design-templates/ecommerce/SKILL.md` | ✅ |
| Portfolio | `$OD/design-templates/portfolio/SKILL.md` | ✅ |

**执行方式**: `read_file($OD/design-templates/{type}/SKILL.md)` → 按其中 workflow 步骤执行

---

## §6 路由器中断条件

以下情况必须停止执行，等待用户输入：

1. **风格选型多选一** → 展示 2-3 个选项，等用户选
2. **审计修复 > 20%** → 报告已修复项，建议用户决定是否继续
3. **缺少产品信息** → 无法构建 DESIGN.md，询问品类/用户/场景
4. **视觉参考确认** → Stitch 生成后展示截图，等用户确认
5. **Build 模式升级** → Check 发现严重问题，建议重构前征求同意
