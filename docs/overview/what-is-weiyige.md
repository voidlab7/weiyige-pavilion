# 维弈阁是什么

> 一个人，一个 AI 团队。

## 一句话

维弈阁（Weiyige）是一个 **13 角色 AI Agent 协作框架**——把一个人 + AI 变成一支完整的产品团队。

## 核心理念

你一个人干活，但身后站着一群人：CEO 帮你拿方向，PM 帮你拆任务，架构师帮你审方案，QA 帮你找 bug，安全帮你堵漏洞，财务帮你算账，内容帮你写东西，设计帮你把关体验，合伙人专门挑刺，顾问帮你做研究，探索帮你盯热点——还有一个执事，自动把这些人串起来。

**不是 13 个孤立的 prompt，是一个有协议、有记忆、有门禁的团队系统。**

## 与普通 AI 助手的区别

| 维度 | 普通 AI 助手 | 维弈阁 |
|------|-------------|-------|
| 角色 | 通用助手，无分工 | 13 角色各司其职 |
| 协作 | 无 | RACI 矩阵 + 交接块 + 门禁 |
| 记忆 | 无状态 | 三层记忆（长期/中期/短期） |
| 质量 | 无保障 | Layer 0 确定性检查 + Layer 1 AI 审查 |
| 编排 | 手动 | 启·执事自动全链路编排 |
| 状态 | 不可观测 | CLI + Dashboard 实时同步 |

## 思想源流

```
gstack（Garry Tan）     → 种子：角色化 AI Agent，Markdown 定义人设
Harness Engineering     → 范式：大模型 = 发动机，Harness = 线束
Martin Fowler           → 理论：前馈（Guides）+ 反馈（Sensors）双层约束
Context Engineering     → 演进：从写 prompt → 构建上下文 → 搭建完整工作环境
```

维弈阁的定位：**Harness Engineering 的直接实践** —— 70 张 Skill 卡片 + 七条线束 + 教训→规则升级闭环。

## 七条线束

| 线束 | 含义 | 体现 |
|------|------|------|
| 角色线束 | Agent 有明确边界 | 13 角色各司其职，不越界 |
| 流程线束 | 必须沿预定义流程推进 | 构思→需求→设计→开发→测试→发布 |
| 交接线束 | 信息传递必须结构化 | 交接块 + CLI handoff |
| 审查线束 | 产出必须审查才能过 | 门禁系统（Layer 0 + Layer 1） |
| 记忆线束 | 经验必须持久化 | 三层记忆 + 教训→规则升级 |
| 自控线束 | 有自我风险评估 | WTF-likelihood、编辑累积风险 |
| 可观测线束 | 决策可追溯 | 决策日志、状态 Dashboard |

## 项目构成

维弈阁分为两个仓库：

| 仓库 | 定位 | 内容 |
|------|------|------|
| **weiyige-pavilion** | 协议与角色定义 | 13 角色、协议、技能、门禁、记忆系统 |
| **weiyige-ops** | 运维与工具 | CLI、Dashboard、调度器、健康检查 |

pavilion 是"团队的基因"，ops 是"团队的运维基础设施"。pavilion 通过 `sync-weiyige.sh` 同步到所有注册项目的 `.weiyige/` 目录。

## 开源信息

- 作者：[voidlab7](https://github.com/voidlab7)
- 协议：GPL-3.0
- GitHub：[weiyige-pavilion](https://github.com/voidlab7/weiyige-pavilion)
- 思想源头：[gstack](https://github.com/garrytan/gstack) by Garry Tan
