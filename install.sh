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

# ---------- 版本号 ----------
WEIYIGE_VERSION="2.0.1"

# ---------- 脚本所在目录（本地安装时使用）----------
PAVILION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

# ---------- 默认参数 ----------
TARGET_DIR="$(pwd)"
INSTALL_MODE="full"
INSTALL_TOOL=""  # 空=自动检测

# ---------- 共享常量（消除重复）----------
AGENTS=(
  "CEO_锋" "PM_枢" "架构_矩" "设计_绘" "QA_鉴"
  "安全_盾" "财务_算" "内容_辞" "顾问_隐" "合伙人_砺"
  "执事_启" "探索_寻" "开发_铸"
)

CB_AGENT_NAMES=("锋·CEO" "枢·PM" "矩·架构" "绘·设计" "鉴·QA" "盾·安全" "算·财务" "辞·内容" "隐·智囊" "砺·合伙人" "启·执事" "寻·探索" "铸·开发")

PROTOCOL_FILES=("PROTOCOL.md" "ROUTER.md" "MEMORY.md" "QUICKSTART.md" "PROJECT-CONFIG-SPEC.md" "PACKAGING.md")

GATES_FILES=("gate-01-ideation.md" "gate-02-requirement.md" "gate-03-design.md" "gate-04-development.md" "gate-05-testing.md" "gate-06-release.md" "review-reminder.md" "two-layer-gate.md" "README.md")

RULES_FILES=("rules-global.md" "review-scoring.md" "README.md")

SKILLS_DIRS=("artifact-review" "knowledge-distillation" "micropen")

# ---------- 工具 → 配置文件映射 ----------
get_config_file() {
  case "$1" in
    cursor)    echo ".cursorrules" ;;
    copilot)   echo ".github/copilot-instructions.md" ;;
    windsurf)  echo ".windsurfrules" ;;
    cline)     echo ".clinerules" ;;
    *)         echo "CLAUDE.md" ;;
  esac
}

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
    --target)  TARGET_DIR="$2";  shift 2 ;;
    --mode)    INSTALL_MODE="$2"; shift 2 ;;
    --tool)    INSTALL_TOOL="$2"; shift 2 ;;
    --help|-h) show_help; exit 0 ;;
    *)         echo -e "${RED}未知参数: $1${NC}"; show_help; exit 1 ;;
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
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then echo "codebuddy"; return; fi
  if [ -f "$TARGET_DIR/.cursorrules" ] || [ -d "$TARGET_DIR/.cursor" ]; then echo "cursor"; return; fi
  if [ -f "$TARGET_DIR/.windsurfrules" ] || [ -d "$TARGET_DIR/.windsurf" ]; then echo "windsurf"; return; fi
  if [ -f "$TARGET_DIR/.clinerules" ]; then echo "cline"; return; fi
  if [ -f "$TARGET_DIR/.github/copilot-instructions.md" ]; then echo "copilot"; return; fi
  echo "codebuddy"
}

if [ -z "$INSTALL_TOOL" ]; then
  INSTALL_TOOL=$(detect_tool)
fi
CONFIG_FILE=$(get_config_file "$INSTALL_TOOL")

# ---------- 下载文件（远程 or 本地）----------
fetch_file() {
  local src_path="$1" dest_path="$2"
  # 优先本地
  if [ -f "$PAVILION_DIR/$src_path" ]; then
    cp "$PAVILION_DIR/$src_path" "$dest_path"
    return 0
  fi
  # 回退远程
  if command -v curl &>/dev/null; then
    curl -fsSL "$REMOTE_RAW/$src_path" -o "$dest_path" 2>/dev/null
  elif command -v wget &>/dev/null; then
    wget -q "$REMOTE_RAW/$src_path" -O "$dest_path" 2>/dev/null
  else
    echo -e "${RED}需要 curl 或 wget 来下载文件${NC}" >&2
    return 1
  fi
}

# ---------- 备份记录 ----------
BACKUP_FILES=""

backup_config() {
  local file_path="$1"
  if [ -f "$file_path" ] && [ -s "$file_path" ]; then
    local backup_path="${file_path}.weiyige-backup"
    if [ -f "$backup_path" ]; then
      backup_path="${file_path}.weiyige-backup.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$file_path" "$backup_path"
    BACKUP_FILES="$BACKUP_FILES|$file_path → $(basename "$backup_path")"
    echo -e "  ${BLUE}📦 已备份：$(basename "$file_path") → $(basename "$backup_path")${NC}"
  fi
}

# ---------- 获取 Agent 额外文件 ----------
get_agent_extra_files() {
  case "$1" in
    PM_枢)   echo "rules/design-review/RULE.mdc" ;;
    架构_矩) echo "rules/eng-review/RULE.mdc" ;;
    设计_绘) echo "rules/design-review/RULE.mdc" ;;
    QA_鉴)   echo "rules/qa/RULE.mdc" ;;
    执事_启) echo "start.md state-template.json progress-board-template.md exception-matrix.md runtime-knowledge.md" ;;
  esac
}

# ---------- 安装/更新 Agent 目录 ----------
# $1=WEIYIGE_DIR  $2=mode(full/update)
install_agents() {
  local wei_dir="$1" mode="$2"
  echo ""
  echo -e "${YELLOW}▶ $([ "$mode" = "update" ] && echo "更新" || echo "安装") Agent 定义文件...${NC}"

  for agent in "${AGENTS[@]}"; do
    local agent_dir="$wei_dir/$agent"
    mkdir -p "$agent_dir"

    if [ -d "$PAVILION_DIR/$agent" ]; then
      # ── 本地安装 ──
      if [ "$mode" = "full" ]; then
        cp -r "$PAVILION_DIR/$agent/"* "$agent_dir/" 2>/dev/null || true
      else
        # update: 覆盖核心文件，保留 memory/
        for f in IDENTITY.md SOUL.md SKILLS.md; do
          [ -f "$PAVILION_DIR/$agent/$f" ] && cp "$PAVILION_DIR/$agent/$f" "$agent_dir/"
        done
        [ -d "$PAVILION_DIR/$agent/skills" ] && cp -r "$PAVILION_DIR/$agent/skills" "$agent_dir/" 2>/dev/null || true
        [ -d "$PAVILION_DIR/$agent/rules" ] && cp -r "$PAVILION_DIR/$agent/rules" "$agent_dir/" 2>/dev/null || true
      fi
      echo -e "  ${GREEN}✅ $agent${NC}"
    else
      # ── 远程安装 ──
      local failed=false
      # 必选文件
      for f in IDENTITY.md SOUL.md; do
        if ! fetch_file "$agent/$f" "$agent_dir/$f"; then
          failed=true; break
        fi
      done
      if ! $failed; then
        # 可选文件
        for f in SKILLS.md memory/knowledge.md memory/lessons.md memory/preferences.md; do
          mkdir -p "$agent_dir/$(dirname "$f")"
          fetch_file "$agent/$f" "$agent_dir/$f" 2>/dev/null || true
        done
        # 额外文件
        local extra
        extra=$(get_agent_extra_files "$agent")
        for f in $extra; do
          mkdir -p "$agent_dir/$(dirname "$f")"
          fetch_file "$agent/$f" "$agent_dir/$f" 2>/dev/null || true
        done
      fi
      if ! $failed; then
        echo -e "  ${GREEN}✅ $agent${NC}"
      else
        echo -e "  ${YELLOW}⚠️  $agent — 核心文件下载失败${NC}"
      fi
    fi

    # 确保 memory/ 目录存在
    mkdir -p "$agent_dir/memory"
  done
}

# ---------- 安装/更新文件列表 ----------
# $1=WEIYIGE_DIR  $2=subdir  $3=files_array_name  $4=label
install_file_set() {
  local wei_dir="$1" subdir="$2" files_var="$3" label="$4"
  local dest_dir="$wei_dir/$subdir"
  mkdir -p "$dest_dir"

  echo ""
  echo -e "${YELLOW}▶ $label ...${NC}"

  # 间接引用数组（Bash 4.3+ 用 ${!files_var[@]}，这里兼容 3.x）
  eval "local files=(\"\${$files_var[@]}\")"
  local success=0 total=${#files[@]}

  for f in "${files[@]}"; do
    local src_prefix="$subdir"
    [ -n "$subdir" ] && src_prefix="$subdir/" || src_prefix=""
    if [ -f "$PAVILION_DIR/$src_prefix$f" ]; then
      cp "$PAVILION_DIR/$src_prefix$f" "$dest_dir/$f"
      success=$((success + 1))
    else
      if fetch_file "$src_prefix$f" "$dest_dir/$f" && [ -s "$dest_dir/$f" ]; then
        success=$((success + 1))
      fi
    fi
  done

  if [ "$success" -eq "$total" ]; then
    echo -e "  ${GREEN}✅ $label 已完成（${success}/${total}）${NC}"
  else
    echo -e "  ${YELLOW}⚠️  $label 部分完成（${success}/${total}）${NC}"
  fi
}

# ---------- 安装/更新 Skills 目录 ----------
# $1=WEIYIGE_DIR  $2=mode(full/update)
# Skills 同时安装到两个位置：
#   .weiyige/skills/      — 规则模式下由 CLAUDE.md 引用
#   .codebuddy/skills/    — CodeBuddy 多 Agent 模式自动发现和加载
install_skills() {
  local wei_dir="$1" mode="$2"
  local skills_dir="$wei_dir/skills"
  local cb_skills_dir="$TARGET_DIR/.codebuddy/skills"
  mkdir -p "$skills_dir"
  mkdir -p "$cb_skills_dir"

  echo ""
  echo -e "${YELLOW}▶ $([ "$mode" = "update" ] && echo "更新" || echo "安装") Skills ...${NC}"

  for skill in "${SKILLS_DIRS[@]}"; do
    local dest="$skills_dir/$skill"
    local cb_dest="$cb_skills_dir/$skill"
    mkdir -p "$dest"
    mkdir -p "$cb_dest"

    if [ -d "$PAVILION_DIR/skills/$skill" ]; then
      # 本地安装：递归复制到两个位置
      cp -r "$PAVILION_DIR/skills/$skill/"* "$dest/" 2>/dev/null || true
      cp -r "$PAVILION_DIR/skills/$skill/"* "$cb_dest/" 2>/dev/null || true
      echo -e "  ${GREEN}✅ $skill${NC}"
    else
      # 远程安装：下载 SKILL.md + references/
      local failed=false
      if ! fetch_file "skills/$skill/SKILL.md" "$dest/SKILL.md"; then
        failed=true
      fi
      # 尝试下载 references（artifact-review 有）
      for ref in requirement-review.md tech-design-review.md code-review.md test-review.md; do
        mkdir -p "$dest/references"
        fetch_file "skills/$skill/references/$ref" "$dest/references/$ref" 2>/dev/null || true
      done
      # 复制到 .codebuddy/skills/
      if [ -d "$dest" ]; then
        cp -r "$dest/"* "$cb_dest/" 2>/dev/null || true
      fi
      if ! $failed; then
        echo -e "  ${GREEN}✅ $skill${NC}"
      else
        echo -e "  ${YELLOW}⚠️  $skill — SKILL.md 下载失败${NC}"
      fi
    fi
  done

  echo -e "  ${BLUE}ℹ️  Skills 已同步到 .weiyige/skills/ 和 .codebuddy/skills/${NC}"
}

# ---------- 安装/更新 CodeBuddy Agent 文件 ----------
install_cb_agents() {
  echo ""
  echo -e "${YELLOW}▶ 安装 CodeBuddy Agent 文件 ...${NC}"
  local agents_dir="$TARGET_DIR/.codebuddy/agents"
  mkdir -p "$agents_dir"

  # 本地：直接复制
  local local_found=false
  for f in "$PAVILION_DIR/agents_for_codebuddy/"*.md; do
    if [ -f "$f" ]; then
      cp "$f" "$agents_dir/"
      local_found=true
    fi
  done

  if $local_found; then
    local count
    count=$(ls -1 "$agents_dir/"*.md 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✅ 已安装 ${count} 个 Agent 到 .codebuddy/agents/${NC}"
  else
    # 远程：逐个下载
    for name in "${CB_AGENT_NAMES[@]}"; do
      if fetch_file "agents_for_codebuddy/${name}.md" "$agents_dir/${name}.md"; then
        echo -e "  ${GREEN}✅ ${name}${NC}"
      else
        echo -e "  ${YELLOW}⚠️  ${name} — 下载失败${NC}"
      fi
    done
  fi
}

# ---------- 安装配置文件（智能处理）----------
install_config_file() {
  local config_path="$TARGET_DIR/$CONFIG_FILE"
  local tmp_file
  tmp_file=$(mktemp)
  fetch_file "CLAUDE.md" "$tmp_file"

  if [ ! -s "$tmp_file" ]; then
    echo -e "${RED}❌ 配置文件下载失败${NC}"
    rm -f "$tmp_file"; return 1
  fi

  if [ -f "$config_path" ] && [ -s "$config_path" ]; then
    # 已包含维弈阁配置？
    if grep -q "维弈阁 AI 团队" "$config_path" 2>/dev/null; then
      rm -f "$tmp_file"
      echo -e "  ${BLUE}ℹ️  ${CONFIG_FILE} 已包含维弈阁配置，跳过${NC}"
      return 0
    fi
    backup_config "$config_path"
    echo "" >> "$config_path"
    echo "---" >> "$config_path"
    cat "$tmp_file" >> "$config_path"
    rm -f "$tmp_file"
    echo -e "  ${GREEN}✅ 维弈阁配置已追加到 ${CONFIG_FILE} 末尾${NC}"
  else
    mkdir -p "$(dirname "$config_path")"
    cp "$tmp_file" "$config_path"
    rm -f "$tmp_file"
    echo -e "  ${GREEN}✅ ${CONFIG_FILE} 已创建（路由表内联，开箱即用）${NC}"
  fi
}

# ---------- 更新配置文件中的维弈阁段落 ----------
update_config_section() {
  local config_path="$TARGET_DIR/$CONFIG_FILE"
  if [ -f "$config_path" ] && grep -q "维弈阁 AI 团队" "$config_path" 2>/dev/null; then
    local tmp_file
    tmp_file=$(mktemp)
    fetch_file "CLAUDE.md" "$tmp_file"

    if [ -s "$tmp_file" ]; then
      backup_config "$config_path"
      local line_num
      line_num=$(grep -n "# 维弈阁 AI 团队" "$config_path" | head -1 | cut -d: -f1)
      if [ -n "$line_num" ]; then
        local sep_line=$line_num i=$((line_num - 1))
        while [ $i -ge 1 ]; do
          if sed -n "${i}p" "$config_path" | grep -q "^---"; then
            sep_line=$i; break
          fi
          i=$((i - 1))
        done
        head -n $((sep_line - 1)) "$config_path" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' > "${config_path}.tmp"
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
}

# ---------- .gitignore ----------
setup_gitignore() {
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
}

# ---------- 成功提示 ----------
print_success() {
  echo -e "${GREEN}${BOLD}✅ 安装完成！${NC}"
  echo ""
  echo -e "  安装位置：${BOLD}$TARGET_DIR/.weiyige/${NC}"
  echo -e "  配置文件：${BOLD}$TARGET_DIR/$CONFIG_FILE${NC}"
  echo ""

  if [ -n "$BACKUP_FILES" ]; then
    echo -e "  ${BLUE}━━━ 备份文件 ━━━${NC}"
    echo ""
    local OLD_IFS="$IFS"; IFS="|"
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
  echo -e "     已将 Skills 安装到 ${BOLD}.codebuddy/skills/${NC}"
  echo -e "     CodeBuddy 会根据意图自动调度对应 Agent 和 Skill"
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

# ================================================
#  Banner
# ================================================
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
echo -e "  ${BLUE}版本号：  ${NC} v${WEIYIGE_VERSION}"
echo ""

# ================================================
#  模式：claude（仅配置文件）
# ================================================
install_claude_mode() {
  echo -e "${YELLOW}▶ 安装配置文件 ...${NC}"
  install_config_file
  echo ""
  echo -e "${YELLOW}⚠️  claude 模式不含 Agent 深度定义文件。${NC}"
  echo -e "  如需完整功能（Agent 人格、技能、记忆），请用 ${BOLD}--mode full${NC} 安装。"
  echo ""
  print_success
}

# ================================================
#  模式：full（完整安装）
# ================================================
install_full_mode() {
  WEIYIGE_DIR="$TARGET_DIR/.weiyige"
  echo -e "${YELLOW}▶ 创建 .weiyige 目录 ...${NC}"
  mkdir -p "$WEIYIGE_DIR"
  echo -e "  ${GREEN}✅ $WEIYIGE_DIR${NC}"

  install_agents "$WEIYIGE_DIR" "full"
  install_file_set "$WEIYIGE_DIR" ""    PROTOCOL_FILES "安装协议文件"
  install_file_set "$WEIYIGE_DIR" "gates" GATES_FILES  "安装 Gates 阶段门禁清单"
  install_file_set "$WEIYIGE_DIR" "rules" RULES_FILES  "安装 Rules 规则文件"
  install_skills "$WEIYIGE_DIR" "full"

  echo ""
  echo -e "${YELLOW}▶ 安装配置文件 ...${NC}"
  install_config_file

  install_cb_agents
  setup_gitignore

  echo ""
  print_success
}

# ================================================
#  模式：update（更新已安装的维弈阁）
# ================================================
install_update_mode() {
  WEIYIGE_DIR=""
  if [ -d "$TARGET_DIR/.weiyige" ]; then
    WEIYIGE_DIR="$TARGET_DIR/.weiyige"
  else
    # 向上查找（最多 3 层）
    for i in 1 2 3; do
      local parent
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

  install_agents "$WEIYIGE_DIR" "update"
  install_file_set "$WEIYIGE_DIR" ""    PROTOCOL_FILES "更新协议文件"
  install_file_set "$WEIYIGE_DIR" "gates" GATES_FILES  "更新 Gates 阶段门禁清单"
  install_file_set "$WEIYIGE_DIR" "rules" RULES_FILES  "更新 Rules 规则文件"
  install_skills "$WEIYIGE_DIR" "update"

  # 更新 CodeBuddy Agent 文件
  echo ""
  echo -e "${YELLOW}▶ 更新 CodeBuddy Agent 文件 ...${NC}"
  local agents_dir="$TARGET_DIR/.codebuddy/agents"
  if [ -d "$agents_dir" ]; then
    local local_found=false
    for f in "$PAVILION_DIR/agents_for_codebuddy/"*.md; do
      [ -f "$f" ] && cp "$f" "$agents_dir/" && local_found=true
    done
    if $local_found; then
      local count
      count=$(ls -1 "$agents_dir/"*.md 2>/dev/null | wc -l | tr -d ' ')
      echo -e "  ${GREEN}✅ 已更新 ${count} 个 Agent${NC}"
    else
      for name in "${CB_AGENT_NAMES[@]}"; do
        fetch_file "agents_for_codebuddy/${name}.md" "$agents_dir/${name}.md" 2>/dev/null && \
          echo -e "  ${GREEN}✅ ${name}${NC}"
      done
    fi
  else
    echo -e "  ${BLUE}ℹ️  未找到 .codebuddy/agents/，跳过${NC}"
  fi

  # 更新配置文件中的维弈阁段落
  echo ""
  echo -e "${YELLOW}▶ 更新配置文件中的维弈阁段落 ...${NC}"
  update_config_section

  echo ""
  echo -e "${GREEN}${BOLD}✅ 更新完成！${NC}"
  echo ""
  echo -e "  更新位置：${BOLD}$WEIYIGE_DIR${NC}"
  echo -e "  memory/ 目录已保留，你的偏好和经验教训不会丢失。"
  echo ""
}

# ================================================
#  执行
# ================================================
case "$INSTALL_MODE" in
  claude) install_claude_mode ;;
  full)   install_full_mode ;;
  update) install_update_mode ;;
  *)      echo -e "${RED}未知安装模式：$INSTALL_MODE（支持：claude / full / update）${NC}"; exit 1 ;;
esac
