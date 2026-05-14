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

## 4. TDesign Icons 图标库

**本地路径**: `/Users/voidzhang/Documents/workspace/tdesign-icons`

### 定位
2350+ SVG 图标，多框架适配。

### 目录结构

```
tdesign-icons/
├── svg/                        # 2350+ SVG 源文件
└── packages/                   # 多框架适配包
```

### 使用场景
- 优先查找现有图标，避免自造轮子
- 遵循 SOUL.md "Material Symbols 优先" 原则，TDesign 图标作为补充
- 图标风格一致性检查

---

## 5. 资源协作关系

```
设计决策流:
  「绘」方法论（SOUL.md 9原则 + 10反模式）
      ↓ 判断标准
  UI-Prompt（80+ 风格 → 选择视觉方向）
      ↓ 风格 Prompt
  TDesign（组件规范 → 工程约束）
      ↓ 组件实现
  最终产出

一句话: 「绘」是设计判断力，UI-Prompt 是视觉词汇量，TDesign 是工程约束。
```

---

## 6. 常用操作速查

| 我想要... | 操作 |
|-----------|------|
| 选一个不 AI 味的风格 | 读取 `UI-Prompt/public/data/prompts/styles/{category}/{family}/style.md` |
| 看风格的完整页面效果 | 读取 `UI-Prompt/public/data/content/styles/{category}/{family}/{id}/fullpage.html` |
| 让 AI 按风格生成代码 | 读取 `UI-Prompt/public/data/prompts/styles/{category}/{family}/custom.md` 作为上下文 |
| 确定中后台布局框架 | 读取 `tdesign/docs/design/offices_zh-CN.md` |
| 找现成 React 组件 | 查看 `tdesign-react/packages/components/{component}/` |
| 找图标 | 查看 `tdesign-icons/svg/{name}.svg` |
| 看组件的多风格实现 | 读取 `UI-Prompt/public/data/content/components/{category}/{component}/{variant}/` |
| 批量了解可用资源 | 读取 `UI-Prompt/src/data/styles/_registry.json` 或 `components/_registry.json` |
