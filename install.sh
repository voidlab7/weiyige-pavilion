#!/usr/bin/env bash
# =============================================================================
# 维弈阁（Weiyige Pavilion）一键安装脚本
# 将 AI 团队安装到你的项目中
#
# 用法：
#   # 远程安装（推荐 — 无需 clone）
#   curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash -s -- --target ~/my-project
#
#   # 本地安装（已 clone 仓库）
#   ./install.sh
#   ./install.sh --target /path/to/proj
#   ./install.sh --tool cursor
#   ./install.sh --mode full
#   ./install.sh --help
# =============================================================================

set -e

# ---------- 颜色 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ---------- 远程源 ----------
REMOTE_RAW="https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main"

# ---------- 脚本所在目录（本地安装时使用）----------
PAVILION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

# ---------- 默认参数 ----------
TARGET_DIR="$(pwd)"
INSTALL_MODE="full"
INSTALL_TOOL=""  # 空=自动检测

# ---------- 工具 → 配置文件映射 ----------
# 各 AI 编码工具读取的项目级配置文件
TOOL_CLAUDE="CLAUDE.md"                           # CodeBuddy / Claude Code
TOOL_CURSOR=".cursorrules"                         # Cursor
TOOL_COPILOT=".github/copilot-instructions.md"     # GitHub Copilot
TOOL_WINDSURF=".windsurfrules"                     # Windsurf
TOOL_CLINE=".clinerules"                           # Cline

# ---------- 帮助信息 ----------
show_help() {
  echo ""
  echo -e "${BOLD}维弈阁（Weiyige Pavilion）一键安装${NC}"
  echo ""
  echo "用法："
  echo "  # 远程安装（推荐）"
  echo "  curl -fsSL https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.sh | bash"
  echo ""
  echo "  # 本地安装"
  echo "  ./install.sh [选项]"
  echo ""
  echo "选项："
  echo "  --target <目录>    安装到指定项目目录（默认：当前目录）"
  echo "  --mode <模式>      安装模式（默认：full）"
  echo "                       claude  — 仅安装配置文件，最轻量"
  echo "                       full    — 完整安装所有 Agent 定义文件"
  echo "  --tool <工具>      指定 AI 编码工具（默认：自动检测）"
  echo "                       codebuddy / claude  → CLAUDE.md"
  echo "                       cursor              → .cursorrules"
  echo "                       copilot             → .github/copilot-instructions.md"
  echo "                       windsurf            → .windsurfrules"
  echo "                       cline               → .clinerules"
  echo "  --help             显示此帮助"
  echo ""
  echo "示例："
  echo "  ./install.sh                              # 安装到当前目录（自动检测工具）"
  echo "  ./install.sh --target ~/my-project        # 安装到指定项目"
  echo "  ./install.sh --tool cursor                # 为 Cursor 安装"
  echo "  ./install.sh --mode claude                # 最轻量安装"
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
    --tool)
      INSTALL_TOOL="$2"
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

# ---------- 自动检测 AI 工具 ----------
detect_tool() {
  # 优先级：已有配置文件 > 项目特征
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    echo "codebuddy"
    return
  fi
  if [ -f "$TARGET_DIR/.cursorrules" ] || [ -d "$TARGET_DIR/.cursor" ]; then
    echo "cursor"
    return
  fi
  if [ -f "$TARGET_DIR/.windsurfrules" ] || [ -d "$TARGET_DIR/.windsurf" ]; then
    echo "windsurf"
    return
  fi
  if [ -f "$TARGET_DIR/.clinerules" ]; then
    echo "cline"
    return
  fi
  if [ -f "$TARGET_DIR/.github/copilot-instructions.md" ]; then
    echo "copilot"
    return
  fi
  # 默认：CodeBuddy / Claude Code（最通用的 CLAUDE.md 格式）
  echo "codebuddy"
}

if [ -z "$INSTALL_TOOL" ]; then
  INSTALL_TOOL=$(detect_tool)
fi

# ---------- 工具 → 配置文件名 ----------
get_config_file() {
  case "$1" in
    codebuddy|claude)  echo "CLAUDE.md" ;;
    cursor)            echo ".cursorrules" ;;
    copilot)           echo ".github/copilot-instructions.md" ;;
    windsurf)          echo ".windsurfrules" ;;
    cline)             echo ".clinerules" ;;
    *)                 echo "CLAUDE.md" ;;
  esac
}

CONFIG_FILE=$(get_config_file "$INSTALL_TOOL")

# ---------- 下载文件（远程 or 本地）----------
fetch_file() {
  local src_path="$1"
  local dest_path="$2"

  # 优先本地
  if [ -f "$PAVILION_DIR/$src_path" ]; then
    cp "$PAVILION_DIR/$src_path" "$dest_path"
    return 0
  fi

  # 回退远程
  if command -v curl &>/dev/null; then
    curl -fsSL "$REMOTE_RAW/$src_path" -o "$dest_path" 2>/dev/null
    return $?
  elif command -v wget &>/dev/null; then
    wget -q "$REMOTE_RAW/$src_path" -O "$dest_path" 2>/dev/null
    return $?
  else
    echo -e "${RED}需要 curl 或 wget 来下载文件${NC}"
    return 1
  fi
}

# ---------- 安装配置文件（不覆盖已有文件）----------
install_config_file() {
  local config_path="$TARGET_DIR/$CONFIG_FILE"
  local weiyige_config="$TARGET_DIR/CLAUDE-weiyige.md"

  # 先把维弈阁配置内容下载到临时位置
  local tmp_file
  tmp_file=$(mktemp)
  fetch_file "CLAUDE.md" "$tmp_file"

  if [ ! -s "$tmp_file" ]; then
    echo -e "${RED}❌ 配置文件下载失败${NC}"
    rm -f "$tmp_file"
    return 1
  fi

  # 检查用户是否已有配置文件
  if [ -f "$config_path" ] && [ -s "$config_path" ]; then
    # 用户已有配置 → 不覆盖，生成 CLAUDE-weiyige.md 独立文件 + 提示合并
    cp "$tmp_file" "$weiyige_config"
    rm -f "$tmp_file"

    echo -e "  ${YELLOW}⚠️  检测到已有 ${CONFIG_FILE}，不会覆盖${NC}"
    echo -e "  ${GREEN}✅ 已生成 ${CLAUDE-weiyige.md}${NC}"
    echo ""
    echo -e "  ${CYAN}━━━ 需要手动合并 ━━━${NC}"
    echo ""
    echo -e "  在 ${BOLD}${CONFIG_FILE}${NC} 末尾添加一行："
    echo ""
    echo -e "  ${GREEN}$(cat <<EOF

# 维弈阁 AI 团队
详细配置见 CLAUDE-weiyige.md
EOF
)${NC}"
    echo ""
    echo -e "  或者直接把 ${BOLD}CLAUDE-weiyige.md${NC} 的内容复制到 ${BOLD}${CONFIG_FILE}${NC} 中。"
    return 0
  fi

  # 用户没有配置文件 → 直接创建（但内容适配不同工具格式）
  mkdir -p "$(dirname "$config_path")"

  # CodeBuddy / Claude Code 直接用 CLAUDE.md 格式
  # 其他工具需要包裹在对应格式中
  case "$INSTALL_TOOL" in
    codebuddy|claude)
      cp "$tmp_file" "$config_path"
      ;;
    cursor|windsurf|cline|copilot)
      # 这些工具的配置文件是纯文本，直接放内容即可
      cp "$tmp_file" "$config_path"
      ;;
  esac

  rm -f "$tmp_file"
  echo -e "  ${GREEN}✅ ${CONFIG_FILE} 已创建（路由表内联，开箱即用）${NC}"
  return 0
}

# ---------- 打印 Banner ----------
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║     维弈阁 AI 团队  一键安装              ║${NC}"
echo -e "${CYAN}${BOLD}║     Weiyige Pavilion — Install            ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BLUE}安装目标：${NC} $TARGET_DIR"
echo -e "  ${BLUE}安装模式：${NC} $INSTALL_MODE"
echo -e "  ${BLUE}AI 工具： ${NC} $INSTALL_TOOL → ${CONFIG_FILE}"
echo -e "  ${BLUE}文件来源：${NC} $([ -f "$PAVILION_DIR/CLAUDE.md" ] && echo "本地" || echo "远程 GitHub")"
echo ""

# ---------- 模式：claude（仅配置文件）----------
install_claude_mode() {
  echo -e "${YELLOW}▶ 安装配置文件 ...${NC}"
  install_config_file

  echo ""
  echo -e "${YELLOW}⚠️  claude 模式不含 Agent 深度定义文件。${NC}"
  echo -e "  如需完整功能（Agent 人格、技能、记忆），请用 ${BOLD}--mode full${NC} 安装。"
  echo ""
  print_success
}

# ---------- 模式：full（完整安装）----------
install_full_mode() {
  WEIYIGE_DIR="$TARGET_DIR/.weiyige"

  echo -e "${YELLOW}▶ 创建 .weiyige 目录 ...${NC}"
  mkdir -p "$WEIYIGE_DIR"
  echo -e "  ${GREEN}✅ $WEIYIGE_DIR${NC}"

  # Agent 列表（Bash 3.x 兼容 — 用普通数组，不用关联数组）
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
    AGENT_DIR="$WEIYIGE_DIR/$agent"
    mkdir -p "$AGENT_DIR"

    # 先尝试本地复制整个目录
    if [ -d "$PAVILION_DIR/$agent" ]; then
      cp -r "$PAVILION_DIR/$agent/"* "$AGENT_DIR/" 2>/dev/null || true
      echo -e "  ${GREEN}✅ $agent${NC}"
    else
      # 远程：下载固定核心文件 + 按需下载技能/规则
      CORE_FILES="IDENTITY.md SOUL.md memory/knowledge.md memory/lessons.md memory/preferences.md"
      EXTRA_FILES=""
      case "$agent" in
        PM_枢)     EXTRA_FILES="rules/design-review/RULE.mdc skills/prd-template.md" ;;
        架构_矩)   EXTRA_FILES="rules/eng-review/RULE.mdc" ;;
        设计_绘)   EXTRA_FILES="rules/design-review/RULE.mdc" ;;
        QA_鉴)     EXTRA_FILES="rules/qa/RULE.mdc" ;;
        内容_辞)   EXTRA_FILES="skills/de-ai-ify.md skills/humanizer.md skills/copywriting.md" ;;
      esac

      success=true
      for f in $CORE_FILES $EXTRA_FILES; do
        mkdir -p "$AGENT_DIR/$(dirname "$f")"
        if ! fetch_file "$agent/$f" "$AGENT_DIR/$f"; then
          success=false
          break
        fi
      done
      if $success; then
        echo -e "  ${GREEN}✅ $agent${NC}"
      else
        echo -e "  ${YELLOW}⚠️  $agent — 部分文件下载失败${NC}"
      fi
    fi
  done

  # 复制协议文件
  echo ""
  echo -e "${YELLOW}▶ 安装协议文件 ...${NC}"
  PROTOCOL_FILES=("PROTOCOL.md" "ROUTER.md" "MEMORY.md" "QUICKSTART.md")
  for f in "${PROTOCOL_FILES[@]}"; do
    fetch_file "$f" "$WEIYIGE_DIR/$f"
    if [ -f "$WEIYIGE_DIR/$f" ] && [ -s "$WEIYIGE_DIR/$f" ]; then
      echo -e "  ${GREEN}✅ $f${NC}"
    else
      echo -e "  ${YELLOW}⚠️  $f — 下载失败${NC}"
    fi
  done

  # 安装配置文件（智能处理：不覆盖已有文件）
  echo ""
  echo -e "${YELLOW}▶ 安装配置文件 ...${NC}"
  install_config_file

  # 添加 .gitignore 条目
  echo ""
  echo -e "${YELLOW}▶ 检查 .gitignore ...${NC}"
  if [ -f "$TARGET_DIR/.gitignore" ]; then
    if ! grep -q "\.weiyige/" "$TARGET_DIR/.gitignore" 2>/dev/null; then
      echo "" >> "$TARGET_DIR/.gitignore"
      echo "# 维弈阁" >> "$TARGET_DIR/.gitignore"
      echo ".weiyige/*/memory/" >> "$TARGET_DIR/.gitignore"
      echo -e "  ${GREEN}✅ 已添加 .gitignore 条目（排除 Agent 记忆文件）${NC}"
    else
      echo -e "  ${BLUE}ℹ️  .gitignore 已包含相关条目，跳过${NC}"
    fi
  else
    echo -e "  ${BLUE}ℹ️  未找到 .gitignore，跳过${NC}"
  fi

  echo ""
  print_success
}

# ---------- 成功提示 ----------
print_success() {
  echo -e "${GREEN}${BOLD}✅ 安装完成！${NC}"
  echo ""
  echo -e "  安装位置：${BOLD}$TARGET_DIR/.weiyige/${NC}"
  echo -e "  配置文件：${BOLD}$TARGET_DIR/$CONFIG_FILE${NC}"
  echo ""
  echo -e "  ${CYAN}━━━ 下一步 ━━━${NC}"
  echo ""
  echo -e "  1. 用你的 AI 工具打开 ${BOLD}$TARGET_DIR${NC}"
  echo -e "     工具会自动读取 ${CONFIG_FILE}，激活维弈阁团队"
  echo ""
  echo -e "  2. 试试第一条指令："
  echo -e "     ${CYAN}@辞 帮我写一篇公众号文章${NC}"
  echo -e "     ${CYAN}@锋 审查一下这个产品方向${NC}"
  echo -e "     ${CYAN}@矩 帮我做工程审查${NC}"
  echo ""
  echo -e "  3. 不确定找谁？直接描述需求："
  echo -e "     ${CYAN}帮我优化这篇文章${NC}  → 自动路由到 辞"
  echo -e "     ${CYAN}这个架构有问题吗${NC}  → 自动路由到 矩"
  echo ""

  # 已有配置文件时的额外提示
  if [ -f "$TARGET_DIR/CLAUDE-weiyige.md" ]; then
    echo -e "  ${YELLOW}━━━ 注意 ━━━${NC}"
    echo -e "  你已有 ${CONFIG_FILE}，维弈阁配置写在 ${BOLD}CLAUDE-weiyige.md${NC}"
    echo -e "  请按上面提示合并到 ${CONFIG_FILE} 中，否则 AI 不会自动加载维弈阁。"
    echo ""
  fi
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
