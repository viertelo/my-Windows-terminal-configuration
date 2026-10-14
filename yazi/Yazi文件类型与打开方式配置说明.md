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

## 推荐工具（Windows）

- `nvim`, `mpv`, `bat`, `ffmpegthumbnailer`, `pdftoppm` (poppler), `ImageMagick`, `fd`, `rg`, `fzf`。

可使用 `scoop` 或 `chocolatey` 安装（仓库中原文含示例命令）。

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

---

如需我将这些更改提交到 git，请确认是否要我执行 commit & push（以及提交信息）。
**享受使用 Yazi！** 🚀

如有问题，按 `~` 或 `F1` 查看内置帮助，或按 `g` `c` 跳转到配置目录修改配置。


