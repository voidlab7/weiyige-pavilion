# 门禁 05: 测试阶段

> 审查方: 枢（协调）| 主导: 鉴 + 盾 | 退出条件: 测试报告通过

## 必查项（逐条勾选）

- [ ] **计算型检查已通过**（鉴 Skill-01 前置步骤）
- [ ] 7 维度健康评分已输出
- [ ] 无 Critical Bug
- [ ] 无 High Bug（或已修复）
- [ ] Medium Bug 已修复（Standard 模式）或已记录（Quick 模式）
- [ ] 回归测试已通过（修复不引入新 Bug）
- [ ] 盾的安全审计已完成（如需要）
- [ ] **鉴的测试报告文件已存在且可读** → `docs/reviews/YYYY-MM-DD_鉴_qa-report.md`（通过 `read_file` 验证）
- [ ] **盾的安全审计报告文件已存在且可读**（如需要）→ `docs/reviews/YYYY-MM-DD_盾_security-audit.md`
- [ ] PRD 中的验收标准（Given/When/Then）已逐条验证

## 退出裁定

- ✅ 全部勾选 → 进入发布
- ❌ 有未勾选项 → 修复后鉴重测
