# P2-1: finish-task 自动 git commit

> 来源：[weiyige-architecture-analysis.md](../../设计方案/weiyige-architecture-analysis.md)
> 优先级：85
> 难度：低 | 预估：30min
> 依赖：P0-3
> 状态：待执行

---

## 问题

阶段完成后无自动快照，出问题难以回滚，也无法追溯每个阶段的产出。

## 目标

finish-task 自动产生 git commit，为每个阶段留下可追溯的快照。

## 方案

1. finish-task 末尾自动执行 `git add ai-workspace/ && git commit -m "[weiyige] {task-id} - {phase} completed"`
2. 仅 add `ai-workspace/`，不动其他文件
3. 如果工作区有非 ai-workspace 的未暂存修改，不影响
4. 可选 `--no-commit` 参数跳过自动提交

## 验收标准

- [ ] finish-task 后 git log 可见自动 commit
- [ ] commit 仅包含 ai-workspace/ 内文件
- [ ] `--no-commit` 参数生效
- [ ] commit message 格式符合规范

## 关联文件

- `weiyige-ops/bin/weiyige-cli.mjs`
- `weiyige-ops/finish-task.sh`
- `ai-workspace/queue/P2-1-auto-git-commit.yaml`
