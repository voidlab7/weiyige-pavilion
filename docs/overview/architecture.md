# 整体架构

## 两仓库架构

```
weiyige-pavilion/（协议层）          weiyige-ops/（工具层）
├── 13 角色定义                      ├── weiyige-cli（状态管理）
├── 协议文件（PROTOCOL/ROUTER/...）   ├── Dashboard（Electron App）
├── 门禁（gates/）                   ├── health-checker（文件监控）
├── 技能（skills/）                  ├── 调度器（scheduler）
├── 规则（rules/）                   ├── sync-weiyige.sh
└── 安装脚本（install.sh）            └── 任务队列管理
        │                                    │
        │  sync-weiyige.sh                   │
        ├──────────────────────►  各项目/.weiyige/
        │                                    │
        └────────────── CLI 命令 ◄───────────┘
                     project-status.json
```

## 三层 Agent 架构

```
┌─────────────────────────────────────────────┐
│              用户（唯一决策者）                 │
└──────────────────┬──────────────────────────┘
                   │
          ┌────────▼────────┐
          │   启·执事（调度）  │  ← 编排器，不干活只调度
          └──┬─────┬─────┬──┘
             │     │     │
        ┌────▼──┐ ┌▼──────┐ ┌▼──────────┐
        │ 战略层 │ │ 执行层 │ │  质量层     │
        │锋+砺+隐│ │枢+辞+寻│ │矩+绘+铸+鉴+盾│
        └───────┘ └───────┘ └──────────-┘
                              │
                         ┌────▼────┐
                         │ 运营层   │
                         │   算    │
                         └────────┘
```

## 数据流

### 1. 协议加载流

```
用户输入 → ROUTER.md（路由到角色）
                │
                ▼
         LOADER.md（决定加载深度）
                │
          ┌─────┼─────┐
          L0    L1    L2
       (身份) (方法) (知识)
```

### 2. 状态管理流

```
AI Agent（角色执行）
    │ execute_command
    ▼
weiyige-cli（强制校验 + 状态写入）
    │ 自动同步
    ├─► state.json（任务级）
    ├─► project-status.json（项目级）
    ├─► progress-board.md（可读看板）
    └─► handoff-log.jsonl（交接日志）
         │ 轮询读取
         ▼
    health-checker → Dashboard（Electron App）
```

### 3. 质量保障流

```
角色产出
    │
    ▼
Layer 0（确定性检查）← weiyige-cli gate
    │ PASS
    ▼
Layer 1（AI 语义审查）← artifact-review Skill
    │ PASS
    ▼
weiyige-cli handoff → 下游角色
```

### 4. 同步分发流

```
weiyige-pavilion/（唯一编辑源）
    │ sync-weiyige.sh
    ▼
14 个注册项目的 .weiyige/
    ├── AIAgent/.weiyige/
    ├── audio_record_mac/.weiyige/
    ├── ima-browser/.weiyige/
    └── ... (保留各项目 memory/ 不覆盖)
```

## 平台适配

| 平台 | 入口文件 | 规则注入 |
|------|---------|---------|
| Claude Code | `CLAUDE.md` | 每次会话自动加载 |
| CodeBuddy | `CODEBUDDY.md` | 每次会话自动加载 |
| CodeBuddy rules | `.codebuddy/rules/weiyige-core/RULE.mdc` | `alwaysApply: true` |
| CodeBuddy agents | `.codebuddy/agents/*.md` | 触发时加载 |
| Cursor | `.cursorrules` | 自动加载 |
| Copilot | `.github/copilot-instructions.md` | 自动加载 |

## 关键设计决策

- **代码约束 > 文字约束**：CLI 强制校验，不靠 AI 自觉遵守 Markdown
- **单一真相源**：`.weiyige/` 下的文件是唯一权威版本
- **分级加载**：Quick 模式只加 L0（<500 token），Deep 模式才加 L1
- **确定性门禁**：文件存在性/lint 等由 CLI 检查，只有语义判断交给 AI
