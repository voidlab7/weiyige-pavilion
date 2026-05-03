# =============================================================================
# 维弈阁（Weiyige Pavilion）一键安装脚本 — Windows PowerShell 版
# 将 AI 团队安装到你的项目中
#
# 用法：
#   # 远程安装（推荐）
#   irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex
#
#   # 带参数
#   irm https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main/install.ps1 | iex -Target "D:\my-project"
#
#   # 本地安装
#   .\install.ps1
#   .\install.ps1 -Target "D:\my-project" -Tool cursor
# =============================================================================

param(
    [string]$Target = (Get-Location).Path,
    [ValidateSet("full", "claude", "update")]
    [string]$Mode = "full",
    [ValidateSet("codebuddy", "claude", "cursor", "copilot", "windsurf", "cline", "")]
    [string]$Tool = "",
    [switch]$Help
)

$REMOTE_RAW = "https://raw.githubusercontent.com/voidlab7/weiyige-pavilion/main"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# ---------- 帮助 ----------
if ($Help) {
    Write-Host ""
    Write-Host "维弈阁（Weiyige Pavilion）一键安装 — Windows 版" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "用法："
    Write-Host "  .\install.ps1                              # 安装到当前目录"
    Write-Host "  .\install.ps1 -Target D:\my-project        # 安装到指定项目"
    Write-Host "  .\install.ps1 -Tool cursor                 # 为 Cursor 安装"
    Write-Host "  .\install.ps1 -Mode claude                 # 最轻量安装"
    Write-Host ""
    Write-Host "参数："
    Write-Host "  -Target <目录>    安装目标目录（默认：当前目录）"
    Write-Host "  -Mode <模式>      full（完整）| claude（仅配置文件）| update（更新已安装）"
    Write-Host "  -Tool <工具>      codebuddy | cursor | copilot | windsurf | cline"
    Write-Host ""
    exit 0
}

# ---------- 工具 → 配置文件映射 ----------
function Get-ConfigFile {
    param([string]$tool)
    switch ($tool) {
        "codebuddy" { "CLAUDE.md" }
        "claude"    { "CLAUDE.md" }
        "cursor"    { ".cursorrules" }
        "copilot"   { ".github/copilot-instructions.md" }
        "windsurf"  { ".windsurfrules" }
        "cline"     { ".clinerules" }
        default     { "CLAUDE.md" }
    }
}

# ---------- 自动检测 AI 工具 ----------
function Detect-Tool {
    if (Test-Path "$Target/CLAUDE.md") { return "codebuddy" }
    if (Test-Path "$Target/.cursorrules" -or (Test-Path "$Target/.cursor")) { return "cursor" }
    if (Test-Path "$Target/.windsurfrules" -or (Test-Path "$Target/.windsurf")) { return "windsurf" }
    if (Test-Path "$Target/.clinerules") { return "cline" }
    if (Test-Path "$Target/.github/copilot-instructions.md") { return "copilot" }
    return "codebuddy"
}

if ([string]::IsNullOrEmpty($Tool)) {
    $Tool = Detect-Tool
}

$CONFIG_FILE = Get-ConfigFile $Tool

# ---------- 下载文件 ----------
function Fetch-File {
    param(
        [string]$SrcPath,
        [string]$DestPath
    )

    # 优先本地
    $localPath = Join-Path $SCRIPT_DIR $SrcPath
    if (Test-Path $localPath) {
        Copy-Item $localPath $DestPath -Force
        return $true
    }

    # 远程下载
    $url = "$REMOTE_RAW/$SrcPath"
    try {
        $destDir = Split-Path -Parent $DestPath
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Invoke-WebRequest -Uri $url -OutFile $DestPath -UseBasicParsing
        return $true
    } catch {
        return $false
    }
}

# ---------- Banner ----------
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     维弈阁 AI 团队  一键安装              ║" -ForegroundColor Cyan
Write-Host "║     Weiyige Pavilion — Install            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  安装目标： $Target" -ForegroundColor Blue
Write-Host "  安装模式： $Mode" -ForegroundColor Blue
Write-Host "  AI 工具：  $Tool → $CONFIG_FILE" -ForegroundColor Blue
Write-Host ""

# ---------- 安装配置文件 ----------
function Install-ConfigFile {
    $configPath = Join-Path $Target $CONFIG_FILE

    # 下载维弈阁配置
    $tmpFile = Join-Path $env:TEMP "weiyige-claude-$(Get-Random).md"
    Fetch-File "CLAUDE.md" $tmpFile | Out-Null

    if (-not (Test-Path $tmpFile) -or (Get-Item $tmpFile).Length -eq 0) {
        Write-Host "  ❌ 配置文件下载失败" -ForegroundColor Red
        return $false
    }

    # 已有配置文件
    if (Test-Path $configPath) {
        # 检查是否已包含维弈阁配置（避免重复追加）
        $content = Get-Content $configPath -Raw -ErrorAction SilentlyContinue
        if ($content -match "维弈阁 AI 团队") {
            Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
            Write-Host "  ℹ️  $CONFIG_FILE 已包含维弈阁配置，跳过" -ForegroundColor Blue
            return $true
        }

        # 备份
        $backupPath = "$configPath.weiyige-backup"
        if (Test-Path $backupPath) { $backupPath = "$configPath.weiyige-backup.$(Get-Date -Format 'yyyyMMddHHmmss')" }
        Copy-Item $configPath $backupPath -Force
        Write-Host "  📦 已备份：$CONFIG_FILE → $(Split-Path $backupPath -Leaf)" -ForegroundColor Blue

        # 追加维弈阁配置到原文件末尾
        Add-Content $configPath ""
        Add-Content $configPath "---"
        $weiyigeContent = Get-Content $tmpFile -Raw
        Add-Content $configPath $weiyigeContent
        Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue

        Write-Host "  ✅ 维弈阁配置已追加到 $CONFIG_FILE 末尾" -ForegroundColor Green
    } else {
        # 直接创建
        $destDir = Split-Path $configPath -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item $tmpFile $configPath -Force
        Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
        Write-Host "  ✅ $CONFIG_FILE 已创建（路由表内联，开箱即用）" -ForegroundColor Green
    }

    return $true
}

# ---------- Agent 列表 ----------
$AGENTS = @(
    "CEO_锋", "PM_枢", "架构_矩", "设计_绘", "QA_鉴",
    "安全_盾", "财务_算", "内容_辞", "顾问_隐", "合伙人_砺",
    "执事_启", "探索_寻", "开发_铸"
)

$AGENT_NAMES = @(
    "锋·CEO", "枢·PM", "矩·架构", "绘·设计", "鉴·QA",
    "盾·安全", "算·财务", "辞·内容", "隐·智囊", "砺·合伙人",
    "启·执事", "寻·探索", "铸·开发"
)

$PROTOCOL_FILES = @("PROTOCOL.md", "ROUTER.md", "MEMORY.md", "QUICKSTART.md", "PROJECT-CONFIG-SPEC.md", "PACKAGING.md")
$RULES_FILES = @("rules-global.md", "review-scoring.md", "README.md")
$SKILLS_DIRS = @("artifact-review", "knowledge-distillation", "micropen")

# ---------- Full 模式安装 ----------
function Install-FullMode {
    $weiyigeDir = Join-Path $Target ".weiyige"

    Write-Host "▶ 创建 .weiyige 目录 ..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $weiyigeDir -Force | Out-Null
    Write-Host "  ✅ $weiyigeDir" -ForegroundColor Green

    # 安装 Agent 定义文件
    Write-Host ""
    Write-Host "▶ 安装 Agent 定义文件 ..." -ForegroundColor Yellow
    foreach ($agent in $AGENTS) {
        $agentDir = Join-Path $weiyigeDir $agent
        New-Item -ItemType Directory -Path $agentDir -Force | Out-Null

        $localAgentDir = Join-Path $SCRIPT_DIR $agent
        if (Test-Path $localAgentDir) {
            Copy-Item "$localAgentDir\*" $agentDir -Recurse -Force
            Write-Host "  ✅ $agent" -ForegroundColor Green
        } else {
            # 远程下载
            $coreFiles = @("IDENTITY.md", "SOUL.md", "SKILLS.md", "memory/knowledge.md", "memory/lessons.md", "memory/preferences.md")
            $extraFiles = @()
            switch ($agent) {
                "PM_枢"   { $extraFiles = @("rules/design-review/RULE.mdc") }
                "架构_矩" { $extraFiles = @("rules/eng-review/RULE.mdc") }
                "设计_绘" { $extraFiles = @("rules/design-review/RULE.mdc") }
                "QA_鉴"   { $extraFiles = @("rules/qa/RULE.mdc") }
            }

            $success = $true
            foreach ($f in ($coreFiles + $extraFiles)) {
                $destFile = Join-Path $agentDir $f
                if (-not (Fetch-File "$agent/$f" $destFile)) {
                    $success = $false
                    break
                }
            }
            if ($success) {
                Write-Host "  ✅ $agent" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️  $agent — 部分文件下载失败" -ForegroundColor Yellow
            }
        }
    }

    # 协议文件
    Write-Host ""
    Write-Host "▶ 安装协议文件 ..." -ForegroundColor Yellow
    $protocolFiles = @("PROTOCOL.md", "ROUTER.md", "MEMORY.md", "QUICKSTART.md")
    foreach ($f in $protocolFiles) {
        $destFile = Join-Path $weiyigeDir $f
        Fetch-File $f $destFile | Out-Null
        if (Test-Path $destFile) {
            Write-Host "  ✅ $f" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  $f — 下载失败" -ForegroundColor Yellow
        }
    }

    # Gates 阶段门禁清单
    Write-Host ""
    Write-Host "▶ 安装 Gates 阶段门禁清单 ..." -ForegroundColor Yellow
    $gatesDir = Join-Path $weiyigeDir "gates"
    New-Item -ItemType Directory -Path $gatesDir -Force | Out-Null
    $gatesFiles = @("gate-01-ideation.md", "gate-02-requirement.md", "gate-03-design.md", "gate-04-development.md", "gate-05-testing.md", "gate-06-release.md", "review-reminder.md", "two-layer-gate.md", "README.md")
    $gatesSuccess = 0
    foreach ($f in $gatesFiles) {
        $destFile = Join-Path $gatesDir $f
        if (Fetch-File "gates/$f" $destFile) {
            $gatesSuccess++
        }
    }
    if ($gatesSuccess -eq $gatesFiles.Count) {
        Write-Host "  ✅ Gates 已安装（$gatesSuccess 个门禁清单）" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Gates 部分安装（$gatesSuccess/$($gatesFiles.Count)）" -ForegroundColor Yellow
    }

    # 配置文件
    Write-Host ""
    Write-Host "▶ 安装配置文件 ..." -ForegroundColor Yellow
    Install-ConfigFile | Out-Null

    # CodeBuddy 多 Agent 适配文件
    Write-Host ""
    Write-Host "▶ 安装 CodeBuddy 多 Agent 适配文件 ..." -ForegroundColor Yellow
    $agentsDir = Join-Path $Target ".codebuddy\agents"
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

    $localAgentsDir = Join-Path $SCRIPT_DIR "agents_for_codebuddy"
    if (Test-Path $localAgentsDir) {
        Copy-Item "$localAgentsDir\*.md" $agentsDir -Force
        $count = (Get-ChildItem "$agentsDir\*.md").Count
        Write-Host "  ✅ 已安装 $count 个 Agent 到 .codebuddy\agents\" -ForegroundColor Green
    } else {
        # 远程下载
        foreach ($name in $AGENT_NAMES) {
            $destFile = Join-Path $agentsDir "$name.md"
            if (Fetch-File "agents_for_codebuddy/$name.md" $destFile) {
                Write-Host "  ✅ $name" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️  $name — 下载失败" -ForegroundColor Yellow
            }
        }
    }

    # .gitignore
    Write-Host ""
    Write-Host "▶ 检查 .gitignore ..." -ForegroundColor Yellow
    $gitignore = Join-Path $Target ".gitignore"
    if (Test-Path $gitignore) {
        $content = Get-Content $gitignore -Raw
        if ($content -notmatch "\.weiyige/") {
            Add-Content $gitignore ""
            Add-Content $gitignore "# 维弈阁"
            Add-Content $gitignore ".weiyige/*/memory/"
            Write-Host "  ✅ 已添加 .gitignore 条目（排除 Agent 记忆文件）" -ForegroundColor Green
        } else {
            Write-Host "  ℹ️  .gitignore 已包含相关条目，跳过" -ForegroundColor Blue
        }
    } else {
        Write-Host "  ℹ️  未找到 .gitignore，跳过" -ForegroundColor Blue
    }
}

# ---------- 成功提示 ----------
function Print-Success {
    Write-Host "✅ 安装完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "  安装位置：$Target\.weiyige\" -ForegroundColor White
    Write-Host "  配置文件：$Target\$CONFIG_FILE" -ForegroundColor White
    Write-Host ""

    Write-Host "  ━━━ 下一步 ━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. 用你的 AI 工具打开 $Target"
    Write-Host "     工具会自动读取 $CONFIG_FILE，激活维弈阁团队"
    Write-Host ""
    Write-Host "  2. 多 Agent 模式（推荐）："
    Write-Host "     已将 Agent 文件安装到 .codebuddy\agents\"
    Write-Host "     已将 Skills 安装到 .codebuddy\skills\"
    Write-Host "     CodeBuddy 会根据意图自动调度对应 Agent 和 Skill"
    Write-Host ""
    Write-Host "  3. 试试第一条指令："
    Write-Host "     @辞 帮我写一篇公众号文章" -ForegroundColor Cyan
    Write-Host "     @锋 审查一下这个产品方向" -ForegroundColor Cyan
    Write-Host "     @矩 帮我做工程审查" -ForegroundColor Cyan
    Write-Host ""
}

# ---------- Update 模式（更新已安装的维弈阁）----------
function Install-UpdateMode {
    # 自动扫描已安装的 .weiyige 目录
    $weiyigeDir = Join-Path $Target ".weiyige"
    if (-not (Test-Path $weiyigeDir)) {
        # 向上查找（最多 3 层）
        $parent = $Target
        for ($i = 1; $i -le 3; $i++) {
            $parent = Split-Path -Parent $parent
            if (Test-Path (Join-Path $parent ".weiyige")) {
                $weiyigeDir = Join-Path $parent ".weiyige"
                $Target = $parent
                break
            }
        }
    }

    if (-not (Test-Path $weiyigeDir)) {
        Write-Host "❌ 未找到已安装的维弈阁目录（.weiyige\）" -ForegroundColor Red
        Write-Host "  请先安装：.\install.ps1 -Mode full" -ForegroundColor Yellow
        return
    }

    Write-Host "✅ 找到已安装目录：$weiyigeDir" -ForegroundColor Green
    Write-Host ""

    # 更新 Agent 定义文件（覆盖 SOUL/IDENTITY/skills/rules，保留 memory/）
    Write-Host "▶ 更新 Agent 定义文件（保留 memory\）..." -ForegroundColor Yellow
    foreach ($agent in $AGENTS) {
        $agentDir = Join-Path $weiyigeDir $agent
        if (-not (Test-Path $agentDir)) {
            New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
        }

        $updated = $false
        $localAgentDir = Join-Path $SCRIPT_DIR $agent

        # 覆盖 SOUL.md + IDENTITY.md
        foreach ($f in @("IDENTITY.md", "SOUL.md", "SKILLS.md")) {
            $destFile = Join-Path $agentDir $f
            if (Test-Path (Join-Path $localAgentDir $f)) {
                Copy-Item (Join-Path $localAgentDir $f) $destFile -Force
                $updated = $true
            } else {
                if (Fetch-File "$agent/$f" $destFile) { $updated = $true }
            }
        }

        # 覆盖 skills/ 和 rules/（本地）
        if (Test-Path (Join-Path $localAgentDir "skills")) {
            Copy-Item (Join-Path $localAgentDir "skills") $agentDir -Recurse -Force
            $updated = $true
        }
        if (Test-Path (Join-Path $localAgentDir "rules")) {
            Copy-Item (Join-Path $localAgentDir "rules") $agentDir -Recurse -Force
            $updated = $true
        }

        # 远程下载 skills 和 rules
        if (-not (Test-Path $localAgentDir)) {
            $extraFiles = @()
            switch ($agent) {
                "PM_枢"   { $extraFiles = @("skills/prd-template.md") }
                "架构_矩" { $extraFiles = @("rules/eng-review/RULE.mdc") }
                "设计_绘" { $extraFiles = @("rules/design-review/RULE.mdc") }
                "QA_鉴"   { $extraFiles = @("rules/qa/RULE.mdc") }
                "内容_辞" { $extraFiles = @("skills/de-ai-ify.md", "skills/humanizer.md", "skills/copywriting.md") }
                "执事_启" { $extraFiles = @("start.md", "state-template.json", "progress-board-template.md", "exception-matrix.md", "runtime-knowledge.md") }
            }
            foreach ($f in $extraFiles) {
                $destFile = Join-Path $agentDir $f
                $destDir = Split-Path -Parent $destFile
                if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
                if (Fetch-File "$agent/$f" $destFile) { $updated = $true }
            }
        }

        # 确保 memory/ 目录存在（不覆盖内容）
        $memoryDir = Join-Path $agentDir "memory"
        if (-not (Test-Path $memoryDir)) { New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null }

        if ($updated) {
            Write-Host "  ✅ $agent" -ForegroundColor Green
        } else {
            Write-Host "  ℹ️  $agent — 无更新" -ForegroundColor Blue
        }
    }

    # 更新协议文件
    Write-Host ""
    Write-Host "▶ 更新协议文件 ..." -ForegroundColor Yellow
    $protocolFiles = @("PROTOCOL.md", "ROUTER.md", "MEMORY.md", "QUICKSTART.md", "PROJECT-CONFIG-SPEC.md", "PACKAGING.md")
    foreach ($f in $protocolFiles) {
        $destFile = Join-Path $weiyigeDir $f
        $localFile = Join-Path $SCRIPT_DIR $f
        if (Test-Path $localFile) {
            Copy-Item $localFile $destFile -Force
            Write-Host "  ✅ $f" -ForegroundColor Green
        } else {
            if (Fetch-File $f $destFile) {
                Write-Host "  ✅ $f" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️  $f — 下载失败" -ForegroundColor Yellow
            }
        }
    }

    # 更新 Gates 阶段门禁清单
    Write-Host ""
    Write-Host "▶ 更新 Gates 阶段门禁清单 ..." -ForegroundColor Yellow
    $gatesDir = Join-Path $weiyigeDir "gates"
    if (-not (Test-Path $gatesDir)) { New-Item -ItemType Directory -Path $gatesDir -Force | Out-Null }
    $gatesFiles = @("gate-01-ideation.md", "gate-02-requirement.md", "gate-03-design.md", "gate-04-development.md", "gate-05-testing.md", "gate-06-release.md", "review-reminder.md", "two-layer-gate.md", "README.md")
    $gatesSuccess = 0
    foreach ($f in $gatesFiles) {
        $destFile = Join-Path $gatesDir $f
        $localFile = Join-Path $SCRIPT_DIR "gates\$f"
        if (Test-Path $localFile) {
            Copy-Item $localFile $destFile -Force
            $gatesSuccess++
        } else {
            if (Fetch-File "gates/$f" $destFile) { $gatesSuccess++ }
        }
    }
    if ($gatesSuccess -eq $gatesFiles.Count) {
        Write-Host "  ✅ Gates 已更新（$gatesSuccess 个门禁清单）" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Gates 部分更新（$gatesSuccess/$($gatesFiles.Count)）" -ForegroundColor Yellow
    }

    # 更新 Rules 全局规则
    Write-Host ""
    Write-Host "▶ 更新 Rules 全局规则 ..." -ForegroundColor Yellow
    $rulesDir = Join-Path $weiyigeDir "rules"
    if (-not (Test-Path $rulesDir)) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }
    foreach ($f in $RULES_FILES) {
        $destFile = Join-Path $rulesDir $f
        $localFile = Join-Path $SCRIPT_DIR "rules\$f"
        if (Test-Path $localFile) { Copy-Item $localFile $destFile -Force } else { Fetch-File "rules/$f" $destFile | Out-Null }
    }
    Write-Host "  ✅ Rules 已更新" -ForegroundColor Green

    # 更新共享 Skills
    Write-Host ""
    Write-Host "▶ 更新共享 Skills ..." -ForegroundColor Yellow
    $skillsDir = Join-Path $weiyigeDir "skills"
    $cbSkillsDir = Join-Path $Target ".codebuddy\skills"
    New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $cbSkillsDir -Force | Out-Null
    foreach ($skill in $SKILLS_DIRS) {
        $dest = Join-Path $skillsDir $skill
        $cbDest = Join-Path $cbSkillsDir $skill
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        New-Item -ItemType Directory -Path $cbDest -Force | Out-Null
        $localSkillDir = Join-Path $SCRIPT_DIR "skills\$skill"
        if (Test-Path $localSkillDir) {
            Copy-Item "$localSkillDir\*" $dest -Recurse -Force
            Copy-Item "$localSkillDir\*" $cbDest -Recurse -Force
        } else {
            Fetch-File "skills/$skill/SKILL.md" (Join-Path $dest "SKILL.md") | Out-Null
            Copy-Item "$dest\*" $cbDest -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "  ✅ Skills 已同步" -ForegroundColor Green

    # 更新 CodeBuddy Agent 文件
    Write-Host ""
    Write-Host "▶ 更新 CodeBuddy Agent 文件 ..." -ForegroundColor Yellow
    $agentsDir = Join-Path $Target ".codebuddy\agents"
    if (Test-Path $agentsDir) {
        $localAgentsDir = Join-Path $SCRIPT_DIR "agents_for_codebuddy"
        if (Test-Path $localAgentsDir) {
            Copy-Item "$localAgentsDir\*.md" $agentsDir -Force
            $count = (Get-ChildItem "$agentsDir\*.md").Count
            Write-Host "  ✅ 已更新 $count 个 Agent" -ForegroundColor Green
        } else {
            foreach ($name in $AGENT_NAMES) {
                $destFile = Join-Path $agentsDir "$name.md"
                if (Fetch-File "agents_for_codebuddy/$name.md" $destFile) {
                    Write-Host "  ✅ $name" -ForegroundColor Green
                }
            }
        }
    } else {
        Write-Host "  ℹ️  未找到 .codebuddy\agents\，跳过" -ForegroundColor Blue
    }

    # 更新 CLAUDE.md 中的维弈阁配置段落
    Write-Host ""
    Write-Host "▶ 更新配置文件中的维弈阁段落 ..." -ForegroundColor Yellow
    $configPath = Join-Path $Target $CONFIG_FILE
    if (Test-Path $configPath) {
        $content = Get-Content $configPath -Raw -ErrorAction SilentlyContinue
        if ($content -match "维弈阁 AI 团队") {
            # 下载最新维弈阁配置
            $tmpFile = Join-Path $env:TEMP "weiyige-claude-$(Get-Random).md"
            Fetch-File "CLAUDE.md" $tmpFile | Out-Null

            if (Test-Path $tmpFile) {
                # 备份
                $backupPath = "$configPath.weiyige-backup"
                if (Test-Path $backupPath) { $backupPath = "$configPath.weiyige-backup.$(Get-Date -Format 'yyyyMMddHHmmss')" }
                Copy-Item $configPath $backupPath -Force
                Write-Host "  📦 已备份：$CONFIG_FILE → $(Split-Path $backupPath -Leaf)" -ForegroundColor Blue

                # 找到维弈阁段落的起始位置并替换
                $lines = Get-Content $configPath
                $cutLine = -1
                for ($i = 0; $i -lt $lines.Count; $i++) {
                    if ($lines[$i] -match "# 维弈阁 AI 团队") {
                        # 找到前面最近的 --- 分隔线
                        $cutLine = $i
                        for ($j = $i - 1; $j -ge 0; $j--) {
                            if ($lines[$j] -match "^---") {
                                $cutLine = $j
                                break
                            }
                        }
                        break
                    }
                }

                if ($cutLine -ge 0) {
                    # 保留维弈阁段落之前的内容（去掉末尾空行）
                    $beforeLines = $lines[0..($cutLine - 1)] | Where-Object { $_ -ne $null }
                    # 去掉末尾空行
                    while ($beforeLines.Count -gt 0 -and [string]::IsNullOrWhiteSpace($beforeLines[-1])) {
                        $beforeLines = $beforeLines[0..($beforeLines.Count - 2)]
                    }
                    $newContent = ($beforeLines -join "`n") + "`n`n---`n" + (Get-Content $tmpFile -Raw)
                    Set-Content $configPath $newContent -NoNewline
                    Write-Host "  ✅ 维弈阁配置段落已更新" -ForegroundColor Green
                } else {
                    Write-Host "  ℹ️  未找到维弈阁段落标记，跳过" -ForegroundColor Blue
                }
                Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Host "  ℹ️  配置文件中未找到维弈阁段落，跳过" -ForegroundColor Blue
        }
    }

    Write-Host ""
    Write-Host "✅ 更新完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "  更新位置：$weiyigeDir" -ForegroundColor White
    Write-Host "  memory\ 目录已保留，你的偏好和经验教训不会丢失。" -ForegroundColor White
    Write-Host ""
}

# ---------- 执行安装 ----------
switch ($Mode) {
    "claude" {
        Write-Host "▶ 安装配置文件 ..." -ForegroundColor Yellow
        Install-ConfigFile | Out-Null
        Write-Host ""
        Write-Host "  ⚠️  claude 模式不含 Agent 深度定义文件。" -ForegroundColor Yellow
        Write-Host "  如需完整功能，请用 -Mode full 安装。"
        Write-Host ""
        Print-Success
    }
    "full" {
        Install-FullMode
        Write-Host ""
        Print-Success
    }
    "update" {
        Install-UpdateMode
    }
}
