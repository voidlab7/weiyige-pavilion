# 公众号 HTML 排版技能 — wechat-html-writer

将 Markdown / 纯文本文章转换为**微信公众号编辑器可直接粘贴**的纯内联样式 HTML。

## 适用场景

- 用户要求将文章转为公众号 HTML
- 用户提到"公众号排版"、"公众号文章"、"微信文章"
- 用户要求把 Markdown 转为可直接粘贴发布的 HTML
- 用户要求"帮我排个版"

## 设计原则

**干净、克制、有呼吸感。像在咖啡馆写的技术笔记，不像发布会 PPT。**

- 不堆 emoji，不搞 CHAPTER 01 编号，不加英文副标题
- 不用花哨配色，用灰度 + 一个点缀色
- 段落留白充足，手机阅读不压迫
- 金句不喊口号，用细线框安静呈现
- 代码块是刚需，深色底 + 等宽字体

---

## 工作流程

### 1. 分析原文

读原文，识别：
- 文章标题
- 核心观点（用于开篇引言）
- 章节结构（按 `##` / `###` 层级拆分）
- 每个章节中适合可视化的内容：对比、步骤、列表、金句、代码块、图片

### 2. 选择组件

| 内容类型 | 推荐组件 |
|---------|---------|
| 核心金句 | 金句卡片（细线框，居中） |
| 引用/格言/总结 | 引言块（左边线 + 浅底色） |
| A vs B 对比 | 两列对比卡片 |
| 流程/步骤 | 步骤条 |
| 多个并列概念 | 信息卡片网格 |
| 代码/命令 | 代码块（深色底） |
| 图片 | 居中图片 + 图注 |
| 补充说明 | 灰色提示块 |
| 关键警告 | 提示块（暖色边框） |
| 表格数据 | 简洁表格 |

### 3. 组装 HTML

使用下方的组件库组装。遵守硬性规则。

### 4. 质量检查

输出前验证：
- [ ] 无 `<style>` 或 `<script>` 标签
- [ ] 无 CSS class 或变量
- [ ] 无外部资源引用
- [ ] 所有颜色使用定义的色板
- [ ] 每个章节至少有标题 + 正文（不强制每章都有可视化组件）
- [ ] 代码块保留完整，不截断
- [ ] 图片路径正确

---

## 硬性约束

- **纯内联样式**：不使用 `<style>`、`<script>`、`<link>` 标签
- **零外部依赖**：不引用外部 CSS / JS / 字体 / 图片 CDN
- **无 CSS 变量**：不用 `var(--xxx)`
- **无 CSS class**：公众号编辑器会过滤 class
- **最外层容器**：`max-width:680px`（公众号正文区宽度）

---

## 色彩体系

克制的灰度体系 + 一个点缀色。

| 用途 | 色值 | 说明 |
|------|------|------|
| 标题 | `#1a1a1a` | 近黑，沉稳 |
| 正文 | `#2c2c2c` | 深灰，长文阅读不刺眼 |
| 辅助文字 | `#888` | 图注、副标题、补充说明 |
| 浅灰文字 | `#aaa` | 极弱装饰性文字 |
| 点缀色 | `#4a7c6f` | 青灰绿，用于强调、引言边线、金句 |
| 点缀色浅底 | `#f4f8f6` | 引言块/提示块背景 |
| 边框色 | `#e8e8e8` | 卡片、表格、分割线 |
| 代码块底色 | `#1e1e1e` | 深色，VS Code 风格 |
| 代码块文字 | `#d4d4d4` | 浅灰等宽文字 |
| 暖灰背景 | `#faf9f7` | 信息卡片底色 |
| 红色 | `#c0392b` | 错误/反面（极少用） |
| 绿色 | `#27ae60` | 正确/正面（极少用） |

---

## 文档骨架

```
标题区        居中：h1 + 一句话引导
开篇引言      左边线引言块，概括全文
──分割线──
章节 1        h2 标题 + 正文 + 组件（可选）
──分割线──
章节 2        ...
──分割线──
...
──分割线──
结语          居中收尾 + 金句卡片（可选）
尾部信息      作者/项目地址/往期链接
```

---

## 组件代码片段

### 1. 最外层容器

```html
<div style="max-width:680px; margin:0 auto; font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Hiragino Sans GB','Microsoft YaHei',sans-serif; color:#2c2c2c; line-height:1.9; font-size:15px; padding:0 16px;">
  ...全部内容...
</div>
```

### 2. 标题区

```html
<div style="padding:36px 0 20px;">
  <h1 style="font-size:24px; font-weight:700; color:#1a1a1a; margin:0 0 10px; line-height:1.5;">文章主标题</h1>
  <p style="color:#888; font-size:14px; margin:0;">一句话引导语</p>
</div>
```

注意：标题不居中（左对齐更像笔记），字号 24px 不要太大。

### 3. 开篇引言

```html
<blockquote style="border-left:3px solid #4a7c6f; padding:14px 18px; margin:16px 0 28px; background:#f4f8f6; color:#2c2c2c; font-size:14px; line-height:1.9; border-radius:0 6px 6px 0;">
  全文核心观点概括。
</blockquote>
```

### 4. 分割线

```html
<hr style="border:none; border-top:1px solid #e8e8e8; margin:32px 0;">
```

### 5. 章节标题（h2）

```html
<h2 style="font-size:18px; font-weight:700; color:#1a1a1a; margin:0 0 14px; line-height:1.5; padding-bottom:8px; border-bottom:1px solid #e8e8e8;">章节标题</h2>
```

带底线的 h2，简洁分隔。

### 6. 小节标题（h3）

```html
<h3 style="font-size:16px; font-weight:600; color:#1a1a1a; margin:24px 0 10px; line-height:1.5;">小节标题</h3>
```

### 7. 正文段落

```html
<p style="font-size:15px; color:#2c2c2c; line-height:2; margin-bottom:16px;">正文内容。<strong>加粗关键句</strong>。</p>
```

行高 2，段落间距 16px，手机阅读舒服。

### 8. 强调文字

```html
<span style="color:#4a7c6f; font-weight:600;">点缀色强调</span>
```

不要滥用。一段最多一处。

### 9. 引言块

```html
<blockquote style="border-left:3px solid #4a7c6f; padding:12px 18px; margin:18px 0; background:#f4f8f6; color:#555; font-size:14px; line-height:1.9; border-radius:0 6px 6px 0;">
  引言内容。
</blockquote>
```

### 10. 金句卡片

```html
<div style="text-align:center; padding:20px 24px; margin:24px 0; border:1px solid #e8e8e8; border-radius:6px;">
  <p style="font-size:15px; font-weight:600; color:#1a1a1a; margin:0; line-height:1.8;">金句内容。</p>
</div>
```

白底 + 细线框，不加底色、不加 emoji 装饰、不加 ✦ 符号。安静呈现。

### 11. 代码块

```html
<div style="background:#1e1e1e; border-radius:6px; padding:16px 18px; margin:18px 0; overflow-x:auto;">
  <pre style="margin:0; font-family:'SF Mono','Fira Code','Consolas',monospace; font-size:13px; color:#d4d4d4; line-height:1.7; white-space:pre-wrap; word-wrap:break-word;">代码内容</pre>
</div>
```

深色底，等宽字体，圆角。如果有语言标识可以加：

```html
<div style="margin:18px 0;">
  <div style="background:#2d2d2d; padding:6px 14px; border-radius:6px 6px 0 0; display:inline-block;">
    <span style="font-size:12px; color:#888; font-family:'SF Mono',monospace;">bash</span>
  </div>
  <div style="background:#1e1e1e; border-radius:0 6px 6px 6px; padding:16px 18px; overflow-x:auto;">
    <pre style="margin:0; font-family:'SF Mono','Fira Code','Consolas',monospace; font-size:13px; color:#d4d4d4; line-height:1.7; white-space:pre-wrap; word-wrap:break-word;">curl -fsSL https://example.com/install.sh | bash</pre>
  </div>
</div>
```

### 12. 两列对比卡片

```html
<table style="width:100%; border-collapse:collapse; margin:20px 0; font-size:14px;">
  <tr>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#faf9f7;">
      <div style="font-weight:700; margin-bottom:6px; color:#1a1a1a;">方案 A</div>
      <div style="color:#555; font-size:13px; line-height:1.8;">描述内容</div>
    </td>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#fff;">
      <div style="font-weight:700; margin-bottom:6px; color:#1a1a1a;">方案 B</div>
      <div style="color:#555; font-size:13px; line-height:1.8;">描述内容</div>
    </td>
  </tr>
</table>
```

不用红绿色编码，用灰度底色区分即可。

### 13. 步骤条

```html
<div style="margin:20px 0;">
  <div style="display:flex; align-items:flex-start; margin-bottom:14px;">
    <div style="flex-shrink:0; width:28px; height:28px; background:#4a7c6f; color:#fff; border-radius:50%; text-align:center; line-height:28px; font-size:13px; font-weight:700; margin-right:12px;">1</div>
    <div style="flex:1; padding-top:3px;">
      <div style="font-weight:700; font-size:14px; color:#1a1a1a; margin-bottom:2px;">步骤标题</div>
      <div style="font-size:13px; color:#555; line-height:1.8;">步骤说明</div>
    </div>
  </div>
  <!-- 重复 -->
</div>
```

注意：公众号对 flex 支持不完美。如果需要更保险的方案，用 table 替代：

```html
<table style="width:100%; border-collapse:collapse; margin:20px 0;">
  <tr>
    <td style="width:40px; padding:8px 12px 8px 0; vertical-align:top; text-align:center;">
      <div style="width:28px; height:28px; background:#4a7c6f; color:#fff; border-radius:50%; text-align:center; line-height:28px; font-size:13px; font-weight:700;">1</div>
    </td>
    <td style="padding:8px 0; vertical-align:top;">
      <div style="font-weight:700; font-size:14px; color:#1a1a1a; margin-bottom:2px;">步骤标题</div>
      <div style="font-size:13px; color:#555; line-height:1.8;">步骤说明</div>
    </td>
  </tr>
</table>
```

### 14. 信息卡片网格（2×2）

```html
<table style="width:100%; border-collapse:collapse; margin:20px 0; font-size:14px;">
  <tr>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#faf9f7;">
      <div style="font-weight:700; margin-bottom:4px; color:#1a1a1a;">标题一</div>
      <div style="color:#555; font-size:13px; line-height:1.7;">说明</div>
    </td>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#faf9f7;">
      <div style="font-weight:700; margin-bottom:4px; color:#1a1a1a;">标题二</div>
      <div style="color:#555; font-size:13px; line-height:1.7;">说明</div>
    </td>
  </tr>
  <tr>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#faf9f7;">
      <div style="font-weight:700; margin-bottom:4px; color:#1a1a1a;">标题三</div>
      <div style="color:#555; font-size:13px; line-height:1.7;">说明</div>
    </td>
    <td style="width:50%; padding:16px; border:1px solid #e8e8e8; vertical-align:top; background:#faf9f7;">
      <div style="font-weight:700; margin-bottom:4px; color:#1a1a1a;">标题四</div>
      <div style="color:#555; font-size:13px; line-height:1.7;">说明</div>
    </td>
  </tr>
</table>
```

不加 emoji 装饰。

### 15. 灰色提示块

```html
<div style="padding:14px 18px; background:#faf9f7; border-radius:6px; margin:18px 0; font-size:13px; color:#555; line-height:1.8;">
  补充说明内容。
</div>
```

### 16. 暖色提示块（注意事项）

```html
<div style="padding:14px 18px; background:#fdf8f3; border-left:3px solid #d4a574; border-radius:0 6px 6px 0; margin:18px 0; font-size:13px; color:#555; line-height:1.8;">
  <strong style="color:#1a1a1a;">注意：</strong>提示内容。
</div>
```

### 17. 简洁表格

```html
<table style="width:100%; border-collapse:collapse; margin:18px 0; font-size:14px;">
  <thead>
    <tr>
      <th style="text-align:left; padding:10px 14px; background:#faf9f7; color:#1a1a1a; font-weight:600; border-bottom:2px solid #e8e8e8;">列标题</th>
      <th style="text-align:left; padding:10px 14px; background:#faf9f7; color:#1a1a1a; font-weight:600; border-bottom:2px solid #e8e8e8;">列标题</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding:10px 14px; border-bottom:1px solid #e8e8e8; color:#2c2c2c;">内容</td>
      <td style="padding:10px 14px; border-bottom:1px solid #e8e8e8; color:#2c2c2c;">内容</td>
    </tr>
  </tbody>
</table>
```

表头用浅灰底 + 底部加粗线，表体只用底部细线，不用全边框。

### 18. 图片

```html
<div style="text-align:center; margin:22px 0;">
  <img src="图片路径" alt="描述" style="max-width:100%; height:auto; border-radius:6px; border:1px solid #e8e8e8;">
  <p style="font-size:12px; color:#888; margin-top:8px;">图片说明</p>
</div>
```

### 19. 双图并排

```html
<table style="width:100%; border-collapse:collapse; margin:22px 0;">
  <tr>
    <td style="width:50%; padding:0 6px 0 0; vertical-align:top;">
      <img src="图片1路径" alt="描述" style="max-width:100%; height:auto; border-radius:6px; border:1px solid #e8e8e8;">
      <p style="font-size:12px; color:#888; margin-top:6px; text-align:center;">图注</p>
    </td>
    <td style="width:50%; padding:0 0 0 6px; vertical-align:top;">
      <img src="图片2路径" alt="描述" style="max-width:100%; height:auto; border-radius:6px; border:1px solid #e8e8e8;">
      <p style="font-size:12px; color:#888; margin-top:6px; text-align:center;">图注</p>
    </td>
  </tr>
</table>
```

### 20. 结语区

```html
<hr style="border:none; border-top:1px solid #e8e8e8; margin:36px 0;">
<div style="padding:16px 0 24px;">
  <p style="font-size:14px; color:#555; line-height:2; margin-bottom:20px;">结语正文。</p>
  <div style="text-align:center; padding:18px 24px; border:1px solid #e8e8e8; border-radius:6px; margin:0 auto; max-width:520px;">
    <p style="font-size:15px; font-weight:600; color:#1a1a1a; margin:0; line-height:1.8;">收尾金句</p>
  </div>
</div>
```

### 21. 尾部信息

```html
<div style="margin-top:32px; padding-top:20px; border-top:1px solid #e8e8e8; font-size:13px; color:#888; line-height:2;">
  <p style="margin:0;">作者 / 公众号名</p>
  <p style="margin:0;">项目地址：<a href="链接" style="color:#4a7c6f; text-decoration:none;">链接文字</a></p>
  <p style="margin:0;">往期：<a href="链接" style="color:#4a7c6f; text-decoration:none;">文章标题</a></p>
</div>
```

---

## 模板

```html
<!-- 公众号文章 — 纯内联样式 -->
<div style="max-width:680px; margin:0 auto; font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Hiragino Sans GB','Microsoft YaHei',sans-serif; color:#2c2c2c; line-height:1.9; font-size:15px; padding:0 16px;">

  <!-- 标题区 -->
  <div style="padding:36px 0 20px;">
    <h1 style="font-size:24px; font-weight:700; color:#1a1a1a; margin:0 0 10px; line-height:1.5;">文章主标题</h1>
    <p style="color:#888; font-size:14px; margin:0;">一句话引导语</p>
  </div>

  <!-- 开篇引言 -->
  <blockquote style="border-left:3px solid #4a7c6f; padding:14px 18px; margin:16px 0 28px; background:#f4f8f6; color:#2c2c2c; font-size:14px; line-height:1.9; border-radius:0 6px 6px 0;">
    全文核心观点。
  </blockquote>

  <hr style="border:none; border-top:1px solid #e8e8e8; margin:32px 0;">

  <!-- 章节 -->
  <h2 style="font-size:18px; font-weight:700; color:#1a1a1a; margin:0 0 14px; line-height:1.5; padding-bottom:8px; border-bottom:1px solid #e8e8e8;">章节标题</h2>

  <p style="font-size:15px; color:#2c2c2c; line-height:2; margin-bottom:16px;">正文段落。<strong>加粗关键句</strong>。</p>

  <hr style="border:none; border-top:1px solid #e8e8e8; margin:32px 0;">

  <!-- 结语 -->
  <div style="padding:16px 0 24px;">
    <p style="font-size:14px; color:#555; line-height:2; margin-bottom:20px;">结语正文。</p>
    <div style="text-align:center; padding:18px 24px; border:1px solid #e8e8e8; border-radius:6px; margin:0 auto; max-width:520px;">
      <p style="font-size:15px; font-weight:600; color:#1a1a1a; margin:0; line-height:1.8;">收尾金句</p>
    </div>
  </div>

  <!-- 尾部信息 -->
  <div style="margin-top:32px; padding-top:20px; border-top:1px solid #e8e8e8; font-size:13px; color:#888; line-height:2;">
    <p style="margin:0;">维弈阁成长日记</p>
  </div>

</div>
```

---

## 风格禁忌（避免 AI 烂俗味）

1. **不加 emoji 装饰标题**（不要 🚀、💡、✨）
2. **不用 CHAPTER 01 编号**——直接用自然的中文标题
3. **不加英文副标题**——除非原文本身有
4. **不用彩虹配色**——只用灰度 + 一个点缀色
5. **金句卡片不加 ✦ 符号**——白底细框足够
6. **不写"让我们一起..."、"在这个快速发展的时代..."**——这是内容（辞）的 de-ai-ify 技能管的事
7. **引言块不加 font-style:italic**——中文斜体难看
8. **正文不过度加粗**——一段最多加粗一处
9. **不用渐变色**——公众号对 gradient 支持不稳定
