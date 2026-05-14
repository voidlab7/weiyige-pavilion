# ops 概览

> weiyige-ops 是什么，和 pavilion 什么关系。

---

## 定位

| 仓库 | 定位 | 比喻 |
|------|------|------|
| **weiyige-pavilion** | 协议与角色定义 | 团队的"基因" |
| **weiyige-ops** | 运维工具与基础设施 | 团队的"神经系统" |

pavilion 定义"团队是什么"，ops 实现"团队怎么运转"。

## weiyige-ops 包含什么

```
weiyige-ops/
├── bin/cli/          ← weiyige-cli（状态管理 CLI）
├── app/              ← Dashboard（Electron App）
│   ├── core/         ← health-checker（文件监控）
│   ├── renderer/     ← 前端渲染（app.js + styles.css）
│   └── main.js       ← Electron 主进程
├── hooks/            ← 心跳脚本
├── schemas/          ← state.json JSON Schema
├── projects.yaml     ← 项目注册（ops 侧）
├── sync-weiyige.sh   ← pavilion → 各项目 .weiyige/ 同步脚本
├── board.sh          ← 全局状态看板
├── pick-task.sh      ← 任务选取
├── quick-task.py     ← 快速任务
└── budget.json       ← 预算配置
```

## 两仓库交互

```
pavilion/（角色定义）──sync-weiyige.sh──→ 各项目/.weiyige/
                                              │
                                         AI Agent 执行
                                              │
                                     weiyige-cli 命令
                                              │
                                    state.json + project-status.json
                                              │
                                    health-checker 轮询
                                              │
                                         Dashboard 渲染
```
