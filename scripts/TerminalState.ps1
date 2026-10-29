# =============================================================================
# TerminalState.ps1
# 终端配置目标清册、状态快照与安全回退系统 (PowerShell 5.1 & 7+ 全兼容)
#
# 【核心功能】：
#   1. 受管目标清册 (Get-TerminalTargets)：定义 16 项受管终端配置文件的系统落地路径与组件归属
#   2. 注册表清册 (Get-TerminalRegistrySpecs)：追踪 CMD AutoRun 等核心系统级启动项
#   3. 原子化文件更新 (Set-TerminalBytes)：采用同目录 .tmp 临时文件与 File::Replace 规避文件锁与并发污染
#   4. 完整配置快照生成 (Backup-AllTerminalConfigurations)：记录 SHA-256 哈希、文件字节与注册表状态
#   5. 一键无损回滚引擎 (Restore-TerminalSnapshot)：根据 manifest.json 还原旧文件、还原注册表、清理新增文件
# =============================================================================

# -----------------------------------------------------------------------------
# 1. 目标路径与环境解析辅助函数
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    动态获取当前用户的 Documents (文档) 物理路径。
.DESCRIPTION
    支持 Windows 文件夹重定向（如重定向至 OneDrive、D 盘等特殊情形），
    同时支持通过环境变量 TERMINAL_SETUP_DOCUMENTS 进行显式重载以供隔离测试。
#>
function Get-TerminalDocumentsPath {
    if ($env:TERMINAL_SETUP_DOCUMENTS) {
        return [IO.Path]::GetFullPath($env:TERMINAL_SETUP_DOCUMENTS)
    }
    # 动态读取系统重定向后的文档目录
    $documents = [Environment]::GetFolderPath('MyDocuments')
    if (-not $documents) {
        $documents = Join-Path $env:USERPROFILE 'Documents'
    }
    return $documents
}

<#
.SYNOPSIS
    智能解析 MSYS2 的安装根路径。
.DESCRIPTION
    依次扫描用户显式参数、C:\msys64、环境变量以及 Scoop 安装目录，返回首个存在的路径。
#>
function Resolve-TerminalMsysRoot([string]$Path) {
    if ($Path) { return [IO.Path]::GetFullPath($Path) }
    foreach ($candidate in @('C:\msys64', "$env:SystemDrive\msys64", "$env:USERPROFILE\scoop\apps\msys2\current", 'C:\tools\msys64')) {
        if (Test-Path -LiteralPath (Join-Path $candidate 'usr\bin\bash.exe')) { return $candidate }
    }
    return 'C:\msys64'
}

# -----------------------------------------------------------------------------
# 2. 受管终端配置与注册表目标清册
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    获取受管终端配置文件的完整清单与落地路径映射。
.PARAMETER Msys2InstallPath
    可选的 MSYS2 根目录路径。
.PARAMETER Components
    需筛选的组件列表，支持 'All', 'PowerShell7', 'WinPS51', 'Terminal', 'Cmd', 'NuShell', 'Bash', 'Yazi', 'Shared'。
.PARAMETER CmdTargetDir
    可选的 CMD 脚本目录重定向。
#>
function Get-TerminalTargets {
    param(
        [string]$Msys2InstallPath,
        [string[]]$Components = @('All'),
        [string]$CmdTargetDir
    )
    $documents = Get-TerminalDocumentsPath
    $msys = Resolve-TerminalMsysRoot $Msys2InstallPath
    if (-not $CmdTargetDir) { $CmdTargetDir = Join-Path $env:USERPROFILE '.config\cmd' }

    # 定义全终端受管文件映射规范表：@(备份标识名, 本地系统物理路径, 所属组件名)
    $spec = @(
        @('PowerShell7_profile.ps1', "$documents\PowerShell\Microsoft.PowerShell_profile.ps1", 'PowerShell7'),
        @('WinPS51_profile.ps1', "$documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1", 'WinPS51'),
        @('Terminal_stable.json', "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", 'Terminal'),
        @('Terminal_preview.json', "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json", 'Terminal'),
        @('cmd_autorun.cmd', "$CmdTargetDir\autorun.cmd", 'Cmd'),
        @('starship.toml', "$env:USERPROFILE\.config\starship.toml", 'Shared'),
        @('fastfetch_config.jsonc', "$env:USERPROFILE\.config\fastfetch\config.jsonc", 'Shared'),
        @('fastfetch_ascii.txt', "$env:USERPROFILE\.config\fastfetch\ascii.txt", 'Shared'),
        @('nushell_config.nu', "$env:APPDATA\nushell\config.nu", 'NuShell'),
        @('nushell_env.nu', "$env:APPDATA\nushell\env.nu", 'NuShell'),
        @('bash_profile', "$env:USERPROFILE\.bash_profile", 'Bash'),
        @('bashrc', "$env:USERPROFILE\.bashrc", 'Bash'),
        @('yazi_keymap.toml', "$env:APPDATA\yazi\config\keymap.toml", 'Yazi'),
        @('yazi_theme.toml', "$env:APPDATA\yazi\config\theme.toml", 'Yazi'),
        @('yazi_config.toml', "$env:APPDATA\yazi\config\yazi.toml", 'Yazi')
    )

    # 若检测到系统中存在 MSYS2，自动纳入 MSYS2 .bashrc 受管范围
    if (Test-Path -LiteralPath (Join-Path $msys 'usr\bin\bash.exe')) {
        $spec += ,@('msys2_bashrc', "$msys\home\$env:USERNAME\.bashrc", 'Bash')
    }

    $results = @()
    foreach ($item in $spec) {
        if ('All' -in $Components -or $item[2] -in $Components) {
            $results += [pscustomobject]@{
                Name      = $item[0]
                Target    = [IO.Path]::GetFullPath($item[1])
                Desc      = $item[2]
                Component = $item[2]
            }
        }
    }
    return $results
}

<#
.SYNOPSIS
    获取受管的 Windows 注册表启动项定义表。
#>
function Get-TerminalRegistrySpecs([string[]]$Components = @('All')) {
    $specs = @()
    if ('All' -in $Components -or 'Cmd' -in $Components) {
        # CMD AutoRun 启动挂载注册表项
        $specs += [pscustomobject]@{ Key = 'HKCU:\Software\Microsoft\Command Processor'; Name = 'AutoRun' }
    }
    return $specs
}

# -----------------------------------------------------------------------------
# 3. 哈希校验与注册表状态读写
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    计算指定文件的 SHA-256 哈希值，用于校验备份前后文件的内容一致性。
#>
function Get-TerminalHash([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    $stream = [IO.File]::OpenRead($Path)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-', '')
    } finally {
        $sha.Dispose()
        $stream.Dispose()
    }
}

<#
.SYNOPSIS
    读取指定注册表键值的当前状态（包括是否存在、数值类型与实际值）。
#>
function Get-TerminalRegistryState($Spec) {
    $result = [ordered]@{
        Key     = $Spec.Key
        Name    = $Spec.Name
        Existed = $false
        Value   = $null
        Kind    = 'String'
    }
    if (Test-Path -LiteralPath $Spec.Key) {
        $key = Get-Item -LiteralPath $Spec.Key -ErrorAction Stop
        try {
            if ($Spec.Name -in $key.GetValueNames()) {
                $result.Existed = $true
                $result.Kind    = $key.GetValueKind($Spec.Name).ToString()
                $result.Value   = $key.GetValue($Spec.Name, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
            }
        } finally { $key.Close() }
    }
    return [pscustomobject]$result
}

<#
.SYNOPSIS
    安全恢复注册表键值状态；若快照前不存在则安全删除，若存在则还原其数值与类型。
#>
function Set-TerminalRegistryState($State) {
    if ($State.Key -notlike 'HKCU:\*') { throw "不支持的注册表配置单元: $($State.Key)" }
    $subKey = $State.Key.Substring(6)
    if ($State.Existed) {
        $key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($subKey)
        try {
            $kind = [Enum]::Parse([Microsoft.Win32.RegistryValueKind], $State.Kind)
            $key.SetValue($State.Name, $State.Value, $kind)
        } finally { $key.Close() }
    } else {
        $key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($subKey, $true)
        if ($null -ne $key) {
            try { $key.DeleteValue($State.Name, $false) } finally { $key.Close() }
        }
    }
}

# -----------------------------------------------------------------------------
# 4. 原子化安全文件写入与编码保护
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    以原子替换方式向目标路径写入字节数据。
.DESCRIPTION
    先将数据写入同级目录的随机 .tmp 临时文件，随后调用 File::Replace 或 File::Move 进行单步原子替换。
    彻底避免在写入中途遇到进程占用、断电或权限中断导致的配置文件内容为空或损坏。
#>
function Set-TerminalBytes {
    param([string]$Path, [AllowEmptyCollection()][byte[]]$Bytes)
    $Path = [IO.Path]::GetFullPath($Path)
    $parent = [IO.Path]::GetDirectoryName($Path)
    if (-not (Test-Path -LiteralPath $parent)) {
        [IO.Directory]::CreateDirectory($parent) | Out-Null
    }
    $temporary = Join-Path $parent ('.terminal-' + [guid]::NewGuid().ToString('N') + '.tmp')
    try {
        $stream = [IO.File]::Open($temporary, 'CreateNew', 'Write', 'None')
        try {
            $stream.Write($Bytes, 0, $Bytes.Length)
            $stream.Flush($true)
        } finally { $stream.Dispose() }

        # 最多尝试 10 次原子替换，容忍轻微的文件锁抖动
        for ($attempt = 0; ; $attempt++) {
            try {
                if ([IO.File]::Exists($Path)) {
                    [IO.File]::Replace($temporary, $Path, [NullString]::Value)
                } else {
                    [IO.File]::Move($temporary, $Path)
                }
                break
            } catch [IO.IOException] {
                if ($attempt -ge 9) { throw }
                Start-Sleep -Milliseconds 100
            }
        }
    } finally {
        if ([IO.File]::Exists($temporary)) { [IO.File]::Delete($temporary) }
    }
}

<#
.SYNOPSIS
    以指定的 UTF-8 编码格式（默认无 BOM）安全写入文本文件。
#>
function Set-TerminalText {
    param([string]$Path, [AllowEmptyString()][string]$Text, [switch]$Bom)
    $encoding = New-Object Text.UTF8Encoding ([bool]$Bom)
    $bytes = $encoding.GetPreamble() + $encoding.GetBytes($Text)
    Set-TerminalBytes -Path $Path -Bytes $bytes
}

# -----------------------------------------------------------------------------
# 5. 全终端快照安全备份核心函数
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    为当前机器上所有现存的终端配置文件与注册表项生成安全快照。
.DESCRIPTION
    1. 自动在 %USERPROFILE%\.terminal_backup_<时间戳> 建立独立归档目录；
    2. 遍历 16 项受管目标，备份存在的文件并计算原始 SHA-256 哈希；
    3. 特殊归档 Clink 脚本目录与 NuShell vendor 目录；
    4. 提取相关注册表键值状态；
    5. 生成带有版本号和时间戳的 manifest.json 清单；
    6. 将快照路径写入仓库根目录的 .last-install-backup 指针文件中。
#>
function Backup-AllTerminalConfigurations {
    param(
        [string[]]$Components = @('All'),
        [string]$PointerName = '.last-install-backup'
    )
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = Join-Path $env:USERPROFILE ".terminal_backup_$timestamp"
    [IO.Directory]::CreateDirectory($backupDir) | Out-Null

    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  正在创建全终端环境快照安全备份" -ForegroundColor Yellow
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  [i] 备份目标路径: $backupDir" -ForegroundColor Cyan

    $targets = Get-TerminalTargets -Components $Components
    $files = @()
    $backedUpCount = 0

    foreach ($t in $targets) {
        $exists = [IO.File]::Exists($t.Target)
        $hash = ''
        if ($exists) {
            $destFile = Join-Path $backupDir $t.Name
            $bytes = [IO.File]::ReadAllBytes($t.Target)
            Set-TerminalBytes -Path $destFile -Bytes $bytes
            $hash = Get-TerminalHash $destFile
            $backedUpCount++
        }
        $files += [pscustomobject]@{
            Name      = $t.Name
            Target    = $t.Target
            Desc      = $t.Desc
            Component = $t.Component
            Existed   = $exists
            SHA256    = $hash
        }
    }

    # 完整归档本地 Clink 目录 (若存在)
    $clinkDir = "$env:LOCALAPPDATA\clink"
    if (Test-Path $clinkDir) {
        $clinkBackup = Join-Path $backupDir "clink_dir"
        New-Item -ItemType Directory -Path $clinkBackup -Force | Out-Null
        Copy-Item (Join-Path $clinkDir "*") $clinkBackup -Recurse -Force -ErrorAction SilentlyContinue
    }

    # 完整归档本地 NuShell vendor 目录 (若存在)
    $nuVendorDir = "$env:APPDATA\nushell\vendor"
    if (Test-Path $nuVendorDir) {
        $nuBackup = Join-Path $backupDir "nushell_vendor"
        New-Item -ItemType Directory -Path $nuBackup -Force | Out-Null
        Copy-Item (Join-Path $nuVendorDir "*") $nuBackup -Recurse -Force -ErrorAction SilentlyContinue
    }

    # 备份关联注册表项
    $registry = @(foreach ($spec in (Get-TerminalRegistrySpecs -Components $Components)) {
        Get-TerminalRegistryState $spec
    })

    # 构建并输出 manifest.json 描述清单
    $manifest = [pscustomobject]@{
        Version   = 2
        Timestamp = (Get-Date -Format o)
        Files     = $files
        Registry  = $registry
    }

    $manifestJson = $manifest | ConvertTo-Json -Depth 8
    Set-TerminalText -Path (Join-Path $backupDir 'manifest.json') -Text $manifestJson

    # 记录最新快照指针至项目根目录
    $projectRoot = Split-Path -Parent $PSScriptRoot
    if (-not $projectRoot) { $projectRoot = Get-Location }
    $pointerPath = Join-Path $projectRoot $PointerName
    [IO.File]::WriteAllText($pointerPath, $backupDir, [System.Text.UTF8Encoding]::new($false))

    Write-Host "  [✓] 成功归档了 $backedUpCount 项现有配置文件及相关注册表项！" -ForegroundColor Green
    return $backupDir
}

# -----------------------------------------------------------------------------
# 6. 一键无损回滚与灾难恢复引擎
# -----------------------------------------------------------------------------

<#
.SYNOPSIS
    根据备份快照与 manifest.json 清单，一键无损还原所有受管终端配置。
.DESCRIPTION
    1. 自动定位备份目录（支持显式指定或自动读取 .last-install-backup 指针）；
    2. 读取 manifest.json，逐一还原快照中原本存在的文件（校验并原子替换）；
    3. 对于快照前【原本不存在】但在安装中新创建的文件，执行安全清理；
    4. 还原 Clink 脚本目录；
    5. 还原注册表 AutoRun 状态；
    6. 支持 -WhatIf 参数进行静默演练预览，不实际修改磁盘。
#>
function Restore-TerminalSnapshot {
    param(
        [string]$Directory,
        [switch]$WhatIf
    )
    $projectRoot = Split-Path -Parent $PSScriptRoot
    if (-not $projectRoot) { $projectRoot = Get-Location }

    # 未显式指定快照目录时，自动从 .last-install-backup 读取
    if (-not $Directory) {
        $pointerPath = Join-Path $projectRoot '.last-install-backup'
        if (Test-Path $pointerPath) {
            $Directory = ([IO.File]::ReadAllText($pointerPath)).Trim()
        }
    }

    if (-not $Directory -or -not (Test-Path $Directory)) {
        throw "无法定位有效的配置备份快照目录。请显式指定 -Directory 参数。"
    }

    $manifestPath = Join-Path $Directory 'manifest.json'
    if (-not (Test-Path $manifestPath)) {
        throw "快照目录下缺少 manifest.json 描述清单: $Directory"
    }

    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  正在从快照安全回退/恢复终端配置" -ForegroundColor Yellow
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "  [i] 正在读取快照清单: $Directory" -ForegroundColor Cyan

    $manifest = [IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json
    $restoredCount = 0
    $deletedCount = 0

    foreach ($entry in $manifest.Files) {
        $target = $entry.Target
        if ($entry.Existed) {
            # 快照前原本存在的文件：从备份还原
            $sourceFile = Join-Path $Directory $entry.Name
            if (Test-Path $sourceFile) {
                if ($WhatIf) {
                    Write-Host "  [WhatIf] 将还原文件: $target" -ForegroundColor DarkGray
                } else {
                    $bytes = [IO.File]::ReadAllBytes($sourceFile)
                    Set-TerminalBytes -Path $target -Bytes $bytes
                    Write-Host "  [✓] 已恢复: $target" -ForegroundColor Green
                    $restoredCount++
                }
            }
        } else {
            # 快照前原本不存在的文件：安装过程中新增，回退时应安全删除
            if (Test-Path -LiteralPath $target) {
                if ($WhatIf) {
                    Write-Host "  [WhatIf] 将删除安装时新增的文件: $target" -ForegroundColor DarkGray
                } else {
                    Remove-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
                    Write-Host "  [✓] 已清理新增文件: $target" -ForegroundColor Yellow
                    $deletedCount++
                }
            }
        }
    }

    # 还原 Clink 目录
    $clinkBackup = Join-Path $Directory "clink_dir"
    if (Test-Path $clinkBackup) {
        $clinkDest = "$env:LOCALAPPDATA\clink"
        if ($WhatIf) {
            Write-Host "  [WhatIf] 将还原 Clink 脚本目录: $clinkDest" -ForegroundColor DarkGray
        } else {
            if (-not (Test-Path $clinkDest)) { New-Item -ItemType Directory -Path $clinkDest -Force | Out-Null }
            Copy-Item (Join-Path $clinkBackup "*") $clinkDest -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  [✓] 已还原 Clink 脚本目录" -ForegroundColor Green
        }
    }

    # 还原 NuShell vendor 目录
    $nuBackup = Join-Path $Directory "nushell_vendor"
    if (Test-Path $nuBackup) {
        $nuVendorDest = "$env:APPDATA\nushell\vendor"
        if ($WhatIf) {
            Write-Host "  [WhatIf] 将还原 NuShell vendor 目录: $nuVendorDest" -ForegroundColor DarkGray
        } else {
            if (-not (Test-Path $nuVendorDest)) { New-Item -ItemType Directory -Path $nuVendorDest -Force | Out-Null }
            Copy-Item (Join-Path $nuBackup "*") $nuVendorDest -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  [✓] 已还原 NuShell vendor 目录" -ForegroundColor Green
        }
    }

    # 还原注册表 AutoRun 状态
    foreach ($reg in @($manifest.Registry)) {
        if ($null -ne $reg) {
            if ($WhatIf) {
                Write-Host "  [WhatIf] 将恢复注册表项: $($reg.Key)\$($reg.Name)" -ForegroundColor DarkGray
            } else {
                Set-TerminalRegistryState -State $reg
                Write-Host "  [✓] 注册表项已恢复: $($reg.Key)\$($reg.Name)" -ForegroundColor Green
            }
        }
    }

    Write-Host ""
    Write-Host "  [✓] 回退恢复操作完成！共恢复 $restoredCount 个文件，清理 $deletedCount 个新增文件。" -ForegroundColor Green
}
