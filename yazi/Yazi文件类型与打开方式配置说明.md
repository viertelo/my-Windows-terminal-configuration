# Yazi 文件类型与打开方式配置说明

> 基于仓库 `yazi.toml` 的 `opener`、`open.rules` 和 `preview` 节 | Windows | 最后更新：2026-10-13

本文档简要说明常见文件类型的默认打开方式、打开规则与预览依赖。请以仓库中的 `yazi.toml` 为最终依据。支持通过根目录下 `.\install.ps1` 自动化备份与部署。

---

## 配置参考

- `opener`：定义打开器（例如 `markdown`、`image`、`play`、`extract`、`reveal`）。
- `open.rules`：按 `mime`、`name` 或模式决定使用哪些 `opener`。
- `preview`：预览相关配置（图片大小、质量、滤镜等）。

---

## 快速参考表

| 文件类型 | 常见默认 opener（示例） | 常用快捷键 |
|---|---:|:---|
| Markdown (`.md`) | `markdown` → Typora / VS Code / nvim | `Enter`, `o` |
| 文本文件 | `edit` → `nvim %*` | `Enter` |
| 图片 | `image` → XnViewMP / mspaint / magick | `Enter`, `o` |
| 媒体 | `play` → mpv / PotPlayer | `Enter` |
| 压缩包 | `extract`（内置或外部） | `Enter`, `o` |
| 目录 | `reveal` → `explorer /select,"%1"` 或 内部 `enter` | `Enter` / `l` |

---

## 重点说明

- `Enter` 的行为由 `open.rules` 的匹配优先级决定；目录常用 `reveal`（在资源管理器中选中），若需在 Yazi 内部进入目录请使用 `l`。
- `opener` 中可设置 `orphan = true`（在新窗口打开）或 `block = true`（阻塞 Yazi 直到子进程结束）。
- `open.rules` 的 `use` 列表决定尝试顺序，遇到可执行 opener 即停止。

---

## 打开方式菜单（按 `o`）

菜单项来自对应类型的 `opener` 列表，例如：

- 文本：`edit` / `reveal` / `open`
- 图片：`image` / `reveal` / `mspaint`
- 媒体：`play` / `reveal`
- 压缩：`extract` / `reveal`

具体命令见 `yazi.toml` 中对应 `opener` 条目的 `run` 字段。

---

## 预览与依赖工具

示例 `preview` 配置（以 `yazi.toml` 为准）：

```toml
[preview]
wrap = "no"
tab_size = 2
max_width = 600
max_height = 900
image_delay = 30
image_filter = "triangle"
image_quality = 75
```

常见依赖：`bat`（文本高亮）、`ffmpegthumbnailer`（视频缩略）、`pdftoppm`（PDF）、`ImageMagick`（高级图片格式）。

---

## 🔍 Windows MIME 检测核心依赖 (`file.exe` 与 `YAZI_FILE_ONE`)

Windows 系统自身不包含原生的 `file(1)` 命令。为了让 Yazi 能够精确识别文件真实 MIME 类型（以驱动 `open.rules` 和各类富媒体预览器），Yazi 官方强烈推荐使用 **Git for Windows** 自带的 `file.exe`：

### 1. 环境变量配置规范
将 Git 安装目录下的 `file.exe` 添加到用户环境变量 `YAZI_FILE_ONE`：
- **安装版 Git 默认路径**：`C:\Program Files\Git\usr\bin\file.exe`
- **Scoop 安装版 Git 路径**：`%USERPROFILE%\scoop\apps\git\current\usr\bin\file.exe`

> 💡 **提示**：仓库根目录下的 `.\install.ps1` 部署脚本已内置自动探测与持久化配置逻辑，执行安装向导时会自动完成该环境变量的写入。

---

## 🛠️ 推荐工具与富媒体预览器依赖表 (Windows)

Yazi 内置了丰富的预览功能，当系统安装了以下外部工具时会自动激活对应的深度预览支持：

| 预览功能 | 依赖工具 | WinGet 安装指令 | Scoop 安装指令 | 作用说明 |
| :--- | :--- | :--- | :--- | :--- |
| **MIME 探测** | `file` (Git) | `winget install Git.Git` | `scoop install git` | 基础核心：支持精确识别 MIME 类型 |
| **压缩包展开** | `7-Zip` (`7z`) | `winget install 7zip.7zip` | `scoop install 7zip` | 在预览区直接以树形结构浏览 ZIP/7z/RAR/TAR |
| **JSON 预览** | `jq` | `winget install jqlang.jq` | `scoop install jq` | 高亮并层级格式化展示 JSON/NDJSON |
| **PDF 预览** | `pdftoppm` | `winget install oschwartz10612.Poppler` | `scoop install poppler` | 将 PDF 首页渲染为图片在面板预览 |
| **视频预览** | `ffmpeg` | `winget install Gyan.FFmpeg` | `scoop install ffmpeg` | 提取视频缩略图与多媒体元信息看板 |
| **高级图像** | `magick` | `winget install ImageMagick.ImageMagick` | `scoop install imagemagick` | 支持 HEIC/AVIF/JXL 等现代图像格式转换 |
| **SVG 矢量图** | `resvg` | *(暂无官方包)* | `scoop install resvg` | 将 SVG 矢量文件即时渲染为预览图像 |
| **代码高亮** | `bat` | `winget install sharkdp.bat` | `scoop install bat` | 提供代码语法高亮与行号指示 |
| **快速跳转** | `zoxide` | `winget install ajeetdsouza.zoxide` | `scoop install zoxide` | 结合 `z` 实现毫秒级历史目录直达 |
| **交互筛选** | `fzf` | `winget install junegunn.fzf` | `scoop install fzf` | 交互式实时模糊匹配文件与目录 |
| **内容检索** | `ripgrep` (`rg`)| `winget install BurntSushi.ripgrep.MSVC` | `scoop install ripgrep` | 在当前目录树快速检索文件内容 |
| **文件搜索** | `fd` | `winget install sharkdp.fd` | `scoop install fd` | 极速文件名模式匹配搜索 |

---

## 自定义示例（将 VS Code 加入 opener）

在 `yazi.toml` 中添加：

```toml
[opener]
vscode = [ { run = 'code %*', orphan = true, desc = "VS Code", for = "windows" } ]
[open.rules]
rules = [ { mime = "text/*", use = ["vscode", "edit", "reveal"] } ]
```

---

## 常见问题

- Q: 打开文件时用哪个程序？
  - A: `open.rules` 按 `mime`/`name` 匹配后，按 `use` 列表顺序尝试 `opener`。
- Q: 如何在资源管理器中显示文件？
  - A: 使用 `reveal`（通常为 `explorer /select,"%1"`）或按 `o` 手动选择 `reveal`。
- Q: 为什么某些文件预览显示为二进制乱码或未知类型？
  - A: 请检查 `YAZI_FILE_ONE` 环境变量是否已正确指向 `file.exe`。可在终端运行 `echo $env:YAZI_FILE_ONE` 校验。

---

**享受使用 Yazi！** 🚀

如有问题，按 `~` 或 `F1` 查看内置帮助，或按 `g` `c` 跳转到配置目录修改配置。


