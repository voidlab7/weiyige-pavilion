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
  echo "                       update  — 更新已安装的维弈阁（保留用户数据）"
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
  echo "  ./install.sh --mode update                # 更新已安装的维弈阁"
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

# ---------- 备份记录（安装结束后统一提示）----------
BACKUP_FILES=""

# ---------- 备份已有配置文件 ----------
backup_config() {
  local file_path="$1"
  if [ -f "$file_path" ] && [ -s "$file_path" ]; then
    local backup_path="${file_path}.weiyige-backup"
    # 如果备份已存在，加时间戳
    if [ -f "$backup_path" ]; then
      backup_path="${file_path}.weiyige-backup.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$file_path" "$backup_path"
    BACKUP_FILES="$BACKUP_FILES|$file_path → $(basename "$backup_path")"
    echo -e "  ${BLUE}📦 已备份：$(basename "$file_path") → $(basename "$backup_path")${NC}"
  fi
}

# ---------- 安装配置文件 ----------
install_config_file() {
  local config_path="$TARGET_DIR/$CONFIG_FILE"

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
    # 检查是否已包含维弈阁配置（避免重复追加）
    if grep -q "维弈阁 AI 团队" "$config_path" 2>/dev/null; then
      rm -f "$tmp_file"
      echo -e "  ${BLUE}ℹ️  ${CONFIG_FILE} 已包含维弈阁配置，跳过${NC}"
      return 0
    fi

    # 备份原文件
    backup_config "$config_path"

    # 追加维弈阁配置到原文件末尾
    echo "" >> "$config_path"
    echo "---" >> "$config_path"
    cat "$tmp_file" >> "$config_path"
    rm -f "$tmp_file"

    echo -e "  ${GREEN}✅ 维弈阁配置已追加到 ${CONFIG_FILE} 末尾${NC}"
    return 0
  fi

  # 用户没有配置文件 → 直接创建
  mkdir -p "$(dirname "$config_path")"
  cp "$tmp_file" "$config_path"
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
      CORE_FILES="IDENTITY.md SOUL.md SKILLS.md memory/knowledge.md memory/lessons.md memory/preferences.md"
      EXTRA_FILES=""
      case "$agent" in
        PM_枢)     EXTRA_FILES="rules/design-review/RULE.mdc" ;;
        架构_矩)   EXTRA_FILES="rules/eng-review/RULE.mdc" ;;
        设计_绘)   EXTRA_FILES="rules/design-review/RULE.mdc" ;;
        QA_鉴)     EXTRA_FILES="rules/qa/RULE.mdc" ;;
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

  # 复制阶段门禁清单
  echo ""
  echo -e "${YELLOW}▶ 安装 Gates 阶段门禁清单 ...${NC}"
  GATES_DIR="$WEIYIGE_DIR/gates"
  mkdir -p "$GATES_DIR"
  GATES_FILES=("gate-01-ideation.md" "gate-02-requirements.md" "gate-03-design.md" "gate-04-development.md" "gate-05-testing.md" "gate-06-release.md" "README.md")
  GATES_SUCCESS=0
  GATES_TOTAL=${#GATES_FILES[@]}
  for f in "${GATES_FILES[@]}"; do
    if fetch_file "gates/$f" "$GATES_DIR/$f" && [ -s "$GATES_DIR/$f" ]; then
      GATES_SUCCESS=$((GATES_SUCCESS + 1))
    fi
  done
  if [ "$GATES_SUCCESS" -eq "$GATES_TOTAL" ]; then
    echo -e "  ${GREEN}✅ Gates 已安装（${GATES_SUCCESS} 个门禁清单）${NC}"
  else
    echo -e "  ${YELLOW}⚠️  Gates 部分安装（${GATES_SUCCESS}/${GATES_TOTAL}）${NC}"
  fi

  # 安装配置文件（智能处理：不覆盖已有文件）
  echo ""
  echo -e "${YELLOW}▶ 安装配置文件 ...${NC}"
  install_config_file

  # 安装 CodeBuddy 多 Agent 适配文件
  echo ""
  echo -e "${YELLOW}▶ 安装 CodeBuddy 多 Agent 适配文件 ...${NC}"
  AGENTS_DIR="$TARGET_DIR/.codebuddy/agents"
  mkdir -p "$AGENTS_DIR"

  AGENT_FILES_FOUND=false
  for f in "$PAVILION_DIR/agents_for_codebuddy/"*.md; do
    if [ -f "$f" ]; then
      cp "$f" "$AGENTS_DIR/"
      AGENT_FILES_FOUND=true
    fi
  done

  if $AGENT_FILES_FOUND; then
    AGENT_COUNT=$(ls -1 "$AGENTS_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✅ 已安装 ${AGENT_COUNT} 个 Agent 到 .codebuddy/agents/${NC}"
  else
    # 远程安装：逐个下载
    AGENT_NAMES=("锋·CEO" "枢·PM" "矩·架构" "绘·设计" "鉴·QA" "盾·安全" "算·财务" "辞·内容" "隐·智囊" "砺·合伙人" "墨·执事")
    for name in "${AGENT_NAMES[@]}"; do
      if fetch_file "agents_for_codebuddy/${name}.md" "$AGENTS_DIR/${name}.md"; then
        echo -e "  ${GREEN}✅ ${name}${NC}"
      else
        echo -e "  ${YELLOW}⚠️  ${name} — 下载失败${NC}"
      fi
    done
  fi

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

  # 备份文件提示（统一展示）
  if [ -n "$BACKUP_FILES" ]; then
    echo -e "  ${BLUE}━━━ 备份文件 ━━━${NC}"
    echo ""
    OLD_IFS="$IFS"
    IFS="|"
    for entry in $BACKUP_FILES; do
      [ -z "$entry" ] && continue
      echo -e "  📦 $entry"
    done
    IFS="$OLD_IFS"
    echo ""
  fi

  echo -e "  ${CYAN}━━━ 下一步 ━━━${NC}"
  echo ""
  echo -e "  1. 用你的 AI 工具打开 ${BOLD}$TARGET_DIR${NC}"
  echo -e "     工具会自动读取 ${CONFIG_FILE}，激活维弈阁团队"
  echo ""
  echo -e "  2. ${BOLD}多 Agent 模式${NC}（推荐）："
  echo -e "     已将 Agent 文件安装到 ${BOLD}.codebuddy/agents/${NC}"
  echo -e "     CodeBuddy 会根据意图自动调度对应 Agent"
  echo -e "     如需手动添加：cp agents_for_codebuddy/*.md .codebuddy/agents/"
  echo ""
  echo -e "  3. 试试第一条指令："
  echo -e "     ${CYAN}@辞 帮我写一篇公众号文章${NC}"
  echo -e "     ${CYAN}@锋 审查一下这个产品方向${NC}"
  echo -e "     ${CYAN}@矩 帮我做工程审查${NC}"
  echo ""
  echo -e "  4. 不确定找谁？直接描述需求："
  echo -e "     ${CYAN}帮我优化这篇文章${NC}  → 自动路由到 辞"
  echo -e "     ${CYAN}这个架构有问题吗${NC}  → 自动路由到 矩"
  echo ""
}

# ---------- 模式：update（更新已安装的维弈阁）----------
install_update_mode() {
  # 自动扫描已安装的 .weiyige 目录
  WEIYIGE_DIR=""
  if [ -d "$TARGET_DIR/.weiyige" ]; then
    WEIYIGE_DIR="$TARGET_DIR/.weiyige"
  else
    # 向上查找（最多 3 层）
    for i in 1 2 3; do
      parent="$(cd "$TARGET_DIR/$(printf '../%.0s' $(seq 1 $i))" 2>/dev/null && pwd)"
      if [ -d "$parent/.weiyige" ]; then
        WEIYIGE_DIR="$parent/.weiyige"
        TARGET_DIR="$parent"
        break
      fi
    done
  fi

  if [ -z "$WEIYIGE_DIR" ] || [ ! -d "$WEIYIGE_DIR" ]; then
    echo -e "${RED}❌ 未找到已安装的维弈阁目录（.weiyige/）${NC}"
    echo -e "  请先安装：./install.sh --mode full"
    exit 1
  fi

  echo -e "${GREEN}✅ 找到已安装目录：$WEIYIGE_DIR${NC}"
  echo ""

  # Agent 列表
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

  # 更新 Agent 定义文件（覆盖 SOUL/IDENTITY/SKILLS/skills/rules，保留 memory/）
  echo -e "${YELLOW}▶ 更新 Agent 定义文件（保留 memory/）...${NC}"
  for agent in "${AGENTS[@]}"; do
    AGENT_DIR="$WEIYIGE_DIR/$agent"
    if [ ! -d "$AGENT_DIR" ]; then
      mkdir -p "$AGENT_DIR"
    fi

    UPDATED=false

    # 本地安装：直接覆盖核心文件
    if [ -d "$PAVILION_DIR/$agent" ]; then
      for f in IDENTITY.md SOUL.md SKILLS.md; do
        if [ -f "$PAVILION_DIR/$agent/$f" ]; then
          cp "$PAVILION_DIR/$agent/$f" "$AGENT_DIR/$f"
          UPDATED=true
        fi
      done
      # 覆盖 skills/ 和 rules/ 目录
      if [ -d "$PAVILION_DIR/$agent/skills" ]; then
        cp -r "$PAVILION_DIR/$agent/skills" "$AGENT_DIR/" 2>/dev/null || true
        UPDATED=true
      fi
      if [ -d "$PAVILION_DIR/$agent/rules" ]; then
        cp -r "$PAVILION_DIR/$agent/rules" "$AGENT_DIR/" 2>/dev/null || true
        UPDATED=true
      fi
    else
      # 远程安装：下载核心文件
      for f in IDENTITY.md SOUL.md SKILLS.md; do
        if fetch_file "$agent/$f" "$AGENT_DIR/$f" 2>/dev/null; then
          UPDATED=true
        fi
      done
      # 下载 skills/ 和 rules/
      EXTRA_FILES=""
      case "$agent" in
        PM_枢)     EXTRA_FILES="rules/design-review/RULE.mdc" ;;
        架构_矩)   EXTRA_FILES="rules/eng-review/RULE.mdc" ;;
        设计_绘)   EXTRA_FILES="rules/design-review/RULE.mdc" ;;
        QA_鉴)     EXTRA_FILES="rules/qa/RULE.mdc" ;;
      esac
      for f in $EXTRA_FILES; do
        mkdir -p "$AGENT_DIR/$(dirname "$f")"
        if fetch_file "$agent/$f" "$AGENT_DIR/$f" 2>/dev/null; then
          UPDATED=true
        fi
      done
    fi

    # 确保 memory/ 目录存在（不覆盖内容）
    mkdir -p "$AGENT_DIR/memory"

    if $UPDATED; then
      echo -e "  ${GREEN}✅ $agent${NC}"
    else
      echo -e "  ${BLUE}ℹ️  $agent — 无更新${NC}"
    fi
  done

  # 更新协议文件
  echo ""
  echo -e "${YELLOW}▶ 更新协议文件 ...${NC}"
  PROTOCOL_FILES=("PROTOCOL.md" "ROUTER.md" "MEMORY.md" "QUICKSTART.md")
  for f in "${PROTOCOL_FILES[@]}"; do
    if [ -f "$PAVILION_DIR/$f" ]; then
      cp "$PAVILION_DIR/$f" "$WEIYIGE_DIR/$f"
      echo -e "  ${GREEN}✅ $f${NC}"
    else
      if fetch_file "$f" "$WEIYIGE_DIR/$f" 2>/dev/null; then
        echo -e "  ${GREEN}✅ $f${NC}"
      else
        echo -e "  ${YELLOW}⚠️  $f — 下载失败${NC}"
      fi
    fi
  done

  # 更新 Gates 阶段门禁清单
  echo ""
  echo -e "${YELLOW}▶ 更新 Gates 阶段门禁清单 ...${NC}"
  GATES_DIR="$WEIYIGE_DIR/gates"
  mkdir -p "$GATES_DIR"
  GATES_FILES=("gate-01-ideation.md" "gate-02-requirements.md" "gate-03-design.md" "gate-04-development.md" "gate-05-testing.md" "gate-06-release.md" "README.md")
  GATES_SUCCESS=0
  GATES_TOTAL=${#GATES_FILES[@]}
  for f in "${GATES_FILES[@]}"; do
    if [ -f "$PAVILION_DIR/gates/$f" ]; then
      cp "$PAVILION_DIR/gates/$f" "$GATES_DIR/$f"
      GATES_SUCCESS=$((GATES_SUCCESS + 1))
    else
      if fetch_file "gates/$f" "$GATES_DIR/$f" 2>/dev/null && [ -s "$GATES_DIR/$f" ]; then
        GATES_SUCCESS=$((GATES_SUCCESS + 1))
      fi
    fi
  done
  if [ "$GATES_SUCCESS" -eq "$GATES_TOTAL" ]; then
    echo -e "  ${GREEN}✅ Gates 已更新（${GATES_SUCCESS} 个门禁清单）${NC}"
  else
    echo -e "  ${YELLOW}⚠️  Gates 部分更新（${GATES_SUCCESS}/${GATES_TOTAL}）${NC}"
  fi

  # 更新 CodeBuddy Agent 文件
  echo ""
  echo -e "${YELLOW}▶ 更新 CodeBuddy Agent 文件 ...${NC}"
  AGENTS_DIR="$TARGET_DIR/.codebuddy/agents"
  if [ -d "$AGENTS_DIR" ]; then
    AGENT_FILES_FOUND=false
    for f in "$PAVILION_DIR/agents_for_codebuddy/"*.md; do
      if [ -f "$f" ]; then
        cp "$f" "$AGENTS_DIR/"
        AGENT_FILES_FOUND=true
      fi
    done

    if $AGENT_FILES_FOUND; then
      AGENT_COUNT=$(ls -1 "$AGENTS_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
      echo -e "  ${GREEN}✅ 已更新 ${AGENT_COUNT} 个 Agent${NC}"
    else
      AGENT_NAMES=("锋·CEO" "枢·PM" "矩·架构" "绘·设计" "鉴·QA" "盾·安全" "算·财务" "辞·内容" "隐·智囊" "砺·合伙人" "墨·执事")
      for name in "${AGENT_NAMES[@]}"; do
        if fetch_file "agents_for_codebuddy/${name}.md" "$AGENTS_DIR/${name}.md" 2>/dev/null; then
          echo -e "  ${GREEN}✅ ${name}${NC}"
        fi
      done
    fi
  else
    echo -e "  ${BLUE}ℹ️  未找到 .codebuddy/agents/，跳过${NC}"
  fi

  # 更新 CLAUDE.md 中的维弈阁配置段落
  echo ""
  echo -e "${YELLOW}▶ 更新配置文件中的维弈阁段落 ...${NC}"
  local config_path="$TARGET_DIR/$CONFIG_FILE"
  if [ -f "$config_path" ] && grep -q "维弈阁 AI 团队" "$config_path" 2>/dev/null; then
    local tmp_file
    tmp_file=$(mktemp)
    fetch_file "CLAUDE.md" "$tmp_file"

    if [ -s "$tmp_file" ]; then
      # 备份
      backup_config "$config_path"

      # 找到维弈阁段落的起始位置
      local line_num
      line_num=$(grep -n "# 维弈阁 AI 团队" "$config_path" | head -1 | cut -d: -f1)
      if [ -n "$line_num" ]; then
        # 找到前面的 --- 分隔线
        local sep_line=$line_num
        local i=$((line_num - 1))
        while [ $i -ge 1 ]; do
          if sed -n "${i}p" "$config_path" | grep -q "^---"; then
            sep_line=$i
            break
          fi
          i=$((i - 1))
        done

        # 保留维弈阁段落之前的内容（去掉末尾空行）
        head -n $((sep_line - 1)) "$config_path" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' > "${config_path}.tmp"
        # 追加新的维弈阁配置
        echo "" >> "${config_path}.tmp"
        echo "---" >> "${config_path}.tmp"
        cat "$tmp_file" >> "${config_path}.tmp"
        mv "${config_path}.tmp" "$config_path"
        echo -e "  ${GREEN}✅ 维弈阁配置段落已更新${NC}"
      else
        rm -f "${config_path}.tmp"
        echo -e "  ${BLUE}ℹ️  未找到维弈阁段落标记，跳过${NC}"
      fi
    fi
    rm -f "$tmp_file"
  else
    echo -e "  ${BLUE}ℹ️  配置文件中未找到维弈阁段落，跳过${NC}"
  fi

  echo ""
  echo -e "${GREEN}${BOLD}✅ 更新完成！${NC}"
  echo ""
  echo -e "  更新位置：${BOLD}$WEIYIGE_DIR${NC}"
  echo -e "  memory/ 目录已保留，你的偏好和经验教训不会丢失。"
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
  update)
    install_update_mode
    ;;
  *)
    echo -e "${RED}未知安装模式：$INSTALL_MODE（支持：claude / full / update）${NC}"
    exit 1
    ;;
esac
