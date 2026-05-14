# Dashboard

> Electron App，实时展示所有项目的任务状态。

---

## 架构

```
main.js（Electron 主进程）
    │
    ├── preload.js → 暴露 API 到渲染进程
    │
    └── core/health-checker.js
            │ 轮询读取各项目
            │ ai-workspace/project-status.json
            │ ai-workspace/*/state.json
            ▼
        渲染进程（app.js + styles.css）
            │
            └── 项目卡片（名称/阶段/进度条/Agent/健康状态）
```

## 数据源

health-checker 扫描 `projects.yaml` 中注册的项目，对每个项目：

1. 读取 `ai-workspace/project-status.json`（CLI 自动同步）
2. 读取最新任务的 `state.json`
3. 计算 `phaseProgress`（completed + skipped / total）
4. 构建 `phasesDetail`（每个阶段的状态 + Agent）

## 状态映射

| state.json 中的状态 | Dashboard 显示 |
|---------------------|---------------|
| `pending` | 灰色圆点 |
| `in_progress` | 蓝色脉动圆点 |
| `completed` | 绿色圆点 |
| `skipped` | 绿色圆点（等同 completed） |

## 启动

```bash
cd weiyige-ops/app && npx electron . --dev
```

## 已修复的 Bug

- **skipped 阶段进度条显示**：skipped 未被算入 completed，导致进度条显示 `0/6` → 修复为 skipped 等同 completed
