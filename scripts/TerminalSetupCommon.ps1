# =============================================================================
# TerminalSetupCommon.ps1
# 终端安装与环境准备公共函数库 (PowerShell 5.1 & 7+ 全兼容)
#
# 【核心功能】：
#   1. 系统运行环境与编码初始化 (TLS 1.2 强制启用、UTF-8 控制台无 BOM、执行策略检查)
#   2. 环境变量动态刷新 (合并 Machine/User PATH 并追加 WinGet/WindowsApps/Scoop 目录)
#   3. WinGet 管理器状态检测与中国科学技术大学 (USTC) 高速镜像源配置 (智能申请 UAC 提权)
#   4. WinGet 优先安装引擎 (自动检测现有命令 -> WinGet 静默安装 -> 退出码容错)
#   5. Scoop 备选方案 (搭载国内 gh-proxy / gitee 加速源，解决国内直连 GitHub 超时问题)
#   6. JetBrainsMono Nerd Font 3 级渐进式安装 (WinGet -> 镜像直连免重启系统级注册 -> Scoop)
#   7. PowerShell 常用模块自动化安装与 Mark of the Web 解锁 (PSReadLine, Terminal-Icons, PSFzf)
# =============================================================================

# 引入状态管理与快照回退底层库
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'TerminalState.ps1')

# -----------------------------------------------------------------------------
# 1. 控制台彩色日志输出辅助函数
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    在控制台打印带有双横线装饰的模块标题横幅。
#>
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Yellow
    Write-Host "========================================================================" -ForegroundColor Cyan
}

<#
.SYNOPSIS
    打印带有绿色的操作成功标记行。
#>
function Write-Success {
    param([string]$Text)
    Write-Host "  [✓] $Text" -ForegroundColor Green
}

<#
.SYNOPSIS
    打印带有青色的普通信息提示行。
#>
function Write-Info {
    param([string]$Text)
    Write-Host "  [i] $Text" -ForegroundColor Cyan
}

<#
.SYNOPSIS
    打印带有黄色的警告提示行。
#>
function Write-Warn {
    param([string]$Text)
    Write-Host "  [!] $Text" -ForegroundColor Yellow
}

<#
.SYNOPSIS
    打印带有红色的错误提示行。
#>
function Write-Err {
    param([string]$Text)
    Write-Host "  [✗] $Text" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# 2. 基础运行环境与网络协议初始化
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    初始化 PowerShell 运行环境，消除常见网络协议限制与脚本执行权限阻碍。
.DESCRIPTION
    1. 强制启用 TLS 1.2（兼容 Windows 10/11 与旧版 .NET 在国内连接 HTTPS 镜像源）。
    2. 设置控制台输入输出编码为 UTF-8 无 BOM（避免中文与特殊字符乱码）。
    3. 检查当前用户执行策略，如受限自动配置为 RemoteSigned。
    4. 自动刷新当前会话的 PATH 环境变量。
#>
function Initialize-SetupEnvironment {
    # 强制启用 TLS 1.2，确保能够安全访问国内各大开源镜像站 (如 USTC、Gitee 等)
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    } catch {
        Write-Verbose "TLS 1.2 初始化提示: $_"
    }

    # 设置控制台输出编码为 UTF-8（不带 BOM 头），防止批处理和脚本输出乱码
    try {
        [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    } catch {
        Write-Verbose "控制台编码初始化提示: $_"
    }

    # 自动检查并解除脚本执行策略限制 (仅对当前用户生效，无需管理员权限)
    try {
        $policy = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue
        if ($policy -in @('Restricted', 'Undefined')) {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
            Write-Success "当前用户执行策略已配置: RemoteSigned"
        }
    } catch {
        Write-Verbose "执行策略检测提示: $_"
    }

    # 刷新当前会话 PATH
    Refresh-SessionPath
}

# -----------------------------------------------------------------------------
# 3. 环境变量与路径动态刷新
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    动态读取 Windows 系统环境与用户环境变量，重新拼装当前会话的 $env:PATH。
.DESCRIPTION
    解决新安装的软件（如通过 WinGet 或 Scoop 安装的 CLI 工具）在当前 PowerShell
    会话中无法立即找到命令的问题。自动确保以下目录包含在 PATH 中：
    - %LOCALAPPDATA%\Microsoft\WinGet\Links (WinGet 便携版软链接路径)
    - %LOCALAPPDATA%\Microsoft\WindowsApps (winget.exe 真实入口路径)
    - %USERPROFILE%\scoop\shims (Scoop 启动垫片路径)
#>
function Refresh-SessionPath {
    # 读取注册表中的 Machine (全局系统) 和 User (当前用户) PATH 变量
    $machinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath    = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $combined    = "$machinePath;$userPath"

    # 追加 WinGet 命令行便携软链接目录 (如 yazi, fd 等常放置于此)
    $wingetLinks = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links'
    if (Test-Path $wingetLinks) {
        $combined = "$combined;$wingetLinks"
    }

    # 追加 WindowsApps 目录 (winget.exe 及其它商店应用入口)
    $windowsApps = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'
    if (Test-Path $windowsApps) {
        $combined = "$combined;$windowsApps"
    }

    # 追加 Scoop 垫片目录 (如果用户本地存在 Scoop)
    $scoopShims = Join-Path $env:USERPROFILE 'scoop\shims'
    if (Test-Path $scoopShims) {
        $combined = "$combined;$scoopShims"
    }

    # 将合并后的路径赋予当前进程环境变量
    $env:PATH = $combined
}

# -----------------------------------------------------------------------------
# 4. 管理员权限状态检测
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    检测当前 PowerShell 进程是否以管理员权限 (Administrator) 运行。
.OUTPUTS
    [bool] $true 表示具有管理员权限，反之返回 $false。
#>
function Test-IsAdmin {
    try {
        $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]$identity
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

# -----------------------------------------------------------------------------
# 5. WinGet 软件源状态探测与中科大 (USTC) 高速源配置
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    探测当前系统中 WinGet 的安装状态及目前生效的软件源地址。
.OUTPUTS
    [PSCustomObject] 包含 HasWinget(布尔值)、CurrentSource(源输出文本)、IsUstcMirror(是否已配置中科大源)。
#>
function Get-WingetSourceStatus {
    # 尝试在 PATH 中定位 winget
    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCmd) {
        # 若未在 PATH 中，尝试去默认 WindowsApps 目录寻找并临时注入
        $windowsApps = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'
        if (Test-Path (Join-Path $windowsApps 'winget.exe')) {
            $env:PATH = "$($env:PATH);$windowsApps"
            $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
        }
    }

    # 若系统确实未安装 WinGet
    if (-not $wingetCmd) {
        return [pscustomobject]@{
            HasWinget     = $false
            CurrentSource = ''
            IsUstcMirror  = $false
        }
    }

    # 查询当前启用的软件源列表
    $sourceOutput = & $wingetCmd.Source source list 2>&1 | Out-String
    $isUstc = ($sourceOutput -match 'mirrors\.ustc\.edu\.cn/winget-source')

    return [pscustomobject]@{
        HasWinget     = $true
        CurrentSource = $sourceOutput
        IsUstcMirror  = $isUstc
    }
}

<#
.SYNOPSIS
    将 WinGet 官方社区源切换为中国科学技术大学 (USTC) 开源软件镜像源。
.DESCRIPTION
    由于修改 WinGet 系统全局源需要管理员权限：
    - 若当前已是管理员，直接静默切换；
    - 若当前为普通用户，自动提示并弹出 UAC 提权窗口以管理员身份完成切换；
    - 用户若取消提权，则保留现有官方源，绝不阻断后续安装流程。
.PARAMETER NonInteractive
    非交互模式开关，若为 $true 且非管理员，则跳过提权弹窗，直接继续使用当前源。
#>
function Set-WingetChinaMirror {
    param([switch]$NonInteractive)

    $status = Get-WingetSourceStatus
    if (-not $status.HasWinget) {
        Write-Warn "当前系统未检测到 WinGet 包管理器，跳过镜像源配置。"
        return $false
    }

    if ($status.IsUstcMirror) {
        Write-Success "WinGet 当前已生效中科大 (USTC) 高速镜像源，无需重复配置！"
        return $true
    }

    Write-Info "正在配置 WinGet 为中科大 (USTC) 高速镜像源..."
    Write-Info "说明：WinGet 全局软件源配置属于系统级操作，需要管理员权限。"

    if (Test-IsAdmin) {
        # 当前已具备管理员权限，直接执行切换
        try {
            & winget source remove winget 2>$null | Out-Null
            & winget source add winget https://mirrors.ustc.edu.cn/winget-source --trust-level trusted 2>&1 | Out-Null
            & winget source update winget 2>&1 | Out-Null
            Write-Success "WinGet 中科大高速镜像源配置成功！"
            return $true
        } catch {
            Write-Warn "设置 WinGet 镜像源时遇到提示: $_"
            return $false
        }
    } else {
        # 当前为普通权限，需要申请 UAC 提权
        if ($NonInteractive) {
            Write-Warn "非管理员权限且处于静默模式，跳过 UAC 提权请求，继续使用当前默认源。"
            return $false
        }

        Write-Host ""
        Write-Host "  👉 检测到当前非管理员权限，修改 WinGet 全局源需申请 UAC 提权。" -ForegroundColor Yellow
        $confirm = Read-Host "  是否申请管理员权限切换到中科大高速镜像源？(Y/N，默认 Y)"
        if ($confirm -eq '' -or $confirm -match '^[Yy]') {
            Write-Info "正在申请管理员权限以切换镜像源..."
            try {
                $cmd = "winget source remove winget; winget source add winget https://mirrors.ustc.edu.cn/winget-source --trust-level trusted; winget source update winget"
                $proc = Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $cmd -PassThru -Wait
                if ($proc.ExitCode -eq 0) {
                    Write-Success "WinGet 中科大高速镜像源已成功通过提权配置！"
                    return $true
                } else {
                    Write-Warn "提权执行返回退出码: $($proc.ExitCode)，将继续使用当前源进行后续操作。"
                    return $false
                }
            } catch {
                Write-Warn "提权请求已取消或失败: $_，将继续使用当前 WinGet 源。"
                return $false
            }
        } else {
            Write-Info "已跳过镜像源切换，将使用当前源继续。"
            return $false
        }
    }
}

<#
.SYNOPSIS
    将 WinGet 软件源重置回微软官方默认 CDN 源。
#>
function Reset-WingetOfficialMirror {
    $status = Get-WingetSourceStatus
    if (-not $status.HasWinget) { return }

    Write-Info "正在重置 WinGet 为微软官方默认源..."
    if (Test-IsAdmin) {
        & winget source reset winget --force 2>&1 | Out-Null
        & winget source update winget 2>&1 | Out-Null
        Write-Success "WinGet 已成功恢复为微软官方源！"
    } else {
        Write-Info "正在申请管理员权限重置 WinGet 官方源..."
        try {
            $cmd = "winget source reset winget --force; winget source update winget"
            Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $cmd -Wait
            Write-Success "WinGet 已成功恢复为微软官方源！"
        } catch {
            Write-Warn "重置源请求未完成: $_"
        }
    }
}

# -----------------------------------------------------------------------------
# 6. Scoop 备选包管理器准备与国内加速镜像
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    确保系统中已安装 Scoop（仅作为 WinGet 安装遇阻时的备选兜底方案）。
.DESCRIPTION
    针对国内直连 get.scoop.sh 或 GitHub 超时的问题，自动通过 gh-proxy 代理镜像拉取安装脚本。
#>
function Ensure-ScoopInstalled {
    Refresh-SessionPath
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        return $true
    }

    Write-Info "未检测到 Scoop 包管理器，正在通过国内加速镜像安装 Scoop 作为备选..."
    try {
        # 优先使用 gh-proxy 国内代理镜像加速下载官方安装脚本
        $bootstrapUrl = 'https://gh-proxy.com/https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1'
        $installer = (New-Object System.Net.WebClient).DownloadString($bootstrapUrl)
        Invoke-Expression $installer
        Refresh-SessionPath
        Write-Success "Scoop 备选包管理器安装成功！"
        return $true
    } catch {
        try {
            # 官方直连备用尝试
            Invoke-RestMethod -Uri get.scoop.sh | Invoke-Expression
            Refresh-SessionPath
            Write-Success "Scoop 官方脚本安装成功！"
            return $true
        } catch {
            Write-Warn "Scoop 自动安装失败: $_"
            return $false
        }
    }
}

<#
.SYNOPSIS
    为 Scoop 添加扩展仓库 (Bucket)，优先尝试官方源，失败时自动切换为 Gitee 或 gh-proxy 加速镜像。
.PARAMETER BucketName
    仓库名称，如 'extras', 'nerd-fonts' 等。
#>
function Ensure-ScoopBucket {
    param([string]$BucketName)
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) { return }

    $bucketList = & scoop bucket list 2>$null | Out-String
    if ($bucketList -match "(?m)^$BucketName\b") { return }

    Write-Info "正在为 Scoop 添加仓库: $BucketName..."
    $mirrors = @{
        'extras'     = @(
            'https://gh-proxy.com/https://github.com/ScoopInstaller/Extras',
            'https://gitee.com/scoop-bucket/extras'
        )
        'nerd-fonts' = @(
            'https://gh-proxy.com/https://github.com/matthewjberger/scoop-nerd-fonts',
            'https://gitee.com/kkzzhizhou/scoop-nerd-fonts'
        )
    }

    $added = $false
    # 首先尝试官方源
    try {
        & scoop bucket add $BucketName 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { $added = $true }
    } catch {}

    # 若官方源连接超时或被重置，尝试镜像源
    if (-not $added -and $mirrors.ContainsKey($BucketName)) {
        foreach ($url in $mirrors[$BucketName]) {
            try {
                Write-Info "官方源受阻，正在通过加速镜像添加 $BucketName ($url)..."
                & scoop bucket add $BucketName $url 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    $added = $true
                    Write-Success "Scoop 仓库 $BucketName 通过加速镜像添加成功！"
                    break
                }
            } catch {}
        }
    }
}

# -----------------------------------------------------------------------------
# 7. 核心应用安装引擎：WinGet 优先，Scoop 自动容错备选
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    安装指定的 CLI 应用程序，施行【WinGet 优先 + Scoop 备选】双重可靠保障。
.DESCRIPTION
    1. 预先检查目标命令是否在 PATH 中可用，若已存在则直接返回成功，实现毫秒级跳过；
    2. 第一梯队：调用 WinGet 进行静默安装，处理 ExitCode（包含已安装、版本冲突等常见退出码）；
    3. 第二梯队：若 WinGet 安装未成功或未在 PATH 中检出二进制，自动唤醒 Scoop 备选方案并重试；
    4. 安装完成后自动调用 Refresh-SessionPath 确保当前会话立即可用。
.PARAMETER Name
    工具的友好显示名称（如 "Starship 提示符"）。
.PARAMETER WingetId
    WinGet 官方唯一程序包标识符（如 "Starship.Starship"）。
.PARAMETER ScoopId
    Scoop 官方包名或仓库前缀包名（如 "starship" 或 "nerd-fonts/JetBrainsMono-NF"）。
.PARAMETER CommandCheck
    用来校验该应用是否成功安装的可执行文件名称（如 "starship"）。
#>
function Install-AppWithWingetScoopFallback {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$WingetId,
        [Parameter(Mandatory=$true)][string]$ScoopId,
        [Parameter(Mandatory=$true)][string]$CommandCheck
    )

    Refresh-SessionPath

    # 1. 检查应用是否已经就绪
    if (Get-Command $CommandCheck -ErrorAction SilentlyContinue) {
        Write-Success "$Name 已就绪 ($((Get-Command $CommandCheck).Source))"
        return $true
    }

    Write-Info "正在安装 $Name (WinGet ID: $WingetId)..."

    # 第一梯队：优先使用 WinGet
    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCmd) {
        $windowsApps = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'
        if (Test-Path (Join-Path $windowsApps 'winget.exe')) {
            $env:PATH = "$($env:PATH);$windowsApps"
            $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
        }
    }

    if ($wingetCmd) {
        try {
            $args = @(
                "install",
                "--id", $WingetId,
                "--exact",
                "--accept-source-agreements",
                "--accept-package-agreements",
                "--disable-interactivity",
                "--silent"
            )
            $proc = Start-Process -FilePath $wingetCmd.Source -ArgumentList $args -NoNewWindow -PassThru -Wait
            # 常见合法退出码：
            # 0: 成功安装
            # -1978335189 (0x8A15002B): 相同或更高版本已安装
            # -1978335176 (0x8A150038): 没有适用的更新/已是最新
            if ($proc.ExitCode -in @(0, -1978335189, -1978335176)) {
                Refresh-SessionPath
                if (Get-Command $CommandCheck -ErrorAction SilentlyContinue) {
                    Write-Success "[WinGet] $Name 安装成功！"
                    return $true
                }
            }
        } catch {
            Write-Warn "WinGet 调用异常: $_"
        }
    }

    # 第二梯队：若 WinGet 失败，自动启动 Scoop 备选方案
    Write-Warn "[WinGet] 安装 $Name 遇阻，正在启用备选方案 (Scoop)..."
    if (Ensure-ScoopInstalled) {
        if ($ScoopId -match '/') {
            $b = $ScoopId.Split('/')[0]
            Ensure-ScoopBucket $b
        } else {
            Ensure-ScoopBucket 'extras'
        }

        try {
            & scoop install $ScoopId | Out-Null
            Refresh-SessionPath
            if (Get-Command $CommandCheck -ErrorAction SilentlyContinue) {
                Write-Success "[Scoop 备选] $Name 安装成功！"
                return $true
            }
        } catch {
            Write-Warn "Scoop 安装 $ScoopId 失败: $_"
        }
    }

    Write-Warn "未能自动完成 $Name 的安装，您可以稍后手动执行: winget install $WingetId"
    return $false
}

# -----------------------------------------------------------------------------
# 8. JetBrainsMono Nerd Font 3 级渐进式极速安装
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    自动化安装并即时注册 JetBrainsMono Nerd Font 字体。
.DESCRIPTION
    1. 优先扫描用户字体库 (%LOCALAPPDATA%\Microsoft\Windows\Fonts) 与系统字体库，若存在直接跳过；
    2. 尝试通过 WinGet 安装 DEVCOM.JetBrainsMonoNerdFont；
    3. 若遇阻，自动使用国内高速镜像直链下载 JetBrainsMono.zip 完整字体包，解压至用户字体目录，
       写入注册表并通过 Windows 原生 GDI AddFontResource + User32 WM_FONTCHANGE 消息广播即时生效；
    4. 终极备选通过 Scoop nerd-fonts 仓库安装。
#>
function Install-JetBrainsMonoNerdFont {
    Write-Info "检查 JetBrainsMono Nerd Font 图标字体..."

    # 检查字体是否已经在系统中安装加载
    $fontMatches = @(Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts", "$env:WINDIR\Fonts" -Filter "*JetBrains*Nerd*" -ErrorAction SilentlyContinue)
    if ($fontMatches.Count -gt 0) {
        Write-Success "检测到系统中已安装 JetBrainsMono Nerd Font 图标字体 ($($fontMatches.Count) 项已就绪)！"
        return $true
    }

    # 1. 优先尝试 WinGet 安装
    Write-Info "正在通过 WinGet 安装 JetBrainsMono Nerd Font..."
    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetCmd) {
        try {
            $proc = Start-Process -FilePath $wingetCmd.Source -ArgumentList "install", "--id", "DEVCOM.JetBrainsMonoNerdFont", "--exact", "--accept-source-agreements", "--accept-package-agreements", "--disable-interactivity", "--silent" -NoNewWindow -PassThru -Wait
            if ($proc.ExitCode -in @(0, -1978335189)) {
                $fontMatches = @(Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts", "$env:WINDIR\Fonts" -Filter "*JetBrains*Nerd*" -ErrorAction SilentlyContinue)
                if ($fontMatches.Count -gt 0) {
                    Write-Success "[WinGet] JetBrainsMono Nerd Font 安装成功！"
                    return $true
                }
            }
        } catch {}
    }

    # 2. 第二梯队：通过国内加速镜像直链高速下载 + 原生免重启注册
    Write-Info "正在通过国内加速镜像直链极速下载并直接注册字体..."
    try {
        $zipUrl = "https://gh-proxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
        $tmpZip = Join-Path ([IO.Path]::GetTempPath()) ("JetBrainsMono-$([guid]::NewGuid().ToString('N')).zip")
        $tmpDir = Join-Path ([IO.Path]::GetTempPath()) ("JetBrainsMono-$([guid]::NewGuid().ToString('N'))")

        Invoke-WebRequest -Uri $zipUrl -OutFile $tmpZip -UseBasicParsing -TimeoutSec 60 -ErrorAction Stop
        Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force -ErrorAction Stop

        $targetDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
        if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
        $regKey = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

        # 编译调用 Windows GDI 与 User32 API，实现免重启即时注册字体
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class FontRegistrar {
    [DllImport("gdi32.dll", EntryPoint = "AddFontResourceW", SetLastError = true)]
    public static extern int AddFontResource([MarshalAs(UnmanagedType.LPWStr)] string lpFileName);
    [DllImport("user32.dll", SetLastError = true)]
    public static extern int SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
}
"@ -ErrorAction SilentlyContinue

        $ttfs = Get-ChildItem -Path $tmpDir -Filter "*NerdFont*.ttf" -Recurse
        $installedCount = 0
        foreach ($ttf in $ttfs) {
            $dest = Join-Path $targetDir $ttf.Name
            Copy-Item $ttf.FullName -Destination $dest -Force
            New-ItemProperty -Path $regKey -Name "$($ttf.BaseName) (TrueType)" -Value $dest -Force -ErrorAction SilentlyContinue | Out-Null
            [FontRegistrar]::AddFontResource($dest) | Out-Null
            $installedCount++
        }

        # 广播全局字体变动通知 (HWND_BROADCAST = 0xffff, WM_FONTCHANGE = 0x001D)
        $HWND_BROADCAST = [IntPtr]0xffff
        $WM_FONTCHANGE = 0x001D
        $res = [UIntPtr]::Zero
        [FontRegistrar]::SendMessageTimeout($HWND_BROADCAST, $WM_FONTCHANGE, [UIntPtr]::Zero, [IntPtr]::Zero, 2, 1000, [ref]$res) | Out-Null

        Remove-Item $tmpZip, $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "成功通过高速镜像安装并注册了 $installedCount 个 JetBrainsMono Nerd Font 字体文件！"
        return $true
    } catch {
        Write-Warn "高速镜像下载字体遇到提示: $_"
    }

    # 3. 第三梯队：通过 Scoop nerd-fonts 仓库备选安装
    if (Ensure-ScoopInstalled) {
        Ensure-ScoopBucket 'nerd-fonts'
        Write-Info "正在尝试使用 Scoop 安装 JetBrainsMono-NF..."
        & scoop install JetBrainsMono-NF 2>$null | Out-Null
    }

    return $false
}

# -----------------------------------------------------------------------------
# 9. PowerShell 增强模块自动化安装与 Mark of the Web 解锁
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    自动化从 PowerShell Gallery 安装 PSReadLine, Terminal-Icons 与 PSFzf 模块，
    并自动解锁文件以消除不信任发布者警告弹窗。
#>
function Install-PowerShellModules {
    Write-Info "正在检查与安装 PowerShell 增强模块 (PSReadLine, Terminal-Icons, PSFzf)..."

    $modules = @('PSReadLine', 'Terminal-Icons', 'PSFzf')
    foreach ($mod in $modules) {
        if (-not (Get-Module -ListAvailable -Name $mod)) {
            Write-Info "正在从 PSGallery 安装模块 $mod..."
            try {
                Install-Module -Name $mod -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
                Write-Success "模块 $mod 安装成功！"
            } catch {
                Write-Warn "模块 $mod 安装异常: $_"
            }
        } else {
            Write-Success "模块 $mod 已就绪。"
        }

        # 自动解除 Mark of the Web (Zone.Identifier 区域安全标记)，避免每次启动提示警告
        $modObj = Get-Module -ListAvailable -Name $mod | Select-Object -First 1
        if ($modObj -and $modObj.ModuleBase) {
            Get-ChildItem -Path $modObj.ModuleBase -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                Unblock-File -LiteralPath $_.FullName -ErrorAction SilentlyContinue
            }
        }
    }
}

# -----------------------------------------------------------------------------
# 10. Yazi 专用环境与富媒体预览依赖配置
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    配置 Yazi 核心依赖 file(1) 环境变量 (YAZI_FILE_ONE) 并确保富媒体预览工具就绪。
.DESCRIPTION
    1. 动态探测 Git for Windows 附带的 file.exe 落地路径；
    2. 将其持久化写入用户级环境变量 YAZI_FILE_ONE，并同步刷新当前进程环境；
    3. 支持探测和配置 Scoop、WinGet、官方安装包多种 Git 安装路径。
#>
function Ensure-YaziEnvironment {
    Write-Info "正在检查 Yazi 核心依赖与 YAZI_FILE_ONE 环境变量..."

    $candidates = @(
        'C:\Program Files\Git\usr\bin\file.exe',
        "$env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe",
        "$env:LOCALAPPDATA\Programs\Git\usr\bin\file.exe",
        'C:\Program Files (x86)\Git\usr\bin\file.exe'
    )

    $resolvedFileExe = $null
    foreach ($cand in $candidates) {
        if (Test-Path -LiteralPath $cand) {
            $resolvedFileExe = $cand
            break
        }
    }

    if (-not $resolvedFileExe) {
        $gitCmd = Get-Command git -ErrorAction SilentlyContinue
        if ($gitCmd -and $gitCmd.Source) {
            $gitRoot = Split-Path (Split-Path $gitCmd.Source -Parent) -Parent
            $cand = Join-Path $gitRoot 'usr\bin\file.exe'
            if (Test-Path -LiteralPath $cand) {
                $resolvedFileExe = $cand
            }
        }
    }

    if ($resolvedFileExe) {
        $currentUserVal = [Environment]::GetEnvironmentVariable('YAZI_FILE_ONE', 'User')
        if ($currentUserVal -ne $resolvedFileExe) {
            [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', $resolvedFileExe, 'User')
            Write-Success "已将 YAZI_FILE_ONE 持久化配置为: $resolvedFileExe"
        } else {
            Write-Success "YAZI_FILE_ONE 已正确指向: $resolvedFileExe"
        }
        $env:YAZI_FILE_ONE = $resolvedFileExe
    } else {
        Write-Warn "未在常用路径找到 Git 附带的 file.exe，建议安装 Git for Windows 以启用精确 MIME 检测。"
    }
}
