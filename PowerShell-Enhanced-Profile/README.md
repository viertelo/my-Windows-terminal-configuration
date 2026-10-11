# ⚡ PowerShell 7+ 企业级高阶增强 Profile

本目录包含了专为 **PowerShell 7+** 深度调优的工业级配置文件 [`Microsoft.PowerShell_profile.ps1`](Microsoft.PowerShell_profile.ps1)。采用 AST 解析与进程沙箱驱动，彻底告别卡顿、乱码与管道污染，打造媲美 Unix 的丝滑生产力体验。

[快速参考卡片](快速参考.md) • [配置文件源码](Microsoft.PowerShell_profile.ps1)

---

## 📁 目录内容

```text
PowerShell-Enhanced-Profile/
├── Microsoft.PowerShell_profile.ps1  # PowerShell 核心配置文件（沙箱加载、现代别名、实用函数）
├── 快速参考.md                       # 常用命令、别名与快捷键速查卡片
└── README.md                         # 本说明文档
```

---

## ✨ 核心特性

1. 🚀 **毫秒级安全启动沙箱 (`Invoke-ProfileProcess`)**：
   - 使用轻量级独立进程沙箱运行外部 CLI 初始化（`oh-my-posh`、`zoxide`、`television`）；
   - 设置严格执行超时（如 1500ms），彻底杜绝由于网络波动、无效句柄或磁盘卡顿导致的终端启动假死。
2. 🛡️ **严格守护 PowerShell 管道纯净度**：
   - 避免直接将 `ls`、`dir`、`cat` 别名重定向为外部字符输出工具；
   - 保留原生 `FileInfo` 与字符串对象管道特性（例如 `ls | Where-Object ...` 绝不损坏）；
   - 提供独立现代化别名：`ll`、`la`、`lt`（基于 `eza` 带图标与 Git 状态）、`catc`（基于 `bat` 高亮且不锁屏分页）。
3. 🧠 **智能预测与命令补全 (PSReadLine & PSFzf)**：
   - 历史预测补全（`History` + `InlineView`），按 `→` 或 `End` 即可瞬间采纳建议；
   - 高对比度语法高亮（Catppuccin Mocha 定制色板）；
   - 结合 `fzf` 提供 `Ctrl+R`（历史模糊搜索）与 `Ctrl+F`（文件选择填入）。
4. 🔍 **多维模糊检索与现代工具链集成**：
   - **Television (`tv`)**：跨文件、目录、代码全文与 Git 分支极速检索；
   - **Tre (`tre`)**：智能树状目录，生成 `e0`, `e1`, `e2` 等编号命令，直接调起编辑器；
   - **Yazi (`y`)**：终端双栏文件管理器，退出时自动 `cd` 同步当前终端工作目录；
   - **全局代码搜索 (`fif`)**：结合 `ripgrep` + `fzf` + `bat` 实时画中画代码行预览检索；
   - **Zoxide (`z` / `zi`)**：跨层级智能目录瞬移。
5. 📊 **动漫硬件状态看板 (Fastfetch)**：
   - 启动自动展示精美 ASCII 动漫角色与硬件遥测（CPU/GPU/内存/双屏/内网IP）；
   - 强制 `--pipe false` 确保 24-bit TrueColor 完美呈现。

---

## ⚙️ 本地安装与部署

### 1. 对应本地文件路径
PowerShell 7+ 在当前用户的配置文件路径定义于 `$PROFILE`，通常对应：
```text
%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

### 2. 部署与重载
在 PowerShell 中运行：
```powershell
# 1. 确保目录存在并复制配置
$psDir = Split-Path $PROFILE
if (-not (Test-Path $psDir)) { New-Item -ItemType Directory -Path $psDir -Force | Out-Null }
Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 2. 重新加载生效
. $PROFILE
```

---

## ⌨️ 常用全局快捷键速查

| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `→` / `End` | 一键采纳历史预测建议 | 由 PSReadLine 提供历史智能预测 |
| `Ctrl+R` | 交互式历史命令模糊搜索 | 由 PSFzf / FZF 提供，支持关键词快速筛选 |
| `Ctrl+F` | 模糊选择当前目录文件并填入命令行 | 配合 bat 语法高亮右侧预览 |
| `Ctrl+G` | 瞬间唤起 Lazygit 面板 | 退出后自动恢复原命令行提示符 |
| `Alt+Z` | Zoxide 交互式目录快选 | 模糊匹配访问过的目录并直接跳转 |
| `Ctrl+Z` | 撤销上次命令行输入 | PSReadLine Windows 撤销历史 |
| `F2` | 切换预测展示视图 | 在内联视图与下拉列表视图之间轮转 |

---

## 🛠️ 实用内置函数手册

| 函数 | 说明 | 示例 |
| :--- | :--- | :--- |
| `mkcd <dir>` | 递归创建目录并直接进入 | `mkcd src/components/button` |
| `fif <keyword>` | 全局代码模糊检索（带实时语法高亮预览） | `fif handleAuthToken` |
| `fv` | 交互式文件浏览与编辑器直达 | `fv` |
| `tre [path]` | 彩色目录树带编号，支持 `e1` 快速打开 | `tre .` |
| `y [path]` | 启动 Yazi 文件管理器（退出自动同步当前路径） | `y` |
| `ports` | 查看当前系统端口占用、监听状态与对应 PID | `ports` |
| `myip` | 查看本机所有物理与虚拟网卡内网 IP | `myip` |
| `reload` | 热重载当前 PowerShell 配置文件 | `reload` |
| `Find-LargeFiles` | 快速扫描当前或指定目录下最大的文件 | `Find-LargeFiles -TopN 10` |
| `Test-Environment` | 一键体检：检查当前所有 CLI 工具与模块安装状态 | `Test-Environment` |
| `Edit-Profile` | 快速唤起默认编辑器编辑当前 `$PROFILE` | `Edit-Profile` |

---

## ⚡ 性能调优与环境变量开关

您可以在系统环境变量中配置以下开关以个性化控制加载行为：

```powershell
# 跳过开屏 Fastfetch 看板（极速启动）
$env:POWERSHELL_PROFILE_BANNER = '0'

# 跳过开屏功能提示卡片
$env:POWERSHELL_PROFILE_TIPS = '0'

# 切换提示符引擎模式（可选: 'oh-my-posh' 或 'starship'）
$env:POWERSHELL_THEME_MODE = 'starship'

# 禁用 Terminal-Icons 图标加载（追求极致启动耗时）
$env:POWERSHELL_PROFILE_ICONS = '0'
```
