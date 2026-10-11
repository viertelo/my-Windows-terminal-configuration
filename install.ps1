# =============================================================================
# Windows 终端全家桶一键自动化安装与部署脚本 (install.ps1)
# 支持 PowerShell 7+ / CMD / NuShell / Git Bash / MSYS2 / Windows Terminal
# =============================================================================

[CmdletBinding()]
param(
    [switch]$All,          # 一键安装所有依赖工具 + 部署所有终端配置
    [switch]$ConfigOnly,   # 仅部署配置文件（不执行 Scoop 安装）
    [switch]$BackupOnly,   # 仅执行当前配置备份
    [switch]$Help          # 查看帮助
)

$ErrorActionPreference = "Continue"

# 1. 颜色与文本辅助函数
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Yellow
    Write-Host "========================================================================" -ForegroundColor Cyan
}

function Write-Success { param([string]$Text) Write-Host "  [✓] $Text" -ForegroundColor Green }
function Write-Info    { param([string]$Text) Write-Host "  [i] $Text" -ForegroundColor Cyan }
function Write-Warn    { param([string]$Text) Write-Host "  [!] $Text" -ForegroundColor Yellow }
function Write-Err     { param([string]$Text) Write-Host "  [✗] $Text" -ForegroundColor Red }

# 2. 备份函数
function Backup-CurrentConfigs {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "$env:USERPROFILE\.terminal_config_backup_$timestamp"
    Write-Header "正在创建本地配置安全备份"
    Write-Info "备份目标路径: $backupDir"

    $targets = @(
        @{ Name = "PowerShellProfile"; Path = $PROFILE },
        @{ Name = "WindowsTerminal"; Path = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" },
        @{ Name = "CmdAutorun"; Path = "$env:USERPROFILE\.config\cmd\autorun.cmd" },
        @{ Name = "ClinkDir"; Path = "$env:LOCALAPPDATA\clink" },
        @{ Name = "NushellDir"; Path = "$env:APPDATA\nushell" },
        @{ Name = "GitBashRc"; Path = "$env:USERPROFILE\.bashrc" },
        @{ Name = "GitBashProfile"; Path = "$env:USERPROFILE\.bash_profile" },
        @{ Name = "StarshipConfig"; Path = "$env:USERPROFILE\.config\starship.toml" },
        @{ Name = "FastfetchDir"; Path = "$env:USERPROFILE\.config\fastfetch" },
        @{ Name = "YaziDir"; Path = "$env:APPDATA\yazi\config" }
    )

    $backedUpCount = 0
    foreach ($t in $targets) {
        if (Test-Path $t.Path) {
            $dest = Join-Path $backupDir $t.Name
            New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
            Copy-Item -Path $t.Path -Destination $dest -Recurse -Force
            $backedUpCount++
        }
    }
    Write-Success "成功归档了 $backedUpCount 项现有配置文件到备份目录！"
}

# 3. 安装依赖工具 (Scoop)
function Install-Dependencies {
    Write-Header "正在检查与安装底层 CLI 工具依赖 (Scoop)"

    # 检查 Scoop 是否安装
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Info "未检测到 Scoop 包管理器，正在执行安装..."
        try {
            Invoke-RestMethod -Uri get.scoop.sh | Invoke-Expression
            Write-Success "Scoop 安装成功！"
        } catch {
            Write-Err "Scoop 自动安装失败，请手动运行: irm get.scoop.sh | iex"
            return
        }
    } else {
        Write-Success "Scoop 包管理器已就绪。"
    }

    # 添加必要的 bucket
    Write-Info "正在配置 Scoop 扩展源 (extras, nerd-fonts)..."
    scoop bucket add extras 2>$null
    scoop bucket add nerd-fonts 2>$null

    # 安装字体
    Write-Info "正在安装 JetBrainsMono-NF 图标字体..."
    scoop install JetBrainsMono-NF 2>$null

    # 安装核心工具链
    $tools = @("git", "starship", "oh-my-posh", "fastfetch", "eza", "bat", "zoxide", "fzf", "television", "tre", "clink", "nushell", "yazi", "lazygit", "neovim")
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            Write-Info "正在安装 $tool..."
            scoop install $tool
        } else {
            Write-Success "$tool 已安装。"
        }
    }

    # 安装 PowerShell 模块
    Write-Info "正在安装 PowerShell 增强模块 (PSReadLine, Terminal-Icons, PSFzf)..."
    Install-Module PSReadLine, Terminal-Icons, PSFzf -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction SilentlyContinue
    Write-Success "PowerShell 模块已就绪。"
}

# 4. 部署配置文件
function Deploy-Configurations {
    $scriptRoot = $PSScriptRoot
    if (-not $scriptRoot) { $scriptRoot = Get-Location }

    Write-Header "开始部署各终端配置文件"

    # [1] Windows Terminal
    Write-Info "部署 Windows Terminal 配置..."
    $wtDest = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $wtSrc = Join-Path $scriptRoot "Terminal\settings.json"
    if (Test-Path $wtSrc) {
        if (Test-Path (Split-Path $wtDest)) {
            Copy-Item $wtSrc $wtDest -Force
            Write-Success "Windows Terminal settings.json 已更新！"
        } else {
            Write-Warn "未找到 Windows Terminal 默认数据目录，可能未安装或为便携版。"
        }
    }

    # [2] PowerShell Profile
    Write-Info "部署 PowerShell Profile..."
    $psSrc = Join-Path $scriptRoot "PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1"
    if (Test-Path $psSrc) {
        $psDir = Split-Path $PROFILE
        if (-not (Test-Path $psDir)) { New-Item -ItemType Directory -Path $psDir -Force | Out-Null }
        Copy-Item $psSrc $PROFILE -Force
        Write-Success "PowerShell Profile 已更新 ($PROFILE)！"
    }

    # [3] CMD & Clink
    Write-Info "部署 CMD 启动脚本与 Clink 引擎..."
    $cmdSrc = Join-Path $scriptRoot "CMD\autorun.cmd"
    $cmdDest = "$env:USERPROFILE\.config\cmd\autorun.cmd"
    if (Test-Path $cmdSrc) {
        $cmdDir = Split-Path $cmdDest
        if (-not (Test-Path $cmdDir)) { New-Item -ItemType Directory -Path $cmdDir -Force | Out-Null }
        
        # 确保 CRLF 格式写入
        $cmdContent = [IO.File]::ReadAllText($cmdSrc)
        $crlfContent = ($cmdContent -replace "`r?`n", "`r`n")
        [IO.File]::WriteAllText($cmdDest, $crlfContent, [Text.Encoding]::UTF8)

        # 写入注册表 AutoRun
        reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%USERPROFILE%\.config\cmd\autorun.cmd" /f | Out-Null
        Write-Success "CMD autorun.cmd 已更新并注册为系统 AutoRun！"
    }

    $clinkSrc = Join-Path $scriptRoot "CMD\clink"
    $clinkDest = "$env:LOCALAPPDATA\clink"
    if (Test-Path $clinkSrc) {
        if (-not (Test-Path $clinkDest)) { New-Item -ItemType Directory -Path $clinkDest -Force | Out-Null }
        Copy-Item (Join-Path $clinkSrc "*") $clinkDest -Force
        Write-Success "Clink 补全与提示符脚本已更新！"
    }

    # [4] NuShell
    Write-Info "部署 NuShell 配置..."
    $nuSrc = Join-Path $scriptRoot "Nushell"
    $nuDest = "$env:APPDATA\nushell"
    if (Test-Path $nuSrc) {
        if (-not (Test-Path $nuDest)) { New-Item -ItemType Directory -Path $nuDest -Force | Out-Null }
        Copy-Item (Join-Path $nuSrc "config.nu") "$nuDest\config.nu" -Force
        Copy-Item (Join-Path $nuSrc "env.nu") "$nuDest\env.nu" -Force
        if (Test-Path (Join-Path $nuSrc "vendor")) {
            Copy-Item (Join-Path $nuSrc "vendor") $nuDest -Recurse -Force
        }
        Write-Success "NuShell 配置文件与 autoload 模块已更新！"
    }

    # [5] Git Bash & MSYS2
    Write-Info "部署 Git Bash 与 MSYS2 配置..."
    $bashRcSrc = Join-Path $scriptRoot "Bash\.bashrc"
    $bashProfSrc = Join-Path $scriptRoot "Bash\.bash_profile"
    if (Test-Path $bashRcSrc) {
        Copy-Item $bashRcSrc "$env:USERPROFILE\.bashrc" -Force
        Copy-Item $bashProfSrc "$env:USERPROFILE\.bash_profile" -Force
        Write-Success "Git Bash (.bashrc & .bash_profile) 已更新！"
    }
    $msysHome = "C:\msys64\home\$env:USERNAME"
    $msysSrc = Join-Path $scriptRoot "Bash\msys2.bashrc"
    if ((Test-Path $msysHome) -and (Test-Path $msysSrc)) {
        Copy-Item $msysSrc "$msysHome\.bashrc" -Force
        Write-Success "MSYS2 .bashrc 已同步！"
    }

    # [6] Starship
    Write-Info "部署 Starship 跨终端统一提示符配置..."
    $starSrc = Join-Path $scriptRoot "Starship\starship.toml"
    $starDest = "$env:USERPROFILE\.config\starship.toml"
    if (Test-Path $starSrc) {
        $starDir = Split-Path $starDest
        if (-not (Test-Path $starDir)) { New-Item -ItemType Directory -Path $starDir -Force | Out-Null }
        Copy-Item $starSrc $starDest -Force
        Write-Success "Starship 配置已更新！"
    }

    # [7] Fastfetch
    Write-Info "部署 Fastfetch 动漫硬件看板..."
    $ffSrc = Join-Path $scriptRoot "Fastfetch"
    $ffDest = "$env:USERPROFILE\.config\fastfetch"
    if (Test-Path $ffSrc) {
        if (-not (Test-Path $ffDest)) { New-Item -ItemType Directory -Path $ffDest -Force | Out-Null }
        Copy-Item (Join-Path $ffSrc "*") $ffDest -Recurse -Force
        Write-Success "Fastfetch 看板配置与 ASCII 图已就绪！"
    }

    # [8] Yazi
    Write-Info "部署 Yazi 终端文件管理器..."
    $yaziSrc = Join-Path $scriptRoot "Yazi"
    $yaziDest = "$env:APPDATA\yazi\config"
    if (Test-Path $yaziSrc) {
        if (-not (Test-Path $yaziDest)) { New-Item -ItemType Directory -Path $yaziDest -Force | Out-Null }
        Copy-Item (Join-Path $yaziSrc "*") $yaziDest -Recurse -Force
        Write-Success "Yazi 配置文件已更新！"
    }

    Write-Header "🎉 全部终端配置部署完毕！"
    Write-Host ""
    Write-Host "  👉 您可以重新打开 Windows Terminal 体验全新的终端工作流！" -ForegroundColor Green
    Write-Host "  👉 详细使用手册与快捷键请查阅 INSTALL_GUIDE.md 与 TERMINAL_AUDIT_REPORT.md" -ForegroundColor Cyan
    Write-Host ""
}

# 5. 主流程逻辑
if ($Help) {
    Write-Host "Windows 终端全家桶安装与部署脚本"
    Write-Host "用法:"
    Write-Host "  .\install.ps1             交互式菜单模式"
    Write-Host "  .\install.ps1 -All        全自动模式 (安装 Scoop 依赖 + 部署全部配置)"
    Write-Host "  .\install.ps1 -ConfigOnly 仅部署配置文件 (自动备份，不安装依赖)"
    Write-Host "  .\install.ps1 -BackupOnly 仅执行备份"
    exit 0
}

if ($BackupOnly) {
    Backup-CurrentConfigs
    exit 0
}

if ($All) {
    Backup-CurrentConfigs
    Install-Dependencies
    Deploy-Configurations
    exit 0
}

if ($ConfigOnly) {
    Backup-CurrentConfigs
    Deploy-Configurations
    exit 0
}

# 交互式菜单模式
Clear-Host
Write-Header "Windows 终端全家桶 交互式部署向导"
Write-Host "  1) 🚀 全自动一键部署 (安装 Scoop 依赖工具 + 备份并部署全部终端配置)" -ForegroundColor Green
Write-Host "  2) 📁 仅部署配置文件 (自动安全备份旧配置，适合已有工具的用户)" -ForegroundColor Cyan
Write-Host "  3) 💾 仅执行本地配置备份归档" -ForegroundColor Yellow
Write-Host "  4) 🚪 退出" -ForegroundColor Gray
Write-Host ""
$choice = Read-Host "请输入数字选项 (默认 1)"

switch ($choice) {
    "2" {
        Backup-CurrentConfigs
        Deploy-Configurations
    }
    "3" {
        Backup-CurrentConfigs
    }
    "4" {
        Write-Host "已退出。" -ForegroundColor Gray
        exit 0
    }
    Default {
        Backup-CurrentConfigs
        Install-Dependencies
        Deploy-Configurations
    }
}
