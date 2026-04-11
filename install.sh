#!/usr/bin/env bash
# =============================================================================
# 维弈阁（Weiyige Pavilion）一键安装脚本
# 将 AI 团队安装到你的项目中
#
# 用法：
#   ./install.sh                        # 安装到当前目录
#   ./install.sh --target /path/to/proj # 安装到指定项目目录
#   ./install.sh --mode claude          # 仅安装 CLAUDE.md（最轻量）
#   ./install.sh --mode full            # 完整安装（默认）
#   ./install.sh --help                 # 查看帮助
# =============================================================================

set -e

# ---------- 颜色 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ---------- 脚本所在目录（即维弈阁工程根目录）----------
PAVILION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------- 默认参数 ----------
TARGET_DIR="$(pwd)"
INSTALL_MODE="full"

# ---------- 帮助信息 ----------
show_help() {
  echo ""
  echo -e "${BOLD}维弈阁（Weiyige Pavilion）一键安装${NC}"
  echo ""
  echo "用法："
  echo "  ./install.sh [选项]"
  echo ""
  echo "选项："
  echo "  --target <目录>    安装到指定项目目录（默认：当前目录）"
  echo "  --mode <模式>      安装模式（默认：full）"
  echo "                       claude  — 仅安装 CLAUDE.md，最轻量"
  echo "                       full    — 完整安装所有 Agent 定义文件"
  echo "  --help             显示此帮助"
  echo ""
  echo "示例："
  echo "  ./install.sh                              # 安装到当前目录"
  echo "  ./install.sh --target ~/my-project        # 安装到指定项目"
  echo "  ./install.sh --mode claude                # 仅安装 CLAUDE.md"
  echo ""
}

# ---------- 解析参数 ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET_DIR="$2"
      shift 2
      ;;
    --mode)
      INSTALL_MODE="$2"
      shift 2
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}未知参数: $1${NC}"
      show_help
      exit 1
      ;;
  esac
done

# ---------- 校验目标目录 ----------
if [ ! -d "$TARGET_DIR" ]; then
  echo -e "${RED}错误：目标目录不存在：$TARGET_DIR${NC}"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# ---------- 打印 Banner ----------
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║     维弈阁 AI 团队  一键安装              ║${NC}"
echo -e "${CYAN}${BOLD}║     Weiyige Pavilion — Install            ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BLUE}安装来源：${NC} $PAVILION_DIR"
echo -e "  ${BLUE}安装目标：${NC} $TARGET_DIR"
echo -e "  ${BLUE}安装模式：${NC} $INSTALL_MODE"
echo ""

# ---------- 模式：claude（仅 CLAUDE.md）----------
install_claude_mode() {
  echo -e "${YELLOW}▶ 安装 CLAUDE.md ...${NC}"

  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    echo -e "  ${YELLOW}⚠️  目标目录已存在 CLAUDE.md，备份为 CLAUDE.md.bak${NC}"
    cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.bak"
  fi

  cp "$PAVILION_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  echo -e "  ${GREEN}✅ CLAUDE.md 已安装${NC}"
  echo ""
  echo -e "${GREEN}${BOLD}安装完成！${NC}"
  echo ""
  echo -e "  在 Codebuddy / Claude Code 中打开 ${BOLD}$TARGET_DIR${NC}"
  echo -e "  AI 会自动读取 CLAUDE.md，激活维弈阁团队。"
  echo ""
  echo -e "  快速开始："
  echo -e "  ${CYAN}@辞 帮我写一篇公众号文章${NC}"
  echo -e "  ${CYAN}@锋 审查一下这个产品方向${NC}"
  echo -e "  ${CYAN}@矩 帮我做工程审查${NC}"
  echo ""
}

# ---------- 模式：full（完整安装）----------
install_full_mode() {
  WEIYIGE_DIR="$TARGET_DIR/.weiyige"

  echo -e "${YELLOW}▶ 创建 .weiyige 目录 ...${NC}"
  mkdir -p "$WEIYIGE_DIR"
  echo -e "  ${GREEN}✅ $WEIYIGE_DIR${NC}"

  # 复制所有 Agent 目录
  AGENTS=(
    "CEO_锋"
    "PM_枢"
    "架构_矩"
    "设计_绘"
    "QA_鉴"
    "安全_盾"
    "财务_算"
    "内容_辞"
    "顾问_隐"
    "合伙人_砺"
  )

  echo ""
  echo -e "${YELLOW}▶ 安装 Agent 定义文件 ...${NC}"
  for agent in "${AGENTS[@]}"; do
    if [ -d "$PAVILION_DIR/$agent" ]; then
      cp -r "$PAVILION_DIR/$agent" "$WEIYIGE_DIR/"
      echo -e "  ${GREEN}✅ $agent${NC}"
    else
      echo -e "  ${YELLOW}⚠️  跳过（目录不存在）：$agent${NC}"
    fi
  done

  # 复制协议文件
  echo ""
  echo -e "${YELLOW}▶ 安装协议文件 ...${NC}"
  PROTOCOL_FILES=("PROTOCOL.md" "ROUTER.md" "MEMORY.md" "QUICKSTART.md")
  for f in "${PROTOCOL_FILES[@]}"; do
    if [ -f "$PAVILION_DIR/$f" ]; then
      cp "$PAVILION_DIR/$f" "$WEIYIGE_DIR/$f"
      echo -e "  ${GREEN}✅ $f${NC}"
    fi
  done

  # 安装 CLAUDE.md（指向 .weiyige 目录）
  echo ""
  echo -e "${YELLOW}▶ 安装 CLAUDE.md ...${NC}"
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    echo -e "  ${YELLOW}⚠️  目标目录已存在 CLAUDE.md，备份为 CLAUDE.md.bak${NC}"
    cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.bak"
  fi

  # 生成指向 .weiyige 的 CLAUDE.md
  cat > "$TARGET_DIR/CLAUDE.md" << 'CLAUDE_EOF'
# 维弈阁 AI 团队（Weiyige Pavilion）

> 你正在与一个 10 人 AI 团队协作。Agent 定义文件在 `.weiyige/` 目录下。

## 团队成员速查

| 快捷指令 | Agent | 职责 |
|---------|-------|------|
| `@锋` / `@ceo` | CEO_锋 | 战略方向、计划审查 |
| `@枢` / `@pm` | PM_枢 | 需求拆解、PRD |
| `@矩` / `@arch` | 架构_矩 | 技术架构、代码审查 |
| `@绘` / `@design` | 设计_绘 | UI/UX 设计 |
| `@鉴` / `@qa` | QA_鉴 | 测试、Bug 发现 |
| `@盾` / `@sec` | 安全_盾 | 安全审计 |
| `@算` / `@cfo` | 财务_算 | 成本分析、ROI |
| `@辞` / `@content` | 内容_辞 | 文案创作、去 AI 味 |
| `@隐` / `@advisor` | 顾问_隐 | 多角度深度分析 |
| `@砺` / `@devil` | 合伙人_砺 | 质疑挑战、风险识别 |

## Agent 激活规则

当用户使用快捷指令激活某个 Agent 时，你必须：
1. 读取 `.weiyige/[Agent名]/SOUL.md` — 加载思维框架
2. 读取 `.weiyige/[Agent名]/IDENTITY.md` — 加载人格风格
3. 读取 `.weiyige/[Agent名]/memory/` — 加载历史记忆
4. 以该 Agent 的身份和风格回应

技能文件：
- 内容_辞写文章 → 读取 `.weiyige/内容_辞/skills/de-ai-ify.md` + `.weiyige/内容_辞/skills/humanizer.md`
- 架构_矩工程审查 → 读取 `.weiyige/架构_矩/rules/eng-review/RULE.mdc`
- PM_枢写 PRD → 读取 `.weiyige/PM_枢/skills/prd-template.md`

## 三档模式

- `@quick @[Agent]` — 快速模式，< 5 分钟
- `@[Agent]` — 标准模式（默认）
- `@deep @[Agent]` — 深度模式，30 分钟+

协作协议：`.weiyige/PROTOCOL.md` | 路由规则：`.weiyige/ROUTER.md`
CLAUDE_EOF

  echo -e "  ${GREEN}✅ CLAUDE.md 已安装（指向 .weiyige/）${NC}"

  # 添加 .gitignore 条目（可选）
  echo ""
  echo -e "${YELLOW}▶ 检查 .gitignore ...${NC}"
  if [ -f "$TARGET_DIR/.gitignore" ]; then
    if ! grep -q "\.weiyige/\*/memory/" "$TARGET_DIR/.gitignore" 2>/dev/null; then
      echo "" >> "$TARGET_DIR/.gitignore"
      echo "# 维弈阁 Agent 记忆文件（个人化，不建议提交）" >> "$TARGET_DIR/.gitignore"
      echo ".weiyige/*/memory/knowledge.md" >> "$TARGET_DIR/.gitignore"
      echo ".weiyige/*/memory/lessons.md" >> "$TARGET_DIR/.gitignore"
      echo ".weiyige/*/memory/preferences.md" >> "$TARGET_DIR/.gitignore"
      echo -e "  ${GREEN}✅ 已添加 .gitignore 条目（排除 Agent 记忆文件）${NC}"
    else
      echo -e "  ${BLUE}ℹ️  .gitignore 已包含相关条目，跳过${NC}"
    fi
  else
    echo -e "  ${BLUE}ℹ️  未找到 .gitignore，跳过${NC}"
  fi

  echo ""
  echo -e "${GREEN}${BOLD}✅ 安装完成！${NC}"
  echo ""
  echo -e "  安装位置：${BOLD}$TARGET_DIR/.weiyige/${NC}"
  echo -e "  入口文件：${BOLD}$TARGET_DIR/CLAUDE.md${NC}"
  echo ""
  echo -e "  在 Codebuddy / Claude Code 中打开 ${BOLD}$TARGET_DIR${NC}"
  echo -e "  AI 会自动读取 CLAUDE.md，激活维弈阁团队。"
  echo ""
  echo -e "  快速开始："
  echo -e "  ${CYAN}@辞 帮我写一篇公众号文章${NC}"
  echo -e "  ${CYAN}@锋 审查一下这个产品方向${NC}"
  echo -e "  ${CYAN}@矩 帮我做工程审查${NC}"
  echo ""
}

# ---------- 执行安装 ----------
case "$INSTALL_MODE" in
  claude)
    install_claude_mode
    ;;
  full)
    install_full_mode
    ;;
  *)
    echo -e "${RED}未知安装模式：$INSTALL_MODE（支持：claude / full）${NC}"
    exit 1
    ;;
esac
