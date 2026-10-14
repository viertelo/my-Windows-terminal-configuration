# 🦆 Yazi 终端双栏文件管理器配置

本目录包含基于 Rust 开发的现代化极速终端文件管理器 —— **Yazi** 的完整生产级配置。

---

## 📁 目录内容

```text
yazi/
├── yazi.toml                         # Yazi 核心行为配置（布局、预览器、提取器、排序偏好）
├── keymap.toml                       # 全局自定义按键映射与快捷键
├── theme.toml                        # 视觉色彩主题配置（Catppuccin / Flexoki 调优）
├── Yazi快捷键操作手册.md             # 完整的全键盘快捷键速查参考手册
├── Yazi文件类型与打开方式配置说明.md # 常见文件后缀关联程序与预览器配置手册
└── README.md                         # 本说明文档
```

---

## ✨ 核心特性

1. ⚡ **极致极速体验**：
   - 全异步 I/O 驱动，大型代码仓库与万级文件目录秒级展开；
   - 占用内存极低，启动即用。
2. 🔄 **工作区路径联动跳转（退出自动同步 Shell CWD）**：
   - 在 PowerShell、Bash 和 NuShell 中，统一封装了包装函数 `y`；
   - 在 Yazi 内浏览至目标目录后，按下 `q` 退出时，**当前终端会自动 `cd` 进入该目录**，无需手动复制路径。
3. 👁️ **内置富媒体与代码预览**：
   - 代码文件自动调用语法高亮引擎；
   - 压缩包（ZIP/7z/TAR）无需解压即可在右侧面板直接层级树状展开预览。
4. ⌨️ **Vim 风格直觉全键盘操作**：
   - `h` / `j` / `k` / `l` 树形穿梭与层级折叠；
   - 标签页多任务管理（`t` 新建标签、`1`~`9` 标签快切）。

---

## ⚙️ 本地安装与部署

### 1. 对应本地文件路径
Yazi 在 Windows 平台上的标准配置目录为：
```text
%APPDATA%\yazi\config\
```

### 2. 部署方式

#### 方式 A：自动化一键部署（推荐）
在仓库根目录下运行：
```powershell
.\install.ps1
```
脚本将自动创建快照备份并将 `yazi/*.toml` 配置文件精确同步至 `%APPDATA%\yazi\config\`。

#### 方式 B：手动部署
在 PowerShell 中运行（仅同步 TOML 配置文件）：
```powershell
$yaziDest = "$env:APPDATA\yazi\config"
if (-not (Test-Path $yaziDest)) { New-Item -ItemType Directory -Path $yaziDest -Force | Out-Null }
Get-ChildItem -Path .\yazi -Filter "*.toml" | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $yaziDest $_.Name) -Force
}
```

### 3. Windows MIME 检测核心配置 (`YAZI_FILE_ONE`)

Windows 上 Yazi 依赖 `file(1)` 探测文件真实 MIME 类型。推荐使用 Git for Windows 自带的 `file.exe`，并将其配置到系统环境变量 `YAZI_FILE_ONE` 中：
```powershell
# 将 Git 附带的 file.exe 注册为用户环境变量 (若运行 .\install.ps1 会全自动配置)
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", "C:\Program Files\Git\usr\bin\file.exe", "User")
```

### 4. 推荐安装的预览增强工具链

```powershell
# WinGet 批量安装推荐预览依赖 (支持压缩包、JSON、PDF、音视频与图片高级处理)
winget install 7zip.7zip jqlang.jq oschwartz10612.Poppler Gyan.FFmpeg ImageMagick.ImageMagick sharkdp.bat ajeetdsouza.zoxide junegunn.fzf BurntSushi.ripgrep.MSVC sharkdp.fd

# 通过 Scoop 补充安装 SVG 矢量图预览工具 (resvg 暂未上架 WinGet)
scoop install resvg
```

---

## 📚 详细子文档索引

- [📖 Yazi 快捷键完整操作手册](Yazi快捷键操作手册.md) - 包含导航、搜索、多选、批量重命名、Tab管理等完整操作清单。
- [🛠️ Yazi 文件类型与打开方式配置说明](Yazi文件类型与打开方式配置说明.md) - 详解如何关联 VS Code、Neovim、默认文本编辑器与多媒体预览器。
