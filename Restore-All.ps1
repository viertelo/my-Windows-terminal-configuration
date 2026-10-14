# =============================================================================
# Restore-All.ps1
# Windows 全终端配置一键回退与灾难恢复脚本
#
# 【设计说明】：
#   - 配合 install.ps1 的快照引擎工作，保障宿主机环境 100% 安全可逆
#   - 每次 install.ps1 部署前均会自动创建快照并更新 .last-install-backup
#   - 本脚本可自动读取最近一次快照并执行精准回退，亦可接收自定义快照目录参数
#   - 原生支持 -WhatIf 参数进行静默演练预览，绝不冒进更改系统状态
# =============================================================================

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    # 可选参数：显式指定备份快照目录路径（不传则自动读取 .last-install-backup）
    [Parameter(Position = 0)]
    [string]$BackupDirectory
)

$ErrorActionPreference = "Stop"
$projectRoot = $PSScriptRoot

# 引入状态管理与快照还原核心引擎
. (Join-Path $projectRoot 'scripts\TerminalState.ps1')

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  Windows 终端配置一键回退与状态还原" -ForegroundColor Yellow
Write-Host "========================================================================" -ForegroundColor Cyan

# 1. 自动解析快照路径：若用户未显式指定，则从 .last-install-backup 指针读取
if (-not $BackupDirectory) {
    $pointer = Join-Path $projectRoot '.last-install-backup'
    if (-not (Test-Path -LiteralPath $pointer)) {
        throw "未找到最近一次安装快照指针 (.last-install-backup)。请显式指定备份目录，例如: .\Restore-All.ps1 C:\Users\xxx\.terminal_backup_xxx"
    }
    $BackupDirectory = ([IO.File]::ReadAllText($pointer)).Trim()
}

# 2. 校验目标快照目录是否存在
if (-not (Test-Path -LiteralPath $BackupDirectory)) {
    throw "指定的快照目录不存在: $BackupDirectory"
}

# 3. 调用核心回退引擎（支持 -WhatIf 演练）
Restore-TerminalSnapshot -Directory $BackupDirectory -WhatIf:$WhatIfPreference
