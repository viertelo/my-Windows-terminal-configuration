# 🐚 Windows Bash (Git Bash & MSYS2) 现代终端配置

本目录包含了专为 Windows 环境下的 **Git Bash** 与 **MSYS2 Bash** 深度定制的生产级终端配置。解决了传统 Windows Bash 环境下路径割裂、缺失 Windows 原生 CLI 工具、无自动提示符、无美化与中文乱码的问题。

---

## 📁 目录结构

```text
Bash/
├── .bashrc                # Git Bash & 通用 Bash 主配置文件（工具路径继承、别名、tvcd、Starship）
├── .bash_profile          # 登录 Shell 引导文件（自动载入 .profile 与 .bashrc）
├── msys2.bashrc           # MSYS2 完整环境配置文件（保留原生系统环境 + 现代化增强套件）
└── README.md              # 本说明文档
```

---

## 🚀 核心特性

1. **Windows 本机工具链无缝继承**：
   - 自动继承并优先挂载 Windows 原生安装的工具路径（`Scoop shims`、`WinGet`、`WindowsApps`、`Neovim`、`Cargo` 等）。
   - 无需在 MSYS2 或 Git Bash 内重复安装重复工具，直接全局无缝调用 `starship`, `fastfetch`, `eza`, `bat`, `yazi`, `tv`, `tre`, `lazygit` 等。
2. **强制 UTF-8 与中文语言环境**：
   - 显式导出 `LANG=zh_CN.UTF-8` 与 `LC_ALL=zh_CN.UTF-8`，消除终端中文文件名、日志和 Git Commit 字符乱码。
3. **Starship 炫彩双行提示符**：
   - 毫秒级执行时长、Git 分支与暂存状态动态显示。
4. **多维模糊检索与目录跳转 (Television & Zoxide)**：
   - `tv`：启动 Television 全能模糊检索。
   - `tvd` / `tvf` / `tvt` / `tvb`：按目录、文件、文本全文、Git 分支专属筛选。
   - `tvcd`：Bash 专属交互跳转函数，运行 `tv dirs` 选择目标后自动 `cd` 进入该目录。
   - `z` / `zi`：Zoxide 极速目录智能跳转。
5. **现代文件系统工具全面映射**：
   - `ls`, `ll`, `la`, `lt`, `lt3`：基于 `eza` 的图标着色与文件夹优先排序。
   - `tre`：带标号彩色树状目录，可直接利用编号快速打开文件。
   - `cat`, `catp`：基于 `bat` 的语法高亮查看。
   - `y`：启动 Yazi 终端双栏文件管理器。
6. **Git 极速单字母与缩写别名**：
   - `g`, `gst`, `ga`, `gaa`, `gc`, `gca`, `gco`, `gcb`, `gb`, `gsw`, `glog`, `gpull`, `gps`, `gd`, `gundo`, `lg` (lazygit)。

---

## ⚙️ 本地安装与同步

### 方式 A：自动化一键部署（推荐）
在仓库根目录下运行：
```powershell
.\install.ps1
```
脚本将自动创建快照备份并将 `Bash/.bashrc`、`.bash_profile` 与 `msys2.bashrc` 安全部署至对应家目录。

### 方式 B：手动部署

#### 1. Git Bash 部署
Git Bash 读取当前 Windows 用户家目录下的配置文件：
```text
%USERPROFILE%\.bashrc
%USERPROFILE%\.bash_profile
```
将本仓库文件复制到家目录：
- `Bash/.bashrc` ➔ `%USERPROFILE%\.bashrc`
- `Bash/.bash_profile` ➔ `%USERPROFILE%\.bash_profile`

#### 2. MSYS2 部署
MSYS2 读取其独立家目录下的配置文件（例如：`C:\msys64\home\<用户名>\.bashrc`）：
- 将 `Bash/msys2.bashrc` 复制或合并至 `C:\msys64\home\<用户名>\.bashrc`。

---

## 💡 快捷指令速查

在终端中可随时输入 `shortcuts` 或 `help-bash` 查看内置手册：

| 指令 | 作用 | 说明 |
| :--- | :--- | :--- |
| `tvcd` | 交互式目录跳转 | 通过 Television 模糊检索目录并直接进入 |
| `tre` | 现代树状目录 | 替代传统 tree，支持彩色语法与文件标号 |
| `y` | Yazi 文件管理 | 启动双栏终端可视化文件管理面板 |
| `cat <文件>` | 免分页高亮 | 使用 bat 进行代码语法着色浏览 |
| `ll` / `la` | 现代文件列表 | 详细文件属性，包含 Git 状态与分类图标 |
| `gst` | Git 状态 | 查看暂存区与未跟踪文件 |
| `lg` | Lazygit | 启动全键盘交互式 Git 控制台 |
| `shortcuts` | 查看命令指南 | 随时调出内置快捷键手册 |
