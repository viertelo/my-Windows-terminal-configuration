# 🌌 Starship 赛博朋克·霓虹渐变提示符配置

本目录包含适用于 Windows 多 Shell（PowerShell / CMD / NuShell / Bash）的现代化 **赛博朋克·霓虹渐变主题** Starship 提示符。

---

## ✨ 特性亮点

- 🎨 **霓虹渐变色彩体系**：紫 (`#c792ea`) → 粉 (`#ff79c6`) → 蓝 (`#82aaff`) → 青 (`#8be9fd`) → 霓虹绿 (`#50fa7b`)；
- ⚡ **Windows NTFS 深度性能优化**：将 `scan_timeout` 调优为 `150ms`，彻底消除 Windows 平台在大型项目或杀毒监控下的 `Scanning current directory timed out` 告警；
- 🧩 **全语言芯片风格**：统一的 `(via 🧩 symbol version)` 现代语言 Runtime 识别（Python, Node.js, Rust, Go, Java, Kotlin, Swift, Lua, Zig, C/C++ 等）；
- 🌿 **Git 状态立体呈现**：分支名、未跟踪、暂存、修改、冲突（⚔️）、超前（🚀）与落后（🐢）全息图示。

---

## 🚀 部署与使用

1. 确保已安装 Starship：
   ```powershell
   scoop install starship
   ```
2. 复制配置文件至用户目录：
   ```powershell
   Copy-Item .\starship.toml "$env:USERPROFILE\.config\starship.toml" -Force
   ```
3. 在各终端中启用：
   - **PowerShell**：Profile 已原生支持（可通过 `$env:POWERSHELL_THEME_MODE = 'starship'` 切换）；
   - **CMD**：通过 Clink 的 `starship.lua` 自动注入；
   - **NuShell**：在 `env.nu` 中通过 `starship init nu` 自动加载；
   - **Git Bash**：在 `~/.bashrc` 中写入 `eval "$(starship init bash)"`。
