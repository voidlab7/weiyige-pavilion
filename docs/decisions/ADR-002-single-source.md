# ADR-002: .weiyige/ 为唯一真相源

### 状态
已采纳

### 日期
2026-05-14

### 背景

根目录和 `.weiyige/` 都有同名文件（SHARED.md、ROUTER.md、SOUL.md、IDENTITY.md），版本不一致。AI 面对矛盾指令，选择消耗最少 token 的路径——读到根级空壳 SOUL.md 后认为"角色无方法论"直接跳过。

### 决策

1. 删除根目录的重复文件（SOUL.md、IDENTITY.md、ROUTER.md、LOADER.md、SHARED.md）
2. `.weiyige/` 下的文件为唯一权威版本
3. CLAUDE.md 和 CODEBUDDY.md 作为入口文件保留在根目录，但引用 `.weiyige/` 的文件而非重复内容

### 替代方案

1. **symlink**：根目录文件 symlink 到 .weiyige/。放弃原因：Windows 兼容性差，git 处理 symlink 不一致。
2. **同步脚本**：每次修改自动同步两份。放弃原因：增加维护成本，仍可能不同步。

### 后果

- ✅ AI 没有"选择性理解"的空间——只有一个版本
- ✅ 维护成本降低——改一处就够
- ⚠️ 根目录看起来"少了文件"，新用户可能困惑（QUICKSTART.md 需说明）

### 相关

- `lessons/LLM遗忘bug.md`
