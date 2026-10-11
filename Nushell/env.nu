# =============================================================================
# NuShell Environment Configuration (env.nu)
# Windows 现代终端美化与极速工作流套件
# =============================================================================

# 1. 强制 UTF-8 与中文语言环境
$env.LANG = "zh_CN.UTF-8"
$env.LC_ALL = "zh_CN.UTF-8"

# 2. 自动加载扩展目录初始化
try { mkdir (($nu.data-dir? | default ("~/.local/share/nushell" | path expand)) | path join "vendor/autoload") } catch {}
