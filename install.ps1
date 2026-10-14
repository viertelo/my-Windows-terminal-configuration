# =============================================================================
# install.ps1
# Windows 终端全家桶 现代化一键自动化安装与部署向导脚本
#
# 【架构特性】：
#   - 优先策略：全套 18 款核心 CLI 工具 + JetBrainsMono Nerd Font 100% 优先采用 WinGet 原生安装
#   - 国内加速：内置中科大 (USTC) 软件源支持，彻底摆脱国内连接 GitHub/海外 CDN 超时困扰
#   - 容错保底：在无 WinGet 或特定组件受阻时，自动切换 Scoop (结合 gh-proxy/gitee 镜像) 兜底
#   - 安全机制：每次部署前强制创建配置快照，配合 Restore-All.ps1 实现一键无损秒级回滚
#   - 支持终端：PowerShell 7+ / WinPS 5.1 / CMD (Clink) / NuShell / Git Bash / MSYS2 / Windows Terminal
# =============================================================================

[CmdletBinding()]
param(
    [switch]$All,                 # 【一键全自动模式】：自动配置中科大源 + 安装全部依赖与字体 + 备份并部署全部终端
    [switch]$ToolsOnly,           # 【仅工具模式】：仅安装底层 CLI 依赖工具与 Nerd Font (不部署终端配置文件)
    [switch]$ConfigOnly,          # 【仅配置模式】：仅部署终端配置文件 (自动创建安全备份，不执行软件下载，适合已有工具者)
    [switch]$SetupWingetMirror,   # 【镜像配置模式】：仅配置 WinGet 中国科学技术大学 (USTC) 高速镜像源 (智能提权)
    [switch]$ResetWingetMirror,   # 【镜像重置模式】：仅重置 WinGet 为微软官方默认 CDN 源
    [switch]$BackupOnly,          # 【备份模式】：仅对当前各终端既有配置与注册表生成快照归档
    [switch]$Restore,             # 【还原回退模式】：从最近一次备份快照一键无损还原所有配置
    [switch]$NoMirror,            # 【跳过镜像开关】：安装依赖工具时强制跳过中科大源配置，直接使用现有源
    [switch]$Help                 # 【帮助信息】：输出命令行参数速查手册
)

# 遇到非致命错误时继续执行后续环节，关键错误由内部 try/catch 自行截获
$ErrorActionPreference = "Continue"

# 动态定位当前脚本根目录（兼顾在子目录或外部直接调用的情形）
$projectRoot = $PSScriptRoot
if (-not $projectRoot) { $projectRoot = Get-Location }

# 引入状态管理与环境初始化公共库
. (Join-Path $projectRoot 'scripts\TerminalSetupCommon.ps1')

# -----------------------------------------------------------------------------
# 1. 核心依赖工具链安装主函数
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    按序安装 Windows 现代化终端所需的全部底层 CLI 生产力工具与 Nerd Font 图标字体。
.DESCRIPTION
    1. 基础环境与网络协议检查 (TLS 1.2 强制启用、编码统一为 UTF-8 无 BOM)；
    2. 检查并配置中科大高速源 (如未指定 -SkipMirrorSetup)；
    3. 调用三级加速逻辑安装 JetBrainsMono Nerd Font；
    4. 批量遍历 18 项核心生产力工具，按【WinGet 优先 -> Scoop 备选】逻辑安装；
    5. 安装 PSReadLine、Terminal-Icons、PSFzf 模块并解除 Mark of the Web。
#>
function Install-AllDependencies {
    param([switch]$SkipMirrorSetup)

    Write-Header "正在检查与安装底层 CLI 工具依赖 (WinGet 全部优先，Scoop 备选)"

    # 初始化运行环境
    Initialize-SetupEnvironment

    # 1. 检查并配置 WinGet 中国科学技术大学 (USTC) 高速镜像源
    if (-not $SkipMirrorSetup) {
        $status = Get-WingetSourceStatus
        if ($status.HasWinget -and -not $status.IsUstcMirror) {
            Set-WingetChinaMirror
        } elseif ($status.IsUstcMirror) {
            Write-Success "WinGet 当前已使用中科大高速镜像源。"
        }
    }

    # 2. 安装 JetBrainsMono Nerd Font 核心图标字体 (解决全终端图标乱码与方块)
    Install-JetBrainsMonoNerdFont

    # 3. 核心生产力工具矩阵 (全量映射 WinGet ID，Scoop 作为容错备选)
    $toolMatrix = @(
        @{ Name = "PowerShell 7";       WingetId = "Microsoft.PowerShell";          ScoopId = "pwsh";        CommandCheck = "pwsh" },
        @{ Name = "Git 版本控制";       WingetId = "Git.Git";                       ScoopId = "git";         CommandCheck = "git" },
        @{ Name = "Starship 统一提示符"; WingetId = "Starship.Starship";             ScoopId = "starship";    CommandCheck = "starship" },
        @{ Name = "Oh My Posh 提示符";  WingetId = "JanDeDobbeleer.OhMyPosh";       ScoopId = "oh-my-posh";  CommandCheck = "oh-my-posh" },
        @{ Name = "Fastfetch 硬件看板"; WingetId = "Fastfetch-cli.Fastfetch";        ScoopId = "fastfetch";   CommandCheck = "fastfetch" },
        @{ Name = "Eza 现代文件列表";   WingetId = "eza-community.eza";             ScoopId = "eza";         CommandCheck = "eza" },
        @{ Name = "Bat 语法高亮浏览";   WingetId = "sharkdp.bat";                   ScoopId = "bat";         CommandCheck = "bat" },
        @{ Name = "Zoxide 智能路径跳转"; WingetId = "ajeetdsouza.zoxide";            ScoopId = "zoxide";      CommandCheck = "zoxide" },
        @{ Name = "Fzf 命令行模糊搜索"; WingetId = "junegunn.fzf";                   ScoopId = "fzf";         CommandCheck = "fzf" },
        @{ Name = "Television 模糊检索"; WingetId = "alexpasmantier.television";     ScoopId = "television";  CommandCheck = "tv" },
        @{ Name = "Tre 编号彩色目录树"; WingetId = "duan.tre";                      ScoopId = "tre";         CommandCheck = "tre" },
        @{ Name = "Clink CMD补全增强";  WingetId = "chrisant996.Clink";             ScoopId = "clink";       CommandCheck = "clink" },
        @{ Name = "NuShell 现代化Shell";WingetId = "Nushell.Nushell";               ScoopId = "nushell";     CommandCheck = "nu" },
        @{ Name = "Yazi 终端文件管理";   WingetId = "sxyazi.yazi";                   ScoopId = "yazi";        CommandCheck = "yazi" },
        @{ Name = "LazyGit 键盘Git面板"; WingetId = "JesseDuffield.lazygit";         ScoopId = "lazygit";     CommandCheck = "lazygit" },
        @{ Name = "Neovim 现代编辑器";   WingetId = "Neovim.Neovim";                 ScoopId = "neovim";      CommandCheck = "nvim" },
        @{ Name = "Ripgrep 极速代码检索";WingetId = "BurntSushi.ripgrep.MSVC";       ScoopId = "ripgrep";     CommandCheck = "rg" },
        @{ Name = "Fd 极速文件搜索";     WingetId = "sharkdp.fd";                    ScoopId = "fd";          CommandCheck = "fd" }
    )

    foreach ($tool in $toolMatrix) {
        Install-AppWithWingetScoopFallback -Name $tool.Name -WingetId $tool.WingetId -ScoopId $tool.ScoopId -CommandCheck $tool.CommandCheck
    }

    # 4. 安装 PowerShell Gallery 必备增强模块插件
    Install-PowerShellModules

    Write-Success "全部底层 CLI 生产力工具链就绪！"
}

# -----------------------------------------------------------------------------
# 2. 全终端配置文件落地与系统级部署
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    将仓库中预调优的各终端配置文件安全同步写入至系统对应目录中。
.DESCRIPTION
    部署覆盖范围：
    1. Windows Terminal: 复制 settings.json 至 Stable 与 Preview 本地状态目录；
    2. PowerShell Profile: 部署至 PowerShell 7+ 与 Windows PowerShell 5.1；
    3. CMD & Clink: 写入 autorun.cmd (无 BOM UTF-8 + CRLF) 并挂载 AutoRun 注册表；
    4. NuShell: 部署 config.nu, env.nu 与 vendor 自动加载模块；
    5. Git Bash & MSYS2: 部署 .bashrc, .bash_profile 与 msys2.bashrc；
    6. Starship: 部署跨终端统一配置文件 starship.toml；
    7. Fastfetch: 部署二次元硬件看板与 ASCII 字符画；
    8. Yazi: 仅同步 *.toml 核心配置文件至 %APPDATA%\yazi\config。
#>
function Deploy-Configurations {
    Write-Header "开始部署各终端配置文件"

    # [1] Windows Terminal 核心配置部署
    Write-Info "部署 Windows Terminal 配置..."
    $wtSrc = Join-Path $projectRoot "Terminal\settings.json"
    if (Test-Path $wtSrc) {
        $wtDests = @(
            "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
            "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
        )
        foreach ($wtDest in $wtDests) {
            $wtDir = Split-Path $wtDest
            if (Test-Path $wtDir) {
                Copy-Item $wtSrc $wtDest -Force
                Write-Success "Windows Terminal 配置文件已写入: $wtDest"
            }
        }
    }

    # [2] PowerShell Profile (同时兼顾 PowerShell 7+ 与 Windows PowerShell 5.1)
    Write-Info "部署 PowerShell Profile (PowerShell 7+ 与 Windows PowerShell 5.1)..."
    $psSrc = Join-Path $projectRoot "PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1"
    if (Test-Path $psSrc) {
        $docs = Get-TerminalDocumentsPath
        $ps7Target   = Join-Path $docs "PowerShell\Microsoft.PowerShell_profile.ps1"
        $winpsTarget = Join-Path $docs "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

        foreach ($pTarget in @($ps7Target, $winpsTarget)) {
            $pDir = Split-Path $pTarget
            if (-not (Test-Path $pDir)) { New-Item -ItemType Directory -Path $pDir -Force | Out-Null }
            Copy-Item $psSrc $pTarget -Force
            Write-Success "PowerShell Profile 已更新: $pTarget"
        }

        # 兼容当前环境下的 $PROFILE 路径
        if ($PROFILE -and ($PROFILE -ne $ps7Target) -and ($PROFILE -ne $winpsTarget)) {
            $profDir = Split-Path $PROFILE
            if (-not (Test-Path $profDir)) { New-Item -ItemType Directory -Path $profDir -Force | Out-Null }
            Copy-Item $psSrc $PROFILE -Force
            Write-Success "PowerShell Profile 已同步写入当前环境: $PROFILE"
        }
    }

    # [3] CMD 批处理启动脚本与 Clink 引擎补全 (严格保证无 BOM UTF-8 + CRLF 换行)
    Write-Info "部署 CMD 启动脚本与 Clink 引擎补全..."
    $cmdSrc = Join-Path $projectRoot "CMD\autorun.cmd"
    $cmdDest = "$env:USERPROFILE\.config\cmd\autorun.cmd"
    if (Test-Path $cmdSrc) {
        $cmdDir = Split-Path $cmdDest
        if (-not (Test-Path $cmdDir)) { New-Item -ItemType Directory -Path $cmdDir -Force | Out-Null }

        # 确保 CRLF 格式且绝对无 BOM 写入，杜绝 cmd.exe 报 锘緻echo off 语法断裂错误
        $cmdContent = [IO.File]::ReadAllText($cmdSrc)
        $crlfContent = ($cmdContent -replace "`r?`n", "`r`n")
        [IO.File]::WriteAllText($cmdDest, $crlfContent, [System.Text.UTF8Encoding]::new($false))

        # 注册表写入 AutoRun 启动项 (使用 @ 抑制调用回显)
        reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "@if exist `"%USERPROFILE%\.config\cmd\autorun.cmd`" call `"%USERPROFILE%\.config\cmd\autorun.cmd`"" /f | Out-Null
        Write-Success "CMD autorun.cmd 已写入并注册至系统 AutoRun 注册表！"
    }

    # 部署 Clink Lua 脚本与设置
    $clinkSrc = Join-Path $projectRoot "CMD\clink"
    $clinkDest = "$env:LOCALAPPDATA\clink"
    if (Test-Path $clinkSrc) {
        if (-not (Test-Path $clinkDest)) { New-Item -ItemType Directory -Path $clinkDest -Force | Out-Null }
        Copy-Item (Join-Path $clinkSrc "*") $clinkDest -Recurse -Force
        Write-Success "Clink 补全与提示符脚本已更新！"
    }

    # [4] NuShell 结构化数据管道终端配置部署
    Write-Info "部署 NuShell 配置..."
    $nuSrc = Join-Path $projectRoot "Nushell"
    $nuDest = "$env:APPDATA\nushell"
    if (Test-Path $nuSrc) {
        if (-not (Test-Path $nuDest)) { New-Item -ItemType Directory -Path $nuDest -Force | Out-Null }
        if (Test-Path (Join-Path $nuSrc "config.nu")) { Copy-Item (Join-Path $nuSrc "config.nu") "$nuDest\config.nu" -Force }
        if (Test-Path (Join-Path $nuSrc "env.nu"))    { Copy-Item (Join-Path $nuSrc "env.nu") "$nuDest\env.nu" -Force }
        if (Test-Path (Join-Path $nuSrc "vendor"))    { Copy-Item (Join-Path $nuSrc "vendor") $nuDest -Recurse -Force }
        Write-Success "NuShell 配置文件与 autoload 模块已就绪！"
    }

    # [5] Git Bash & MSYS2 终端配置部署
    Write-Info "部署 Git Bash 与 MSYS2 配置..."
    $bashRcSrc   = Join-Path $projectRoot "Bash\.bashrc"
    $bashProfSrc = Join-Path $projectRoot "Bash\.bash_profile"
    if (Test-Path $bashRcSrc)   { Copy-Item $bashRcSrc "$env:USERPROFILE\.bashrc" -Force; Write-Success "Git Bash .bashrc 已同步！" }
    if (Test-Path $bashProfSrc) { Copy-Item $bashProfSrc "$env:USERPROFILE\.bash_profile" -Force; Write-Success "Git Bash .bash_profile 已同步！" }

    # 同步 MSYS2 主目录 (若本地存在 MSYS2)
    $msysHome = "C:\msys64\home\$env:USERNAME"
    $msysSrc = Join-Path $projectRoot "Bash\msys2.bashrc"
    if ((Test-Path $msysHome) -and (Test-Path $msysSrc)) {
        Copy-Item $msysSrc "$msysHome\.bashrc" -Force
        Write-Success "MSYS2 .bashrc 已同步！"
    }

    # [6] Starship 跨终端统一提示符配置部署
    Write-Info "部署 Starship 跨终端统一提示符配置..."
    $starSrc = Join-Path $projectRoot "Starship\starship.toml"
    $starDest = "$env:USERPROFILE\.config\starship.toml"
    if (Test-Path $starSrc) {
        $starDir = Split-Path $starDest
        if (-not (Test-Path $starDir)) { New-Item -ItemType Directory -Path $starDir -Force | Out-Null }
        Copy-Item $starSrc $starDest -Force
        Write-Success "Starship 配置文件已写入: $starDest"
    }

    # [7] Fastfetch 二次元硬件看板与 ASCII 字符画部署
    Write-Info "部署 Fastfetch 看板..."
    $ffSrc = Join-Path $projectRoot "Fastfetch"
    $ffDest = "$env:USERPROFILE\.config\fastfetch"
    if (Test-Path $ffSrc) {
        if (-not (Test-Path $ffDest)) { New-Item -ItemType Directory -Path $ffDest -Force | Out-Null }
        Copy-Item (Join-Path $ffSrc "*") $ffDest -Recurse -Force
        Write-Success "Fastfetch 看板配置与 ASCII 字符画已更新！"
    }

    # [8] Yazi 终端文件管理器配置部署 (精确过滤仅复制 *.toml)
    Write-Info "部署 Yazi 终端文件管理器配置..."
    $yaziSrc = Join-Path $projectRoot "yazi"
    $yaziDest = "$env:APPDATA\yazi\config"
    if (Test-Path $yaziSrc) {
        if (-not (Test-Path $yaziDest)) { New-Item -ItemType Directory -Path $yaziDest -Force | Out-Null }
        Get-ChildItem -Path $yaziSrc -Filter "*.toml" | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $yaziDest $_.Name) -Force
        }
        Write-Success "Yazi 配置文件 (*.toml) 已同步！"
    }

    Write-Header "🎉 全部终端配置部署完毕！"
    Write-Host ""
    Write-Host "  👉 重启 Windows Terminal 或打开新标签页，即可立即体验全新终端工作流！" -ForegroundColor Green
    Write-Host "  👉 如遇任何问题，可随时运行 .\Restore-All.ps1 一键无损回退。" -ForegroundColor Cyan
    Write-Host ""
}

# -----------------------------------------------------------------------------
# 3. 命令行参数分派执行逻辑
# -----------------------------------------------------------------------------

if ($Help) {
    Write-Host @"
Windows 终端全家桶 现代化一键安装与部署脚本 (install.ps1)

用法:
  .\install.ps1                   进入交互式向导菜单 (默认推荐)
  .\install.ps1 -All              全自动安装 (配置WinGet源 + 安装依赖及字体 + 备份并部署全部终端)
  .\install.ps1 -ToolsOnly        仅安装底层 CLI 依赖工具与 Nerd Font (不改动终端配置)
  .\install.ps1 -ConfigOnly       仅部署终端配置文件 (自动备份，不下载依赖)
  .\install.ps1 -SetupWingetMirror 仅配置 WinGet 中科大 (USTC) 高速镜像源
  .\install.ps1 -ResetWingetMirror 仅重置 WinGet 为微软官方源
  .\install.ps1 -BackupOnly       仅备份当前终端配置并生成快照
  .\install.ps1 -Restore          从最近的备份快照一键回退恢复所有配置
  .\install.ps1 -NoMirror         安装依赖时不切换中科大镜像源，使用官方默认源
"@
    exit 0
}

# 优先响应一键回退
if ($Restore) {
    Restore-TerminalSnapshot
    exit 0
}

# 响应仅备份
if ($BackupOnly) {
    Backup-AllTerminalConfigurations
    exit 0
}

# 响应仅配置中科大镜像
if ($SetupWingetMirror) {
    Set-WingetChinaMirror
    exit 0
}

# 响应仅重置微软官方源
if ($ResetWingetMirror) {
    Reset-WingetOfficialMirror
    exit 0
}

# 响应仅安装工具
if ($ToolsOnly) {
    Install-AllDependencies -SkipMirrorSetup:$NoMirror
    exit 0
}

# 响应仅部署配置
if ($ConfigOnly) {
    Backup-AllTerminalConfigurations
    Deploy-Configurations
    exit 0
}

# 响应一键全量安装
if ($All) {
    Backup-AllTerminalConfigurations
    Install-AllDependencies -SkipMirrorSetup:$NoMirror
    Deploy-Configurations
    exit 0
}

# -----------------------------------------------------------------------------
# 4. 交互式菜单模式 (用户未输入任何开关参数时的默认友好界面)
# -----------------------------------------------------------------------------

Clear-Host
Write-Header "Windows 终端全家桶 交互式部署向导"
Write-Host "  [架构说明] 优先使用 WinGet 包管理器并支持中科大 (USTC) 高速源，Scoop 作为海外容错备选。" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  1) 🚀 全自动一键部署 (配置WinGet中科大高速源 + WinGet极速安装依赖 + 备份并部署全部终端) [回车默认]" -ForegroundColor Green
Write-Host "  2) ⚡ 快速安装依赖与字体 (仅使用 WinGet/Scoop 安装核心工具与 Nerd Font)" -ForegroundColor Cyan
Write-Host "  3) 📁 仅部署终端配置文件 (自动安全备份，不下载依赖，适合已有工具者)" -ForegroundColor Cyan
Write-Host "  4) 🇨🇳 配置/切换 WinGet 中国高速下载源 (中科大 USTC 镜像)" -ForegroundColor Yellow
Write-Host "  5) 🔄 重置 WinGet 为微软官方默认源" -ForegroundColor Yellow
Write-Host "  6) 💾 立即备份当前所有终端配置" -ForegroundColor Magenta
Write-Host "  7) ⏪ 从最近的快照一键回退/还原配置" -ForegroundColor Magenta
Write-Host "  8) 🚪 退出" -ForegroundColor Gray
Write-Host ""
$choice = Read-Host "请输入数字选项 [1-8] (回车默认 1)"

switch ($choice.Trim()) {
    "2" {
        Install-AllDependencies
    }
    "3" {
        Backup-AllTerminalConfigurations
        Deploy-Configurations
    }
    "4" {
        Set-WingetChinaMirror
    }
    "5" {
        Reset-WingetOfficialMirror
    }
    "6" {
        Backup-AllTerminalConfigurations
    }
    "7" {
        Restore-TerminalSnapshot
    }
    "8" {
        Write-Host "已安全退出。" -ForegroundColor Gray
        exit 0
    }
    Default {
        # 默认执行：备份现有配置 -> 安装依赖与中科大源 -> 部署终端
        Backup-AllTerminalConfigurations
        Install-AllDependencies
        Deploy-Configurations
    }
}
