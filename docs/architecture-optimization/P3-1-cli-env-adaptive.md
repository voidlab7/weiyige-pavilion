# P3-1: CLI 环境自适应

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：75
> 难度：低 | 预估：30min
> 依赖：无
> 状态：待执行

---

## 问题

CLI 路径假设单一，换平台（CodeBuddy → Claude Code → OpenClaw）可能找不到项目目录。

## 目标

CLI 启动时自动检测运行环境，适配不同平台的项目路径。

## 方案

1. `weiyige-cli.mjs` 启动时检测环境变量：
   - `$CODEBUDDY_PROJECT_DIR`
   - `$CLAUDE_PROJECT_DIR`
   - `$OPENCLAW_PROJECT_DIR`
2. 根据检测结果自动设置 projectRoot 绝对路径
3. 如果都不存在，fallback 到 `process.cwd()`
4. 在 `--verbose` 模式下输出检测到的环境信息
5. 补充 README 说明各环境的配置方式

## 验收标准

- [ ] CodeBuddy 环境正确识别项目路径
- [ ] Claude Code 环境正确识别项目路径
- [ ] fallback 逻辑正常工作
- [ ] `--verbose` 输出环境检测信息

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`
- `ai-workspace/queue/P3-1-cli-env-adaptive.yaml`
