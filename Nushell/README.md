# 🐚 NuShell 现代化极速终端配置

本目录包含了基于结构化数据管道的现代化 Shell —— **NuShell** 的完整生产级美化与生产力增强套件。全面集成了 **Starship** 炫彩提示符、**Television** 极速模糊检索、**Tre** 智能树状目录、**Zoxide** 智能跳转与 **Fastfetch** 系统看板。

---

## 📁 目录结构

```text
Nushell/
├── config.nu              # NuShell 主运行配置（表格圆角、启动横幅、高频别名、tvcd 跳转）
├── env.nu                 # NuShell 环境变量配置（UTF-8 语言环境、autoload 目录初始化）
├── README.md              # 本说明文档
└── vendor/
    └── autoload/          # 启动自动加载扩展模块目录
        ├── starship.nu    # Starship 跨平台动态提示符适配模块
        └── zoxide.nu      # Zoxide 极速目录智能跳转模块
```

---

## 🚀 核心功能与亮点

1. **结构化表格与界面美化**：
   - 启用现代 `rounded` 圆角精致表格边框，自动数据类型对齐。
   - 交互式启动自动加载 Fastfetch 硬件动漫看板。
   - 启动时自动进行工具健康检查，展示绿色现代化功能就绪指示卡片。
2. **多维模糊检索与目录跳转 (Television & Zoxide)**：
   - `tv`：多频道交互式模糊搜索。
   - `tvd` / `tvf` / `tvt` / `tvb`：针对目录、文件、文本全文、Git 分支的专用快速检索。
   - `tvcd`：NuShell 专属函数，调用 `tv dirs` 选择目录后自动 `cd` 进入该目录。
   - `z` / `zi`：基于使用频次与权重的极速跨级目录跳转。
3. **现代文件系统工具全面映射**：
   - `ls`, `ll`, `la`, `lt`, `lt3`：基于 `eza` 的彩色图标与目录优先显示。
   - `tre`：带数字标号的彩色现代树状目录（可配合快捷编号命令直接打开文件）。
   - `cat`, `catp`：基于 `bat` 的语法高亮查看。
   - `y`：启动 Yazi 终端可视化文件管理器。
4. **Git 极速单字母与缩写别名**：
   - `g`, `gst`, `ga`, `gaa`, `gc`, `gca`, `gco`, `gcb`, `gb`, `gsw`, `glog`, `gpull`, `gps`, `gd`, `gundo`, `lg` (lazygit)。
5. **Starship 炫彩双行提示符自动注入**：
   - 模块化放置于 `vendor/autoload/starship.nu`，NuShell 启动时原生无感加载。
   - 执行毫秒级计时、Git 分支及状态实时监控。

---

## ⚙️ 本地安装与同步

### 方式 A：自动化一键部署（推荐）
在仓库根目录下运行：
```powershell
.\install.ps1
```
脚本将自动创建快照备份并将 `Nushell/config.nu`、`env.nu` 与 `vendor/autoload/` 完整同步至 `%APPDATA%\nushell\`。

### 方式 B：手动部署

#### 本地路径对应
NuShell 在 Windows 系统中的全局配置目录为：
```text
%APPDATA%\nushell\
```
您可在 NuShell 内输入以下命令查看确切路径：
```nu
$nu.config-path
$nu.env-path
```

#### 手动复制文件
将本目录下的所有文件复制到 `%APPDATA%\nushell\` 即可：
- `Nushell/config.nu` ➔ `%APPDATA%\nushell\config.nu`
- `Nushell/env.nu` ➔ `%APPDATA%\nushell\env.nu`
- `Nushell/vendor/autoload/*` ➔ `%APPDATA%\nushell\vendor\autoload\`

---

## 💡 常用指令速查

| 指令 | 作用 | 说明 |
| :--- | :--- | :--- |
| `tvcd` | 交互式目录跳转 | 通过 Television 模糊搜索目录并自动进入 |
| `tre` | 现代树状目录 | 替代传统 tree，支持彩色语法与文件标号 |
| `y` | Yazi 文件管理器 | 启动双栏终端文件管理面板 |
| `cat <文件>` | 代码高亮浏览 | 免分页语法高亮查看（底层调用 bat） |
| `ll` / `la` | 现代文件列表 | 详细文件属性，包含 Git 状态与分类图标 |
| `gst` | Git 状态 | 快速查看暂存区与未跟踪文件 |
| `lg` | Lazygit | 启动全键盘交互式 Git 控制台 |
| `z <关键字>` | 历史路径跳转 | Zoxide 智能模糊匹配目录 |
