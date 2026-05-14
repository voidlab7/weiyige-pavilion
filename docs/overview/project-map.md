# 文件地图

> 每个文件/目录是干什么的，快速定位。

---

## 入口文件（根目录）

| 文件 | 用途 | 谁读 |
|------|------|------|
| `CLAUDE.md` | Claude Code 路由中枢（228 行） | Claude Code 自动加载 |
| `CODEBUDDY.md` | CodeBuddy 路由中枢（68 行铁律） | CodeBuddy 自动加载 |
| `AGENTS.md` | 团队花名册（人看的索引） | 人 / CodeBuddy fallback |
| `PROTOCOL.md` | 协作协议（21KB，完整版） | AI 按需读取 |
| `README.md` | GitHub 首页展示 | 人 |
| `QUICKSTART.md` | 5 分钟快速入门 | 人 / AI |
| `MEMORY.md` | 记忆系统规范 | AI |
| `TODO.md` | 全局待办事项 | 人 / AI |

## .weiyige/（核心配置，唯一真相源）

| 文件 | 用途 |
|------|------|
| `SHARED.md` | 跨角色共享知识（CLI 规范、Git 规范、自检清单） |
| `ROUTER.md` | 完整路由规则（意图分类、决策树、模式选择） |
| `LOADER.md` | 分级加载协议（L0/L1/L2） |
| `PROTOCOL.md` | 协作协议镜像 |
| `MEMORY.md` | 记忆规范镜像 |
| `registry.json` | 项目注册中心（14 个项目路径） |
| `todos.json` | 当前项目 TODO 数据 |

## .weiyige/ 下的子目录

| 目录 | 用途 |
|------|------|
| `CEO_锋/` ~ `执事_启/` | 13 个角色配置（IDENTITY.md + SOUL.md + SKILLS.md + memory/） |
| `gates/` | 6 个阶段门禁（gate-01 ~ gate-06）+ 两层门禁说明 |
| `rules/` | 全局规则（rules-global.md）+ 审查评分（review-scoring.md） |
| `skills/` | 4 个共享技能（artifact-review / knowledge-distillation / micropen / weekly-synthesis） |

## 角色目录（根级，13 个）

每个角色目录的标准结构：

```
{角色}/
├── IDENTITY.md    ← 身份卡片（< 500 token，L0 自动加载）
├── SOUL.md        ← 方法论（L1 按需加载）
├── SKILLS.md      ← 技能卡片清单
├── memory/        ← 运行时记忆（各项目独立，不同步）
├── skills/        ← 专属技能文件（部分角色）
└── rules/         ← 可执行规则（部分角色）
```

特殊角色文件：

| 角色 | 额外文件 |
|------|---------|
| 执事_启 | `start.md`（启动协议）、`exception-matrix.md`（异常预案）、`state-template.json` |
| PM_枢 | `skills/prd-template.md` |
| 内容_辞 | `skills/de-ai-ify.md`、`skills/humanizer.md`、`skills/copywriting.md` |

## .codebuddy/（CodeBuddy 平台专用）

| 路径 | 用途 |
|------|------|
| `agents/*.md` | 14 个 Agent 定义（触发时加载） |
| `rules/weiyige-core/RULE.mdc` | 铁律规则（`alwaysApply: true`，每次会话注入） |
| `skills/` | 4 个技能定义 |

## gates/（门禁系统）

| 文件 | 阶段 |
|------|------|
| `gate-01-ideation.md` | 构思阶段退出检查 |
| `gate-02-requirement.md` | 需求阶段退出检查 |
| `gate-03-design.md` | 设计阶段退出检查 |
| `gate-04-development.md` | 开发阶段退出检查 |
| `gate-05-testing.md` | 测试阶段退出检查 |
| `gate-06-release.md` | 发布阶段退出检查 |
| `two-layer-gate.md` | 两层门禁机制说明 |
| `review-reminder.md` | 审核入口强制指令 |

## ai-workspace/（运行时任务空间）

```
ai-workspace/
├── project-status.json    ← 项目级状态（ops dashboard 读取）
├── running/               ← 运行中任务 lock 文件
├── queue/                 ← 待执行任务 yaml
├── done/                  ← 已完成任务归档
├── blocked/               ← 阻塞任务
└── {task_id}/             ← 具体任务目录
    ├── state.json         ← 任务状态
    ├── progress-board.md  ← 进度看板
    ├── handoff-log.jsonl  ← 交接日志
    ├── history/           ← 状态变更历史
    └── artifacts/01~06/   ← 各阶段产物
```

## 其他目录

| 目录 | 用途 |
|------|------|
| `docs/` | 知识库（你正在看的） |
| `设计方案/` | 历史设计文档（ops v1/v2 设计） |
| `成长日记/` | 从 0 到 1 的进化记录 |
| `examples/` | 使用示例（新项目完整流程等） |
| `agents_for_codebuddy/` | CodeBuddy Agent 源文件 |
| `install.sh` / `install.ps1` | 一键安装脚本（macOS / Windows） |
| `_write_dashboard.py` | GitHub Pages 仪表盘生成器 |
