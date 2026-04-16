# 项目配置规范（project.yaml）

> 版本: v1.0 | 创建: 2026-04-16

维弈阁安装到项目后，在 `.weiyige/project.yaml` 中存储项目级配置。本文档定义每个字段的含义、类型和约束。

---

## 配置文件位置

`<项目根目录>/.weiyige/project.yaml`

---

## 项目基本信息

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `name` | string | ✅ | — | 项目名称 |
| `description` | string | ❌ | `""` | 一句话描述 |
| `version` | string | ❌ | `"0.1.0"` | 项目版本号（语义化版本） |
| `weiyige_version` | string | ✅ | 安装时自动写入 | 维弈阁版本号（如 `"1.6"`） |

---

## 团队配置

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `team.mode` | string | ❌ | `"rule"` | 运行模式：`rule`（规则模式）/ `multi-agent`（多 Agent 模式）/ `hybrid`（共存） |
| `team.orchestrator` | string | ❌ | `"manual"` | 编排方式：`manual`（用户手动 @）/ `auto`（墨自动编排） |
| `team.default_model` | string | ❌ | `""` | 默认模型（留空则用各角色自带配置） |

---

## 产物配置

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `artifacts.reviews_dir` | string | ❌ | `"docs/reviews"` | 审查报告输出目录 |
| `artifacts.designs_dir` | string | ❌ | `"docs/designs"` | 设计文档输出目录 |
| `artifacts.status_file` | string | ❌ | `"STATUS.md"` | 项目状态追踪文件 |

**产物目录结构**（按约定生成）：

```
{artifacts.reviews_dir}/
├── YYYY-MM-DD_锋_ceo-review.md
├── YYYY-MM-DD_矩_eng-review.md
├── YYYY-MM-DD_绘_design-review.md
├── YYYY-MM-DD_鉴_qa-report.md
└── YYYY-MM-DD_盾_security-audit.md

{artifacts.designs_dir}/
├── PRD-[产品名].md
└── DESIGN-[产品名].md
```

---

## Git 配置

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `git.auto_commit` | bool | ❌ | `false` | 审查通过后是否自动 git commit |
| `git.commit_prefix` | string | ❌ | `""` | commit message 前缀（如 `"[weiyige]"`） |
| `git.protected_branches` | list | ❌ | `["main", "master"]` | 受保护分支（不自动 push） |

---

## 门禁配置

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `gates.enabled` | bool | ❌ | `true` | 是否启用阶段门禁 |
| `gates.strict_mode` | bool | ❌ | `false` | 严格模式：门禁未全部通过时阻止流转（vs 警告但允许继续） |
| `gates.review_scoring` | bool | ❌ | `true` | 是否启用产物评分（见 `rules/review-scoring.md`） |

---

## 记忆配置

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `memory.auto_writeback` | bool | ❌ | `true` | 完成实质性工作后是否自动回写 memory |
| `memory.lesson_to_rule_threshold` | int | ❌ | `2` | 同类教训出现 N 次后自动升级为规则 |

---

## 示例配置

```yaml
# .weiyige/project.yaml
name: "毛孩子人格测试"
description: "通用版宠物 SBTI 测试网页"
version: "1.0.0"
weiyige_version: "1.6"

team:
  mode: "hybrid"
  orchestrator: "auto"
  default_model: ""

artifacts:
  reviews_dir: "docs/reviews"
  designs_dir: "docs/designs"
  status_file: "STATUS.md"

git:
  auto_commit: false
  commit_prefix: ""
  protected_branches:
    - main
    - master

gates:
  enabled: true
  strict_mode: false
  review_scoring: true

memory:
  auto_writeback: true
  lesson_to_rule_threshold: 2
```

---

## 读取规范

1. 所有 Agent 启动时**必须读取** `project.yaml`（如存在）
2. 字段缺失时使用默认值，不报错
3. 文件不存在时按全默认值运行
4. 修改配置后立即生效（无需重启）
