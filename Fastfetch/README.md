# 🐱 Fastfetch 硬件看板与二次元字符画配置

本目录包含适用于跨终端环境的 **Fastfetch** 现代化硬件信息看板与精美 ASCII 艺术画配置。

---

## 📁 目录内容

```text
Fastfetch/
├── config.jsonc           # Fastfetch 结构化显示配置（硬件规格、网卡、显卡、磁盘、系统参数）
├── ascii.txt              # 定制动漫二次元高精 ASCII 字符艺术画
└── README.md              # 本说明文档
```

---

## ✨ 核心特性

1. 🎨 **高精 ASCII 艺术与硬件遥测并排**：
   - 左侧展示精细化动漫角色 ASCII 字符画；
   - 右侧实时输出：Windows 版本、CPU 架构与频率、独立显卡型号与显存、主板型号、内存占比、双盘存储占用、各物理及虚拟网卡内网 IP、双显示器规格（主副屏分辨率与刷新率）及系统开机时长。
2. 🚀 **跨 Shell 24-bit TrueColor 渲染保证**：
   - 无论在 PowerShell、CMD、NuShell、Git Bash 还是 MSYS2 中调用，均已规范传入 `--pipe false` 参数，确保即使输出经过 C# 进程捕获或 Unix 管道重定向，也不会被剥离颜色转义码。
3. 动态跨机器适配：
   - 字符画路径配置使用 `%USERPROFILE%/.config/fastfetch/ascii.txt` 动态宏，消除对特定机器用户名的硬编码。

---

## ⚙️ 本地安装与部署

### 1. 对应本地文件路径
Fastfetch 在 Windows 系统中的全局配置目录为：
```text
%USERPROFILE%\.config\fastfetch\
```

### 2. 部署方式

#### 方式 A：自动化一键部署（推荐）
在仓库根目录下运行：
```powershell
.\install.ps1
```
脚本将自动创建快照备份并将看板配置文件与 ASCII 艺术画自动部署至 `%USERPROFILE%\.config\fastfetch\`。

#### 方式 B：手动部署
在 PowerShell 中运行：
```powershell
$ffDest = "$env:USERPROFILE\.config\fastfetch"
if (-not (Test-Path $ffDest)) { New-Item -ItemType Directory -Path $ffDest -Force | Out-Null }
Copy-Item .\Fastfetch\* $ffDest -Recurse -Force
```

---

## 💡 环境变量与静音模式

若您在日常开发中需要追求极致启动速度（例如快速执行单行命令），可通过设置环境变量跳过开屏 Fastfetch 看板：

- **PowerShell**：
  ```powershell
  $env:POWERSHELL_PROFILE_BANNER = '0'
  ```
- **CMD**：
  ```cmd
  set CMD_PROFILE_BANNER=0
  ```
- **Bash / MSYS2**：
  ```bash
  export PROFILE_BANNER=0
  ```
- **NuShell**：
  ```nu
  $env.PROFILE_BANNER = "0"
  ```
