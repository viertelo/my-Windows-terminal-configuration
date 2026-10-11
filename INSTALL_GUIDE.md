# 📖 Windows 终端全家桶一步步安装与部署教程

本教程旨在帮助您在任何一台全新或已有的 Windows 电脑上，**从零开始、一步步搭建出媲美甚至超越 macOS/Linux 的现代化终端工作流**。

无论您平时使用 **PowerShell 7**、**CMD**、**NuShell** 还是 **Git Bash**，按照本指南操作，均可获得统一的高颜值主题、智能命令预测、多维模糊检索、双行提示符与无缝工具联动。

---

## 📑 目录导航

- [0. 核心架构与部署路线图](#0-核心架构与部署路线图)
- [方式 A：一键全自动安装（推荐，5分钟搞定）](#方式-a一键全自动安装推荐5分钟搞定)
- [方式 B：分步手动精细化安装（适合深度定制）](#方式-b分步手动精细化安装适合深度定制)
  - [第 1 步：基础环境与包管理器准备 (Scoop)](#第-1-步基础环境与包管理器准备-scoop)
  - [第 2 步：核心 CLI 工具与图标字体安装](#第-2-步核心-cli-工具与图标字体安装)
  - [第 3 步：Windows Terminal 终端调校](#第-3-步windows-terminal-终端调校)
  - [第 4 步：PowerShell 7+ 高阶 Profile 部署](#第-4-步powershell-7-高阶-profile-部署)
  - [第 5 步：CMD + Clink 现代化增强部署](#第-5-步cmd--clink-现代化增强部署)
  - [第 6 步：NuShell 结构化数据终端部署](#第-6-步nushell-结构化数据终端部署)
  - [第 7 步：Git Bash & MSYS2 终端部署](#第-7-步git-bash--msys2-终端部署)
  - [第 8 步：Starship / Fastfetch / Yazi 视觉套件部署](#第-8-步starship--fastfetch--yazi-视觉套件部署)
- [效果验证清单](#-效果验证清单)
- [常见问题与故障排查 (FAQ)](#-常见问题与故障排查-faq)

---

## 0. 核心架构与部署路线图

整个项目涉及的配置文件与其在 Windows 系统中的实际落地位置如下：

```text
[项目仓库目录]                                    [Windows 本机系统安装位置]
├── Terminal/settings.json              ➔  %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
├── PowerShell-Enhanced-Profile/*.ps1   ➔  $PROFILE (通常为 ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1)
├── CMD/autorun.cmd                     ➔  %USERPROFILE%\.config\cmd\autorun.cmd  (注册表 AutoRun 挂载)
├── CMD/clink/*                         ➔  %LOCALAPPDATA%\clink\
├── Nushell/*                           ➔  %APPDATA%\nushell\
├── Bash/.bashrc & .bash_profile        ➔  %USERPROFILE%\.bashrc & .bash_profile
├── Starship/starship.toml              ➔  %USERPROFILE%\.config\starship.toml
├── Fastfetch/*                         ➔  %USERPROFILE%\.config\fastfetch\
└── Yazi/*                              ➔  %APPDATA%\yazi\config\
```

---

## 方式 A：一键全自动安装（推荐，5分钟搞定）

仓库内自带交互式部署脚本 `install.ps1`，具备**自动环境探测**、**原配置备份归档**与**多终端模块选择**功能。

### 运行方式：
以普通用户身份打开 **PowerShell**，运行以下指令：

```powershell
# 1. 允许当前用户运行 PowerShell 脚本
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. 克隆仓库（若已克隆可跳过）
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 3. 运行自动化部署脚本
.\install.ps1
```

脚本将提供交互菜单：
- **选项 1**：全自动一键安装（自动安装 Scoop 依赖工具、Nerd Font 图标字体，并全量部署所有终端配置）。
- **选项 2**：仅部署配置文件（适用于已通过 Scoop/Winget 安装好工具的用户，将自动备份旧配置并写入新配置）。
- **选项 3~8**：单独针对特定终端进行增量部署。

---

## 方式 B：分步手动精细化安装（适合深度定制）

如果您希望清楚了解每个步骤的原理，或只想为其中某个终端做美化，请按以下步骤操作：

---

### 第 1 步：基础环境与包管理器准备 (Scoop)

我们推荐使用轻量级 Windows 包管理器 **Scoop**，所有工具均安装在用户家目录下，不污染系统环境变量。

1. 打开 **PowerShell**，允许执行脚本：
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
   ```
2. 安装 Scoop：
   ```powershell
   irm get.scoop.sh | iex
   ```
3. 添加必要的工具软件源（Bucket）：
   ```powershell
   scoop bucket add extras
   scoop bucket add nerd-fonts
   ```

---

### 第 2 步：核心 CLI 工具与图标字体安装

终端的图标显示依赖 **Nerd Font**，且我们配置的现代别名依赖对应的 CLI 原生工具：

1. **安装 Nerd Font 字体**（解决图标乱码与方块问题）：
   ```powershell
   scoop install JetBrainsMono-NF
   ```
   > 💡 字体安装后会自动注册到系统中。

2. **安装全套现代化生产力工具**：
   ```powershell
   scoop install git starship oh-my-posh fastfetch eza bat zoxide fzf television tre clink nushell yazi lazygit neovim
   ```

   **工具矩阵一览**：
   - `starship`：极速跨终端提示符
   - `oh-my-posh`：PowerShell 主题提示符
   - `fastfetch`：硬件与二次元 ASCII 看板
   - `eza`：现代化文件列表（带图标，替代 `ls`）
   - `bat`：代码语法高亮查看（替代 `cat`）
   - `television` (`tv`)：多频道交互式模糊检索
   - `tre`：现代树状目录（带编号快速打开）
   - `zoxide`：智能路径跳转（`z`）
   - `clink`：CMD 命令行自动补全与着色引擎
   - `yazi`：终端双栏极速文件管理器
   - `lazygit`：全键盘 Git 可视化面板

3. **安装 PowerShell 模块**：
   ```powershell
   Install-Module PSReadLine, Terminal-Icons, PSFzf -Scope CurrentUser -Force -SkipPublisherCheck
   ```

---

### 第 3 步：Windows Terminal 终端调校

Windows Terminal 是所有 Shell 的顶层视窗容器。

1. 确认已在微软商店或通过 Scoop 安装 **Windows Terminal**（Windows 11 已内置）。
2. 将仓库中的配置文件覆盖到本地配置路径：
   - **源文件**：`Terminal\settings.json`
   - **目标路径**：
     `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
   
   **PowerShell 复制命令**：
   ```powershell
   $wtPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
   Copy-Item .\Terminal\settings.json $wtPath -Force
   ```

3. **调整字体与背景壁纸**（可选）：
   - 打开 Windows Terminal ➔ 点击下拉箭头 ➔「设置」➔ 确认默认字体为 `JetBrainsMono NFM`。
   - 壁纸默认配置位于 `C:\Users\<用户名>\Pictures\壁纸文件\dde5a5767u6579.jpg`，您可以替换为自己的壁纸文件。

---

### 第 4 步：PowerShell 7+ 高阶 Profile 部署

1. 检查您的 Profile 文件所在路径：
   ```powershell
   $PROFILE
   ```
2. 确保父目录存在，并将仓库配置复制过去：
   ```powershell
   $profileDir = Split-Path $PROFILE
   if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force }
   Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force
   ```
3. 立即重载配置生效：
   ```powershell
   . $PROFILE
   ```
   > 🚀 您将看到精美的 Fastfetch 硬件看板与功能就绪卡片！

---

### 第 5 步：CMD + Clink 现代化增强部署

CMD 的增强由 **`autorun.cmd`**（负责注入别名与环境变量）与 **Clink**（负责补全与 Starship 提示符）共同驱动。

1. **部署 `autorun.cmd`**：
   ```powershell
   $cmdConfigDir = "$env:USERPROFILE\.config\cmd"
   if (-not (Test-Path $cmdConfigDir)) { New-Item -ItemType Directory -Path $cmdConfigDir -Force }
   Copy-Item .\CMD\autorun.cmd "$cmdConfigDir\autorun.cmd" -Force
   ```
   > ⚠️ **注意**：批处理文件必须使用 **CRLF** 换行符。仓库配置已包含该格式。

2. **写入注册表 AutoRun**（使每次启动 CMD 自动加载该脚本）：
   ```powershell
   reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%USERPROFILE%\.config\cmd\autorun.cmd" /f
   ```

3. **部署 Clink 增强脚本**：
   ```powershell
   $clinkDir = "$env:LOCALAPPDATA\clink"
   if (-not (Test-Path $clinkDir)) { New-Item -ItemType Directory -Path $clinkDir -Force }
   Copy-Item .\CMD\clink\* $clinkDir -Force
   ```

4. 打开一个新的 `cmd.exe` 窗口，即可体验语法着色与 Starship 提示符！随时输入 `shortcuts` 可查看快捷键。

---

### 第 6 步：NuShell 结构化数据终端部署

1. 确保 NuShell 配置目录存在：
   ```powershell
   $nuDir = "$env:APPDATA\nushell"
   if (-not (Test-Path $nuDir)) { New-Item -ItemType Directory -Path $nuDir -Force }
   ```
2. 复制配置文件与自动加载模块：
   ```powershell
   Copy-Item .\Nushell\config.nu "$nuDir\config.nu" -Force
   Copy-Item .\Nushell\env.nu "$nuDir\env.nu" -Force
   Copy-Item -Recurse .\Nushell\vendor "$nuDir\" -Force
   ```
3. 在终端中运行 `nu` 启动 NuShell，体验圆角表格与 `tvcd` 交互跳转功能！

---

### 第 7 步：Git Bash & MSYS2 终端部署

#### 7.1 Git Bash
将配置复制到当前用户家目录：
```powershell
Copy-Item .\Bash\.bashrc "$env:USERPROFILE\.bashrc" -Force
Copy-Item .\Bash\.bash_profile "$env:USERPROFILE\.bash_profile" -Force
```

#### 7.2 MSYS2（若安装）
若您安装了 MSYS2，请将 `msys2.bashrc` 复制至 MSYS2 用户目录：
```powershell
$msysHome = "C:\msys64\home\$env:USERNAME"
if (Test-Path $msysHome) {
    Copy-Item .\Bash\msys2.bashrc "$msysHome\.bashrc" -Force
}
```

---

### 第 8 步：Starship / Fastfetch / Yazi 视觉套件部署

将通用工具配置同步至各自的默认目录：

```powershell
# 1. Starship 配置 (跨终端统一提示符)
Copy-Item .\Starship\starship.toml "$env:USERPROFILE\.config\starship.toml" -Force

# 2. Fastfetch 动漫硬件看板
$ffDir = "$env:USERPROFILE\.config\fastfetch"
if (-not (Test-Path $ffDir)) { New-Item -ItemType Directory -Path $ffDir -Force }
Copy-Item -Recurse .\Fastfetch\* $ffDir -Force

# 3. Yazi 终端文件管理器配置
$yaziDir = "$env:APPDATA\yazi\config"
if (-not (Test-Path $yaziDir)) { New-Item -ItemType Directory -Path $yaziDir -Force }
Copy-Item -Recurse .\Yazi\* $yaziDir -Force
```

---

## 🧪 效果验证清单

完成部署后，您可以在任意已配置的终端中执行以下命令验证功能：

- [ ] 输入 `fastfetch`：能否展示精美的动漫 ASCII 艺术图与详尽硬件信息？
- [ ] 输入 `ll` 或 `la`：是否以彩色图标、文件夹排在前、包含 Git 状态列出文件？
- [ ] 输入 `tre`：是否展示树状结构并附带 `e0`, `e1`... 快捷编号？
- [ ] 输入 `tv`：是否弹出 Television 全频道模糊搜索交互窗口？
- [ ] 输入 `cat <某个代码文件>`：是否带有语法高亮色彩？
- [ ] 输入 `y`：能否进入双栏 Yazi 终端文件管理器？退出时是否留在当前目录？
- [ ] 输入 `lg`：能否唤起全键盘 Lazygit 面板？
- [ ] 输入 `z <已访问过的文件夹名>`：是否能瞬间跨层级跳转？

---

## ❓ 常见问题与故障排查 (FAQ)

### Q1: 终端里的图标显示为方块（口口）或乱码？
**原因**：终端使用的字体不是 **Nerd Font**，缺少图标字形映射。  
**解决**：
1. 确保已运行 `scoop install JetBrainsMono-NF`；
2. 打开 Windows Terminal 设置 ➔ 选择当前配置（或“默认值”）➔「外观」➔「字体」➔ 选择 `JetBrainsMono NFM` 或 `JetBrainsMono NF`。

---

### Q2: 打开 CMD 报错 `'e" lt3=...' 不是内部或外部命令`？
**原因**：`%USERPROFILE%\.config\cmd\autorun.cmd` 保存为了 Linux LF 换行符，导致 Windows 批处理行解析紊乱。  
**解决**：在 PowerShell 中执行以下命令将其转换回 CRLF：
```powershell
$p = "$env:USERPROFILE\.config\cmd\autorun.cmd"
[IO.File]::WriteAllText($p, ((Get-Content -Raw $p) -replace "`r?`n", "`r`n"), [System.Text.Encoding]::UTF8)
```

---

### Q3: Git 推送到 GitHub 时提示 `Permission denied to ... 403`？
**原因**：Windows 凭据管理器中缓存了其他 GitHub 账号的 Token 或密码。  
**解决**：
1. 打开 Windows「凭据管理器」➔「Windows 凭据」；
2. 找到 `git:https://github.com` 项并删除；
3. 回到终端重新执行 `git push`，根据弹出的网页授权窗口完成登录；
4. 确认当前账号已被目标仓库添加为 Collaborator 且已在 GitHub 网页上点击接受邀请。

---

### Q4: 终端启动慢，想跳过欢迎卡片或硬件看板？
本套配置设计了灵活的环境变量开关，可在无需修改代码的情况下自由控制：
- **PowerShell 7**：在 `$PROFILE` 顶部添加 `$env:POWERSHELL_PROFILE_MINIMAL = '1'` 可实现 ~100ms 极速秒开。
- **CMD**：执行 `set CMD_PROFILE_TIPS=0` 与 `set CMD_PROFILE_BANNER=0`。
- **NuShell / Bash**：在对应配置文件中设置 `$env.PROFILE_TIPS = "0"` 或 `export PROFILE_TIPS=0`。
