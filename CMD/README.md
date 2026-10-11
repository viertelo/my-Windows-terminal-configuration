# 🖥️ Windows CMD 现代极速增强配置

本目录包含了将原生 Windows 命令提示符（`cmd.exe`）升级为现代化开发终端的完整配置集。结合 **Clink** 命令行增强引擎与 **Starship** 跨平台提示符，彻底解决原生 CMD 无法智能补全、无语法高亮、提示符简陋、不支持现代别名的问题。

---

## 📁 目录结构

```text
CMD/
├── autorun.cmd            # CMD 启动自动注入脚本（UTF-8、Doskey 别名、Clink/Fastfetch 启动）
├── README.md              # 本说明文档
└── clink/                 # Clink 增强引擎配置与脚本
    ├── clink_settings     # Clink 全局偏好（自动补全策略、光标模式、历史记录容量）
    ├── settings.lua       # Clink Lua 配置（输入着色、模糊匹配、双字节字符优化）
    └── starship.lua       # Starship 提示符集成过滤器（自适应路径、毫秒级响应）
```

---

## 🚀 核心特性

1. **自动注入与代码页统一**：
   - 自动执行 `chcp 65001` 设置控制台编码为 UTF-8，彻底解决中文乱码与符号截断。
   - 智能识别批处理调用模式，过滤 `/c`、`/k` 与递归调用，保证脚本静默执行不干扰外部构建。
2. **Bash 风格现代化快捷别名 (Doskey)**：
   - 目录与文件：`..`, `...`, `ls`, `ll`, `la`, `lt`, `lt3`（集成 `eza` 图标与色彩）。
   - 查看与检索：`cat`, `catp`（集成 `bat` 高亮），`grep`（`ripgrep`），`f`（`fzf`）。
   - 模糊检索神兵：`tv`, `tvd`, `tvf`, `tvt`, `tvb`（集成 `television`）。
   - 目录树编号：`tre`（带快速编号与打开）。
   - 极速 Git 工作流：`gst`, `ga`, `gaa`, `gc`, `gca`, `gco`, `gcb`, `gb`, `gsw`, `glog`, `gpull`, `gps`, `gd`, `gundo`, `lg`（`lazygit`）。
   - 现代工具：`y`（Yazi 文件管理）、`v`（Neovim）、`c`（VS Code）、`ports`（端口占用）、`myip`。
3. **Clink 赋能的交互式体验**：
   - 命令建议与实时自动补全（基于历史记录与参数规则）。
   - 终端 24-bit 语法输入着色（可执行命令、标志位、错误路径高亮区分）。
   - 历史记录持久化（支持最多 25000 条，智能去重）。
4. **Starship 炫彩双行提示符**：
   - 毫秒级命令执行耗时统计。
   - Git 分支与工作区干净度实时指示。
   - 跨机器自适应路径解析（自动探测 Scoop 与全局 PATH）。

---

## ⚙️ 本地安装与配置

### 1. 部署 `autorun.cmd`
将 `CMD/autorun.cmd` 放置于：
```text
%USERPROFILE%\.config\cmd\autorun.cmd
```

在 Windows 注册表中配置 `cmd.exe` 启动时自动加载该脚本（在 PowerShell 或 CMD 中运行）：
```cmd
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "@if exist \"%USERPROFILE%\.config\cmd\autorun.cmd\" call \"%USERPROFILE%\.config\cmd\autorun.cmd\"" /f
```

> ⚠️ **编码与换行符注意事项**：
> - 批处理脚本必须保存为 **无 BOM UTF-8 (UTF-8 without BOM)** 编码，若包含 UTF-8 BOM 头，中文 Windows 下会引发 `'锘緻echo'` 报错。
> - 换行符必须严格使用 **CRLF**（`\r\n`），切勿保存为 Unix LF。

### 2. 部署 Clink 配置
将 `CMD/clink/` 下的所有文件复制到 Clink 本地配置目录：
```text
%LOCALAPPDATA%\clink\
```
即对应文件：
- `%LOCALAPPDATA%\clink\clink_settings`
- `%LOCALAPPDATA%\clink\settings.lua`
- `%LOCALAPPDATA%\clink\starship.lua`

---

## 💡 快捷指令与速查手册

启动 CMD 后，可随时输入以下命令获取交互式指引：
```cmd
shortcuts
# 或
help-cmd
```

若您希望在启动 CMD 时跳过欢迎指引卡片或系统硬件看板，可设置环境变量：
```cmd
set CMD_PROFILE_TIPS=0
set CMD_PROFILE_BANNER=0
```
