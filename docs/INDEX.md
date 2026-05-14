# 维弈阁知识库

> 最后更新：2026-05-14 | 一个人 + AI = 一支团队

协议本身在 `.weiyige/`，这里是**解释、记录、沉淀**。

---

## 概览

- [维弈阁是什么](overview/what-is-weiyige.html) — 核心理念、定位、思想源流
- [整体架构](overview/architecture.html) — 两仓库关系、三层架构、数据流
- [术语表](overview/glossary.html) — 角色名、协议术语、CLI 命令速查
- [文件地图](overview/project-map.html) — 每个文件/目录的用途速查

## 角色手册

- [角色一览](agents/agent-catalog.html) — 13 角色职责、技能、快捷指令
- [设计原则](agents/agent-design-principles.html) — 为什么这样分角色、RACI 矩阵

## 协议解读

- [加载协议](protocols/loading-protocol.html) — L0/L1/L2 为什么分三级
- [交接机制](protocols/handoff-protocol.html) — 交接块、JSONL 日志、产物验证
- [门禁系统](protocols/gate-system.html) — Layer 0 确定性 + Layer 1 AI 语义
- [状态管理](protocols/state-management.html) — CLI 强制 vs 文档约束

## CLI 工具

- [命令手册](cli/cli-reference.html) — 所有命令 + 参数 + 示例
- [CLI 架构](cli/cli-architecture.html) — 模块拆分、依赖图
- [变更日志](cli/cli-changelog.html) — v1 → v2 变更记录

## 运维中心

- [ops 概览](ops/ops-overview.html) — weiyige-ops 定位
- [Dashboard](ops/dashboard.html) — Electron App 架构
- [调度器](ops/scheduler.html) — dispatch → spawn → hold → resume
- [部署同步](ops/deployment.html) — install.sh、sync-weiyige.sh

## 架构决策（ADR）

- [ADR 模板](decisions/ADR-template.html)
- [ADR-001: CLI 替代 Markdown 约束](decisions/ADR-001-cli-over-markdown.html)
- [ADR-002: 单一真相源](decisions/ADR-002-single-source.html)
- [ADR-003: 两层门禁](decisions/ADR-003-two-layer-gate.html)
- [ADR-004: CodeBuddy 双入口](decisions/ADR-004-codebuddy-entry.html)

## 经验教训

- [LLM 遗忘 bug](lessons/LLM遗忘bug.html) — LLM 偷懒的本质与三层防线
- [finish-task 阻塞](lessons/finish-task-blocking.html) — 过度防御导致人为阻塞
- [skipped 显示 bug](lessons/skipped-phase-display.html) — 进度条 bug
- [Dogfooding 教训](lessons/dogfooding-lesson.html) — 开发 weiyige 也要走流程

## 架构优化

- [优化总计划](architecture-optimization/index.html) — 11 个需求索引
- P0: [CLI state 写操作](architecture-optimization/P0-1-cli-state-write-guard.html) · [状态校验 hook](architecture-optimization/P0-2-state-validation-hook.html) · [finish-task 检查](architecture-optimization/P0-3-finish-task-enforce.html)
- P1: [IDENTITY 精简](architecture-optimization/P1-1-identity-slim.html) · [分级加载](architecture-optimization/P1-2-lazy-load-protocol.html) · [共享知识外置](architecture-optimization/P1-3-shared-knowledge-extract.html)
- P2: [自动 git commit](architecture-optimization/P2-1-auto-git-commit.html) · [状态变更历史](architecture-optimization/P2-2-state-change-history.html) · [快照与回退](architecture-optimization/P2-3-health-snapshot.html)
- P3: [CLI 环境自适应](architecture-optimization/P3-1-cli-env-adaptive.html) · [hook 平台分支](architecture-optimization/P3-2-hook-platform-branch.html)

## 演进历史

- [变更日志](evolution/changelog.html) — 重大里程碑
- [路线图](evolution/roadmap.html) — 未来方向
