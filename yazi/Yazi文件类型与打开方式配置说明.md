# Yazi 文件类型与打开方式配置说明

> 基于当前 yazi.toml 配置 | Windows 系统 | 最后更新：2025-11-13

---

## 📑 目录

- [快速参考](#快速参考)
- [文本文件](#文本文件)
- [图片文件](#图片文件)
- [音视频文件](#音视频文件)
- [压缩文件](#压缩文件)
- [其他文件类型](#其他文件类型)
- [操作方式](#操作方式)
- [预览功能](#预览功能)

---

## 快速参考

| 文件类型 | 默认打开方式 | 快捷键 | 说明 |
|---------|------------|--------|------|
| 文本文件 | nvim | `Enter` | 在终端中打开编辑 |
| 图片文件 | Windows 默认程序 | `Enter` | 用系统关联程序打开 |
| 音视频 | mpv | `Enter` | 用 mpv 播放器打开 |
| 压缩包 | 解压 | `Enter` | 解压到当前目录 |
| 文件夹 | 进入目录 | `Enter` 或 `l` | 导航进入 |
| 任意文件 | 选择打开方式 | `o` | 显示打开方式菜单 |

---

## 文本文件

### 📝 支持的格式

**MIME 类型：`text/*`**

#### 编程语言
- **Python**: `.py`, `.pyw`, `.pyx`
- **JavaScript/TypeScript**: `.js`, `.mjs`, `.cjs`, `.ts`, `.tsx`, `.jsx`
- **C/C++**: `.c`, `.cpp`, `.cc`, `.cxx`, `.h`, `.hpp`
- **Rust**: `.rs`
- **Go**: `.go`
- **Java**: `.java`
- **C#**: `.cs`
- **Ruby**: `.rb`
- **PHP**: `.php`
- **Shell**: `.sh`, `.bash`, `.zsh`, `.fish`
- **Lua**: `.lua`
- **Perl**: `.pl`, `.pm`

#### 标记语言
- **Markdown**: `.md`, `.markdown`
- **HTML**: `.html`, `.htm`
- **XML**: `.xml`
- **CSS**: `.css`, `.scss`, `.sass`, `.less`

#### 配置文件
- **TOML**: `.toml`
- **YAML**: `.yaml`, `.yml`
- **JSON**: `.json`, `.jsonc`, `.ndjson`
- **INI**: `.ini`, `.conf`, `.cfg`
- **ENV**: `.env`, `.env.local`

#### 数据文件
- **CSV**: `.csv`, `.tsv`
- **SQL**: `.sql`
- **Log**: `.log`

#### 文档
- **纯文本**: `.txt`
- **README**: `README`, `README.md`
- **LICENSE**: `LICENSE`, `LICENSE.txt`

### 🔧 打开方式

**程序**: `nvim` (Neovim)

**操作**:
1. 用 `j`/`k` 选择文件
2. 按 `Enter` - 用 nvim 打开
3. 按 `o` - 显示打开方式菜单，可选择其他程序

**特点**:
- 阻塞模式（`block = true`）：编辑完成后自动返回 yazi
- 在当前终端窗口中打开
- 支持所有 nvim 功能和插件

### 📋 预览功能

文本文件在 yazi 右侧面板会自动显示语法高亮预览（需要安装 `bat` 工具）

---

## 图片文件

### 🖼️ 支持的格式

**MIME 类型：`image/*`**

#### 常见格式
- **JPEG**: `.jpg`, `.jpeg`, `.jpe`
- **PNG**: `.png`
- **GIF**: `.gif`
- **BMP**: `.bmp`
- **WebP**: `.webp`
- **ICO**: `.ico`

#### 高级格式
- **AVIF**: `.avif`
- **HEIF/HEIC**: `.heif`, `.heic`
- **JXL**: `.jxl` (JPEG XL)
- **SVG**: `.svg` (矢量图)
- **TIFF**: `.tiff`, `.tif`

#### RAW 格式
- `.raw`, `.cr2`, `.nef`, `.arw`, `.dng` 等

### 🔧 打开方式

**默认程序**: **XnView MP** ✅

**操作**:
1. 用 `j`/`k` 选择图片
2. 按 `Enter` - 用 XnView MP 打开
3. 按 `o` - 显示打开方式菜单，可选择：
   - **XnView MP** (默认)
   - Windows 默认查看器
   - 画图 (Paint)

**特点**:
- 孤儿模式（`orphan = true`）：在新窗口打开，不阻塞 yazi
- XnView MP 支持超过 500 种图片格式
- 快速浏览、批量处理、EXIF 信息查看
- 支持 RAW 格式、PSD、AI 等专业格式

### 📋 预览功能

图片文件在 yazi 右侧面板会显示缩略图预览

**预览配置**:
- 最大宽度：600px
- 最大高度：900px
- 图片质量：75%
- 延迟加载：30ms
- 滤镜算法：triangle（三角插值）

**特殊格式预览**:
- AVIF/HEIC/JXL：使用 ImageMagick
- SVG：专用 SVG 预览器
- 其他格式：标准图片预览

---

## 音视频文件

### 🎵 支持的格式

**MIME 类型：`audio/*` 和 `video/*`**

#### 音频格式
- **MP3**: `.mp3`
- **FLAC**: `.flac`
- **WAV**: `.wav`
- **AAC**: `.aac`, `.m4a`
- **OGG**: `.ogg`, `.oga`
- **WMA**: `.wma`
- **OPUS**: `.opus`
- **APE**: `.ape`
- **ALAC**: `.alac`

#### 视频格式
- **MP4**: `.mp4`, `.m4v`
- **MKV**: `.mkv`
- **AVI**: `.avi`
- **MOV**: `.mov`
- **WMV**: `.wmv`
- **FLV**: `.flv`
- **WebM**: `.webm`
- **MPEG**: `.mpg`, `.mpeg`, `.m2v`
- **TS**: `.ts`, `.m2ts`

### 🔧 打开方式

**默认程序**: **PotPlayer** ✅

**操作**:
1. 用 `j`/`k` 选择媒体文件
2. 按 `Enter` - 用 PotPlayer 播放
3. 按 `o` - 显示打开方式菜单，可选择：
   - **PotPlayer** (默认)
   - MPC-HC
   - KMPlayer
   - mpv

**特点**:
- 孤儿模式（`orphan = true`）：在新窗口播放，不阻塞 yazi
- 支持几乎所有音视频格式
- 硬件加速解码（DXVA, CUDA, QuickSync）
- 强大的字幕支持和音轨切换
- 低资源占用，播放流畅

**PotPlayer 常用快捷键**:
- `Space` - 播放/暂停
- `←`/`→` - 快退/快进 5 秒
- `↑`/`↓` - 音量增减
- `Enter` - 全屏切换
- `Esc` - 退出全屏
- `Alt+X` - 退出
- `Alt+E` - 字幕设置

### 📋 预览功能

视频文件在 yazi 右侧面板会显示视频信息和缩略图

---

## 压缩文件

### 📦 支持的格式

**MIME 类型：`application/{zip,rar,7z*,tar,gzip,...}`**

#### 常见压缩格式
- **ZIP**: `.zip`
- **RAR**: `.rar`
- **7-Zip**: `.7z`
- **TAR**: `.tar`
- **GZIP**: `.gz`, `.tar.gz`, `.tgz`
- **BZIP2**: `.bz2`, `.tar.bz2`, `.tbz2`
- **XZ**: `.xz`, `.tar.xz`, `.txz`
- **ZSTD**: `.zst`, `.tar.zst`
- **LZMA**: `.lzma`

#### 软件包格式
- **DEB**: `.deb` (Debian 包)
- **RPM**: `.rpm` (RedHat 包)
- **APK**: `.apk` (Android 包)
- **AppImage**: `.AppImage`

#### 磁盘镜像
- **ISO**: `.iso`
- **IMG**: `.img`
- **VHD/VHDX**: `.vhd`, `.vhdx` (虚拟硬盘)
- **QEMU**: `.qcow2`
- **DMG**: `.dmg` (Apple 磁盘镜像)
- **WIM**: `.wim` (Windows 镜像)

#### 文件系统镜像
- `.fat`, `.ext`, `.ext2`, `.ext3`, `.ext4`
- `.squashfs`, `.ntfs`, `.hfs`, `.hfsx`

### 🔧 打开方式

**程序**: `ya pub extract` (Yazi 内置解压插件)

**操作**:
1. 用 `j`/`k` 选择压缩文件
2. 按 `Enter` - 显示解压选项
3. 确认后解压到当前目录

**特点**:
- 自动识别压缩格式
- 显示压缩包内容列表
- 解压到当前目录

### 📋 预览功能

压缩文件在 yazi 右侧面板会显示压缩包内的文件列表

---

## 其他文件类型

### 📄 PDF 文件

**格式**: `.pdf`

**打开方式**: Windows 默认 PDF 阅读器（通过 `start` 命令）

**预览**: 在右侧面板显示 PDF 缩略图（需要 `pdftoppm` 工具）

---

### 🔤 字体文件

**格式**:
- TrueType: `.ttf`
- OpenType: `.otf`
- WOFF: `.woff`, `.woff2`
- Type1: `.pfb`, `.pfm`

**打开方式**: Windows 默认字体查看器

**预览**: 显示字体预览（需要字体预览工具）

---

### 📁 文件夹

**打开方式**:
- 按 `Enter` 或 `l` - 进入目录
- 按 `h` - 返回上级目录
- 按 `o` - 可选择用编辑器打开（如 nvim）

**预览**: 显示文件夹内容列表

---

### 🔗 符号链接

**打开方式**:
- 按 `Enter` - 跟随链接打开目标
- 按 `g` `f` - 跟随符号链接

**预览**: 显示链接目标路径

---

### ⚙️ 空文件

**MIME 类型**: `inode/empty`

**打开方式**: 用 nvim 打开编辑

---

### 🌐 其他未知类型

**打开方式**: Windows 默认程序（通过 `start` 命令）

**说明**: 使用 Windows 文件关联的默认程序打开

---

## 操作方式

### 基本操作

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Enter` | 打开文件 | 使用默认程序打开 |
| `o` | 选择打开方式 | 显示打开方式菜单 |
| `l` | 进入目录/打开文件 | 与 Enter 类似 |
| `h` | 返回上级目录 | 导航到父目录 |

### 打开方式菜单 (`o`)

按 `o` 后会显示可用的打开方式：

**文本文件**:
1. `edit` - 用 nvim 编辑
2. `reveal` - 在资源管理器中显示

**图片文件**:
1. `open` - 用默认程序打开
2. `reveal` - 在资源管理器中显示

**音视频文件**:
1. `play` - 用 mpv 播放
2. `reveal` - 在资源管理器中显示

**压缩文件**:
1. `extract` - 解压到当前目录
2. `reveal` - 在资源管理器中显示

**文件夹**:
1. `edit` - 用编辑器打开（如 nvim）
2. `open` - 在新窗口打开
3. `reveal` - 在资源管理器中显示

### Reveal 功能

按 `o` 然后选择 `reveal`，会在 Windows 资源管理器中打开文件所在位置并选中该文件。

**快捷方式**: 可以在 `keymap.toml` 中自定义快捷键绑定 reveal 功能。

---

## 预览功能

### 预览面板

Yazi 右侧面板会自动预览选中的文件：

| 文件类型 | 预览方式 | 依赖工具 |
|---------|---------|---------|
| 文本文件 | 语法高亮显示 | `bat` |
| JSON | 格式化显示 | 内置 |
| 图片 | 缩略图 | 内置 |
| 视频 | 视频信息 + 缩略图 | `ffmpegthumbnailer` |
| PDF | 页面缩略图 | `pdftoppm` |
| 压缩包 | 文件列表 | 内置 |
| 字体 | 字体预览 | 字体工具 |
| 文件夹 | 内容列表 | 内置 |

### 预览配置

当前预览设置（在 `yazi.toml` 中）:

```toml
[preview]
wrap            = "no"          # 不自动换行
tab_size        = 2             # Tab 显示为 2 个空格
max_width       = 600           # 最大宽度 600px
max_height      = 900           # 最大高度 900px
image_delay     = 30            # 图片加载延迟 30ms
image_filter    = "triangle"    # 图片缩放算法
image_quality   = 75            # 图片质量 75%
```

### 预览操作

| 快捷键 | 功能 |
|--------|------|
| `J` | 预览向下滚动 |
| `K` | 预览向上滚动 |
| `Tab` | 进入 Spot 模式（详细预览） |
| `Esc` | 退出 Spot 模式 |

---

## 推荐工具

为了获得最佳体验，建议安装以下工具：

### 必需工具

- **nvim** - 文本编辑器 ✅ 已配置
- **mpv** - 媒体播放器

### 预览增强

- **bat** - 语法高亮预览文本文件
- **ffmpegthumbnailer** - 视频缩略图
- **pdftoppm** (poppler) - PDF 预览
- **ImageMagick** - 高级图片格式预览 (AVIF/HEIC/JXL)

### 搜索工具

- **fd** - 快速文件搜索
- **rg** (ripgrep) - 文件内容搜索
- **fzf** - 模糊查找

### 安装方式 (Windows)

使用 Scoop 或 Chocolatey:

```powershell
# Scoop
scoop install mpv bat fd ripgrep fzf imagemagick poppler

# Chocolatey
choco install mpv bat fd ripgrep fzf imagemagick poppler
```

---

## 自定义配置

### 修改默认编辑器

编辑 `yazi.toml` 的 `[opener]` 部分：

```toml
[opener]
edit = [
    { run = 'nvim %*', block = true, desc = "nvim", for = "windows" },
]
```

### 添加新的打开方式

例如，添加 VS Code 作为备选编辑器：

```toml
[opener]
edit = [
    { run = 'nvim %*', block = true, desc = "nvim", for = "windows" },
]
vscode = [
    { run = 'code %*', orphan = true, desc = "VS Code", for = "windows" },
]
```

然后在 `[open]` 规则中使用：

```toml
[open]
rules = [
    { mime = "text/*", use = [ "edit", "vscode", "reveal" ] },
]
```

### 修改文件类型关联

在 `[open]` 的 `rules` 数组中添加或修改规则：

```toml
[open]
rules = [
    # 自定义规则示例
    { name = "*.md", use = [ "edit", "reveal" ] },
    { mime = "image/png", use = [ "open", "reveal" ] },
]
```

---

## 配置文件位置

- **配置目录**: `%USERPROFILE%\AppData\Local\yazi\config`
- **主配置**: `yazi.toml` - 文件类型和打开方式
- **快捷键配置**: `keymap.toml` - 快捷键绑定
- **主题配置**: `theme.toml` - 颜色和样式

**快速跳转**: 在 yazi 中按 `g` `c` 可以快速跳转到配置目录。

---

## 常见问题

### Q: 如何更改某个文件类型的默认打开程序？

A: 编辑 `yazi.toml` 的 `[opener]` 部分，添加新的 opener，然后在 `[open]` 规则中引用。

### Q: 预览不显示怎么办？

A: 检查是否安装了相应的预览工具（如 bat、ffmpegthumbnailer 等）。

### Q: 如何临时用其他程序打开文件？

A: 按 `o` 显示打开方式菜单，选择其他程序。

### Q: 图片预览模糊怎么办？

A: 调整 `yazi.toml` 中的 `image_quality` 和 `image_filter` 参数。

### Q: 如何在 Windows 资源管理器中打开当前目录？

A: 按 `o` 然后选择 `reveal`，或者自定义快捷键绑定 `reveal` 命令。

---

**享受使用 Yazi！** 🚀

如有问题，按 `~` 或 `F1` 查看内置帮助，或按 `g` `c` 跳转到配置目录修改配置。


