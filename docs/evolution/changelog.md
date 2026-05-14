# 变更日志

> 维弈阁重大里程碑。

---

## 2026-05-14

- **知识库建设**：docs/ 体系化（10 个分类、30+ 个文档 → HTML 站）
- **LLM 遗忘防线**：CODEBUDDY.md + `.codebuddy/rules/` + 单一真相源
- **CLI 模块化拆分**：1629 行 → 入口 72 行 + 11 个 lib 模块

## 2026-05-14（早）

- **weiyige-cli v2**：闭环状态同步（handoff + gate + status + ops-sync）
- **skipped 阶段 bug 修复**：Dashboard 进度条正确显示 skipped
- **finish-task 阻塞修复**：running/ 自动清理

## 2026-05-13

- **分级加载协议**（LOADER.md）：L0/L1/L2 三级，Quick 模式节省 50-90% token
- **共享知识外置**（SHARED.md）：13 角色公共规则提取
- **IDENTITY.md 精简**：各角色核心指令 < 500 token

## 2026-05-05

- **weiyige-ops v2 设计**：全局调度 + hold 机制 + team 模式
- **执行模式决策规则**：小任务 inline / 中任务串行 / 大任务 team

## 2026-05-01

- **直连模式**（PROTOCOL v1.5）：单角色可不启动 task 直接工作

## 2026-04-16

- **铸·开发加入**：团队扩展为 13 角色
- **产物验证机制**：交接块增加产物文件字段

## 2026-04-15

- **AGENTS.md v1.0**：12 角色全员索引

## 2026-04-14

- **启·执事诞生**：自动编排器

## 2026-04-11

- **维弈阁创建**：基于 gstack 思想，12 角色初始版本
- **PROTOCOL v1.0**：协作协议、RACI、交接块、门禁
