# 维弈阁 Skill 注册表

> 版本: v1.0 | 创建: 2026-04-16
> 借鉴: GSLB DevOps 的 Skill 依赖声明 + dist/ 打包分发设计

---

## Skill 分类

维弈阁的 Skill 分为**内置 Skill** 和**外部 Skill** 两类：

| 类型 | 定义位置 | 特点 |
|------|---------|------|
| **内置 Skill** | 角色的 `SOUL.md` + `SKILLS.md` 中定义 | 角色自带，无需额外安装 |
| **外部 Skill** | CodeBuddy `~/.codebuddy/skills/` 或项目 `.codebuddy/skills/` | 需要单独安装/加载 |

---

## 内置 Skill 清单（58 张卡片）

| 角色 | Skill | 定义文件 |
|------|-------|---------|
| 锋 · CEO | 战略审查 · 范围决策 · 不可逆决策审批 · 长期轨迹评估 · 优先级裁决 | `CEO_锋/SKILLS.md` |
| 砺 · 合伙人 | YC办公时间 · 魔鬼代言人 · 前提挑战 · 替代方案生成 | `合伙人_砺/SKILLS.md` |
| 枢 · PM | 需求消歧义 · PRD撰写 · 优先级排序 · 进度管理 · 产品三角审查 | `PM_枢/SKILLS.md` |
| 矩 · 架构 | 工程审查 · 架构决策 · 性能基线 · 技术债评估 · 驾驭性评估 | `架构_矩/SKILLS.md` |
| 绘 · 设计 | 设计系统构建 · 设计计划评审 · 设计审计修复 · AI烂俗检测 · 竞品设计综合 | `设计_绘/SKILLS.md` |
| 鉴 · QA | 浏览器功能测试 · Bug修复 · 金丝雀监控 · 回归测试 · 7维度健康评分 | `QA_鉴/SKILLS.md` |
| 盾 · 安全 | 安全审计 · 威胁建模 · 秘密考古 · 依赖供应链审计 · AI安全专项 | `安全_盾/SKILLS.md` |
| 辞 · 内容 | 内容创作 · De-AI-ify · Humanizer · 选题策划 · 爆款复盘 · 平台适配 | `内容_辞/SKILLS.md` |
| 算 · 财务 | 成本估算 · ROI分析 · 预算管理 · 模型选型优化 · 月度财务报告 | `财务_算/SKILLS.md` |
| 寻 · 探索 | 热点雷达 · 趋势研判 · 竞品监控 · AI前沿追踪 · 学术文献分析 · 选题弹药供给 · 信号交叉验证 · 关联信号发现 | `探索_寻/SKILLS.md` |
| 隐 · 顾问 | 芒格多元思维 · 逆向思考 · 能力圈评估 · 历史案例映射 · 复利分析 | `顾问_隐/SKILLS.md` |

---

## 外部 Skill 依赖（可选）

以下 CodeBuddy 外部 Skill 可增强维弈阁的能力，但**不是必需的**：

| Skill | 增强的角色 | 作用 | 安装方式 |
|-------|-----------|------|---------|
| `webapp-testing` | 鉴 · QA | Playwright 浏览器自动化测试 | CodeBuddy 内置 |
| `pdf` / `docx` / `xlsx` / `pptx` | 枢 · PM / 辞 · 内容 | 文档生成和处理 | CodeBuddy 内置 |
| `canvas-design` | 绘 · 设计 | 视觉设计稿生成 | CodeBuddy 内置 |
| `xiaohongshu-automation` | 寻 · 探索 / 辞 · 内容 | 小红书热词搜索和内容发布 | `~/.codebuddy/skills/` |
| `autoglm-websearch` | 寻 · 探索 | AutoGLM 网络搜索 | Skill Marketplace |
| `autoglm-deepresearch` | 隐 · 顾问 | AutoGLM 深度研究 | Skill Marketplace |
| `aminer-data-search` | 寻 · 探索 | 学术论文和学者搜索 | Skill Marketplace |

---

## MCP 工具依赖（可选）

| MCP Server | 增强的角色 | 作用 |
|------------|-----------|------|
| `gongfeng` | 矩 · 架构 | 工蜂代码审查、MR 管理 |
| `devops-stream-pipeline` | 枢 · PM | 蓝盾流水线触发 |
| `km` | 隐 · 顾问 | KM 知识库检索 |
| `tapd` | 枢 · PM | TAPD 需求管理 |

---

## 与 DevOps Skill 生态的区别

| 维度 | DevOps | 维弈阁 |
|------|--------|--------|
| Skill 定位 | 外部依赖，必须安装 | 内置为主，外部增强 |
| 调用方式 | `use_skill("artifact-review")` 强制调用 | SOUL.md 中描述流程，Agent 自行执行 |
| 打包分发 | `dist/*.zip` 打包 | GitHub clone/curl 安装 |
| 强制性 | G12 规则：跳过 = 违规 | 建议遵循，Quick 模式可简化 |

维弈阁的设计哲学：**Skill 内置到角色定义中，减少外部依赖，降低安装门槛**。外部 Skill 是增强而非必需。
