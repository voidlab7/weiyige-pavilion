# 设计（绘） — 领域知识

> 最后更新: 2026-05-08

---

## 1. UI-Prompt 风格素材库

**本地路径**: `/Users/voidzhang/Documents/workspace/UI-Prompt`

### 定位
提供 80+ 种 UI 风格、25+ 种组件、完整页面模板和精心编写的 AI Prompt。用于驱动稳定的"AI → UI"输出，减少 AI 生成感。

### 核心目录结构

```
UI-Prompt/public/data/
├── content/                    # HTML/CSS/JSX 代码文件
│   ├── components/             # 组件代码（25+ 组件 × 多风格变体）
│   └── styles/                 # 风格/页面模板代码（80+ 风格）
├── prompts/                    # AI Prompt 文档
│   ├── components/             # 组件 Prompt（custom.md）
│   └── styles/                 # 风格 Prompt（style.md + custom.md）
└── compiled-jsx/               # 预编译的 JSX 文件
```

### 路径模式速查

| 需求 | 路径模式 |
|------|---------|
| 组件 HTML/CSS | `public/data/content/components/{category}/{component}/{variant}/demo.html` |
| 完整风格页面 | `public/data/content/styles/{category}/{family}/{templateId}/fullpage.html` |
| 组件 Prompt | `public/data/prompts/components/{category}/{component}/{variant}/custom.md` |
| 风格概述 Prompt | `public/data/prompts/styles/{category}/{family}/style.md` |
| 风格详细 Prompt | `public/data/prompts/styles/{category}/{family}/custom.md` |
| 元数据注册表 | `src/data/styles/_registry.json` / `src/data/components/_registry.json` |

### 风格分类索引

| 分类 | 风格列表 | 数量 |
|------|---------|------|
| **Core** | flatDesign, fluent2, materialDesign, minimalism, scrollNarrative, skeuomorphism, typography | 7 |
| **Visual** | 3dElements, accessibility, ambient, antiDesign, auroraGlass, bentoGrids, biophilic, blueprint, claymorphism, comicBook, corporate, darkMode, duotone, fabric, generativeArt, glassmorphism, glow, gradients, grain, handDrawnSketch, holographic, holographicFoil, industrial, inkWash, kawaiiMinimal, leather, light, liminalSpace, liquid, maximalism, memphis, monochrome, natural, nature, neoBrutalism, neon, neonCyberpunk, neonNoir, organic, outlineStyle, paperCutout, particle, popArt, scandi, sciFiHud, smoke, softUI, solarpunk, spotlight, utilityFirst, vaporwave, wabiSabi, y2k | 50+ |
| **Retro** | arcadeCRT, artDeco, bauhaus, darkAcademia, digitalRetro, filmNoir, frutigerAero, midCenturyModern, newspaper, retroFuturism, retroOS, steampunk, swissDesign, synthwave, vhsAesthetic | 15 |
| **Layout** | brokenGrid, magazine, masonry, splitScreen | 4 |
| **Interaction** | mouseTracking | 1 |

### 组件分类索引

| 分类 | 组件 | 可用风格变体 |
|------|------|-------------|
| **dataDisplay** | table-basic, card-grid, list-view, statistics-card, animated-counter | bootstrap5, glassmorphism, minimalism, neo-brutalism, neumorphism, material-design, ant-design 等 |
| **feedback** | modal-dialog, toast-notifications, alert-messages, loading-animate, reaction-picker, tour-guide | bootstrap, glassmorphism, material, minimalism, neumorphism, cyberpunk, neo-brutalism 等 |
| **advanced** | calendar-date-picker, code-editor, color-picker, custom-scrollbar, file-upload, focus-navigator, kanban-board, map-picker, query-builder, range-slider, rich-text-editor, scrollbar-thumb | 多种变体 |
| **input** | autocomplete-search, tags-input, rich-textarea | — |

### SAFE/RISK 风格推荐

```
SAFE 层（品类基线）:
  → core/minimalism        — 极简主义（万能安全牌）
  → core/materialDesign    — Material Design（中后台标配）
  → core/flatDesign        — 扁平化（移动端友好）

RISK 层（品牌辨识度）:
  → visual/neoBrutalism    — 新残酷主义（年轻、叛逆）
  → visual/inkWash         — 水墨风（中国文化、高端）
  → visual/wabiSabi        — 侘寂（极致克制、禅意）
  → visual/glassmorphism   — 玻璃态（现代感、层次感）
  → retro/bauhaus          — 包豪斯（设计感、专业）
  → visual/bentoGrids      — Bento 网格（Apple 风、信息密度）
  → visual/scandi          — 北欧风（温暖、自然）
  → retro/swissDesign      — 瑞士设计（理性、精确）

⚠️ 避免（AI 烂俗高风险）:
  → visual/gradients       — 渐变（反模式 #1 紫色渐变）
  → visual/glow            — 发光效果（容易 AI 味）
  → visual/particle        — 粒子效果（装饰性 blob，反模式 #6）
```

---

## 2. TDesign 设计规范

**本地路径**: `/Users/voidzhang/Documents/workspace/tdesign`

### 定位
腾讯企业级设计体系，提供中后台设计规范文档，是页面框架、导航模式、布局规则的权威来源。

### 核心目录

```
tdesign/docs/design/
├── index.md                    # 设计指南总览
├── offices_zh-CN.md            # 中后台框架设计（导航/布局/任务流）
└── ...                         # 其他设计规范文档
```

### 使用场景
- 确定页面导航模式（上下/左右/混合布局）
- 高频任务设计模式（数据筛选、表格操作、状态流转）
- 作为 SAFE 层设计决策的理论基础
- 设计评审 Pass 5（设计系统对齐）的对标基线

---

## 3. TDesign React 组件库

**本地路径**: `/Users/voidzhang/Documents/workspace/tdesign-react`

### 定位
TDesign 的 React 实现，60+ 基础组件 + Pro 组件 + AIGC 组件。

### 组件清单（部分）

```
基础组件: button, input, select, checkbox, radio, switch, slider,
         upload, form, table, pagination, dialog, drawer, message,
         notification, popconfirm, tooltip, dropdown, menu, tabs,
         breadcrumb, steps, tree, transfer, cascader, date-picker,
         time-picker, color-picker, card, collapse, divider, image,
         avatar, badge, tag, progress, loading, skeleton, space,
         layout, grid, affix, anchor, back-top, watermark...

Pro 组件: chat（对话组件）
AIGC 组件: tdesign-react-aigc
```

### 使用场景
- 确认组件能力边界（设计时不超出实现能力）
- 了解组件的交互状态定义
- 作为设计系统构建时的"积木清单"

---

## 4. Open Design 资源库

**本地路径**: `/Users/voidzhang/Documents/workspace/MicroDesign/open-design`

### 定位
提供设计系统基座（151 个品牌 DESIGN.md）、工艺规则（12 条 craft）、页面模板 workflow（110 个 design-templates）。

### 真正可用的资源（AI 运行时可直接 read_file）

```
open-design/
├── craft/                      # 12 条通用工艺规则（每个 84-134 行）
│   ├── color.md                # 四层调色板规则
│   ├── typography.md           # 字体比例规则
│   ├── anti-ai-slop.md         # 反 AI 烂俗七宗罪
│   ├── state-coverage.md       # 五态必覆盖
│   ├── accessibility-baseline.md # WCAG 2.2 AA
│   └── ...                     # 共 12 个 .md 文件
├── design-systems/             # 151 个品牌设计系统
│   └── {brand}/DESIGN.md       # 每个 300-400 行，含精确色值/字体/间距
├── design-templates/           # 110 个页面模板
│   └── {type}/                 # 每个含 SKILL.md（workflow）+ example.html（参考实现）
└── docs/design-systems.md      # 9 章节 DESIGN.md Schema 规范（328 行）
```

### 使用场景
- **构建 DESIGN.md**：从 design-systems/ 选一个品牌作为基座，按 docs/design-systems.md 的 9 章节 schema 改造
- **设计质检**：用 craft/ 12 条规则逐项检查设计产出
- **生成特定页面**：读取 design-templates/{type}/SKILL.md 获取 workflow，参考 example.html 生成

### ⚠️ 不可用的资源（不要引用）
- `skills/` 目录：107 个中 94 个只有空壳 SKILL.md（指向外部仓库，本地无实际内容）
- `prompt-templates/`：图片/视频生成 prompt，和 UI 设计无关
- `apps/`、`packages/`、`tools/`：OD 平台自身代码，非设计资源

---

## 6. 资源协作关系

```
设计决策流:
  「绘」方法论（SOUL.md 9原则 + 10反模式）
      ↓ 判断标准
  Open Design（craft 工艺规则 → 品质底线；design-systems → 基座选型）
      ↓ 规则 + 基座
  UI-Prompt（80+ 风格 → 选择视觉方向）
      ↓ 风格 Prompt
  TDesign（组件规范 → 工程约束）
      ↓ 组件实现
  最终产出

一句话: 「绘」是设计判断力，OD 是品质底线和基座，UI-Prompt 是视觉词汇量，TDesign 是工程约束。
```
---

## 7. 常用操作速查

| 我想要... | 操作 |
|-----------|------|
| 选一个不 AI 味的风格 | 读取 `UI-Prompt/public/data/prompts/styles/{category}/{family}/style.md` |
| 看风格的完整页面效果 | 读取 `UI-Prompt/public/data/content/styles/{category}/{family}/{id}/fullpage.html` |
| 让 AI 按风格生成代码 | 读取 `UI-Prompt/public/data/prompts/styles/{category}/{family}/custom.md` 作为上下文 |
| 确定中后台布局框架 | 读取 `tdesign/docs/design/offices_zh-CN.md` |
| 找现成 React 组件 | 查看 `tdesign-react/packages/components/{component}/` |
| 找图标 | 模型直接生成 SVG（简单图标）或使用 Lucide React 等轻量图标库 |
| 看组件的多风格实现 | 读取 `UI-Prompt/public/data/content/components/{category}/{component}/{variant}/` |
| 批量了解可用资源 | 读取 `UI-Prompt/src/data/styles/_registry.json` 或 `components/_registry.json` |
| 选品牌基座构建 DESIGN.md | 读取 `open-design/design-systems/{brand}/DESIGN.md` |
| 了解 DESIGN.md 9 章节规范 | 读取 `open-design/docs/design-systems.md` |
| 检查设计工艺品质 | 读取 `open-design/craft/{rule}.md`（如 color.md、anti-ai-slop.md） |
| 生成特定类型页面 | 读取 `open-design/design-templates/{type}/SKILL.md` 获取 workflow |