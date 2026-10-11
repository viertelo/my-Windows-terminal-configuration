# =============================================================================
# Bash Configuration (.bashrc)
# 适用于 Windows 环境下的 Git Bash 与 MSYS2
# Windows 现代终端美化与极速工作流套件
# =============================================================================

# 非交互式 Shell 直接退出，保证自动化脚本执行效率
[[ "$-" != *i* ]] && return

# 1. 继承 Windows 本机环境变量与现代 CLI 工具路径
export MSYS2_PATH_TYPE=inherit
WIN_USER="${USERNAME:-$USER}"

for p in \
    "/c/Users/$WIN_USER/scoop/shims" \
    "/c/Users/$WIN_USER/AppData/Local/Microsoft/WinGet/Links" \
    "/c/Users/$WIN_USER/AppData/Local/Microsoft/WindowsApps" \
    "/c/Program Files/Neovim/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin"; do
    [ -d "$p" ] && [[ ":$PATH:" != *":$p:"* ]] && export PATH="$PATH:$p"
done

# 2. 强制 UTF-8 编码与中文语言环境
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. Starship 跨平台赛博朋克提示符集成
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# 4. Zoxide 极速目录智能跳转集成
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# 5. Fastfetch 动漫硬件看板展示
if command -v fastfetch &> /dev/null && [ "${PROFILE_BANNER:-1}" != "0" ] && [ -t 1 ]; then
    FF_CONF="/c/Users/$WIN_USER/.config/fastfetch/config.jsonc"
    if [ -f "$FF_CONF" ]; then
        fastfetch -c "$FF_CONF" 2>/dev/null
    else
        fastfetch 2>/dev/null
    fi
fi

# 6. 现代化功能就绪卡片
if [ "${PROFILE_TIPS:-1}" != "0" ] && [ -t 1 ]; then
    command -v yazi &> /dev/null && echo -e "  \033[32m✓ yazi 文件管理器已集成 (命令: y, yazi)\033[0m"
    command -v bat &> /dev/null && command -v eza &> /dev/null && echo -e "  \033[32m✓ bat + eza 现代化语法与图标集成完成\033[0m"
    command -v eza &> /dev/null && echo -e "  \033[32m✓ eza 现代目录树已启用 (别名: ls, ll, la, lt, lt3)\033[0m"
    command -v bat &> /dev/null && echo -e "  \033[32m✓ bat 代码高亮查看已启用 (别名: cat, catp)\033[0m"
    command -v tv &> /dev/null && echo -e "  \033[35m✓ television 模糊检索已启用 (别名: tv, tvd, tvf, tvt, tvb, tvcd)\033[0m"
    command -v tre &> /dev/null && echo -e "  \033[36m✓ tre 智能树状目录与快速编号已启用 (别名: tre)\033[0m"
    command -v git &> /dev/null && echo -e "  \033[36m✓ Git 快捷别名已加载 (g, gst, ga, gc, gco, gb, glog, lg)\033[0m"
    command -v zoxide &> /dev/null && echo -e "  \033[33m✓ zoxide 智能跳转已启用 (命令: z, zi)\033[0m"
    command -v starship &> /dev/null && echo -e "  \033[35m✓ Starship 赛博朋克提示符已加载\033[0m"
    command -v fastfetch &> /dev/null && echo -e "  \033[90m✓ fastfetch 终端硬件看板已加载\033[0m"
    echo ""
fi

# 7. 现代化命令行常用别名
# --- 目录导航与列表 ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git --header --group-directories-first'
    alias la='eza -la --icons --git --header --group-directories-first'
    alias l='eza -l --icons'
    alias lt='eza --tree --level=2 --icons --group-directories-first'
    alias lt3='eza --tree --level=3 --icons --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -lah'
    alias l='ls -CF'
fi

# --- Tre 智能目录树 ---
if command -v tre &> /dev/null; then
    alias tre='tre -e'
fi

# --- 代码高亮与文件查看 ---
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
fi

# --- 模糊搜索与检索 ---
if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# --- Television (tv) 交互式多频道检索 ---
if command -v tv &> /dev/null; then
    alias tv='tv'
    alias tvd='tv dirs'
    alias tvf='tv files'
    alias tvt='tv text'
    alias tvb='tv git-branch'

    # Television 智能目录交互跳转
    tvcd() {
        local dir
        dir=$(tv dirs 2>/dev/null)
        if [ -n "$dir" ] && [ -d "$dir" ]; then
            cd "$dir" || return
        fi
    }
fi

# --- Git 极速工作流 ---
alias g='git'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gsw='git switch'
alias glog='git log --oneline --graph --decorate --all'
alias gpull='git pull'
alias gps='git push'
alias gd='git diff'
alias gdiff='git diff'
alias gundo='git reset --soft HEAD~1
alias lg='lazygit'
alias lzg='lazygit'
alias lzd='lazydocker'

# --- 现代开发工具与编辑器 ---
alias v='nvim'
alias c='code'
alias y='yazi'

# --- 帮助手册 ---
shortcuts() {
    cat << 'EOF'
========================================================================
             Windows Bash (Git Bash / MSYS2) 常用快捷指令
========================================================================
[1] 目录与列表:
    .. / ... / ....   跨级目录快速返回
    ls / ll / la      eza 现代着色与图标列表
    lt / lt3          深度 2 / 3 目录树
    tre               带快速编号与打开的树状目录
    y                 启动 Yazi 文件管理器
    z <名称>          Zoxide 智能跳转
    tvcd              Television 模糊挑选目录并直接进入

[2] 查看与检索:
    cat <文件>        免分页 bat 语法高亮
    catp <文件>       带分页 bat 语法高亮
    grep <关键词>     ripgrep 极速正则搜索
    tv / tvd / tvf    Television 多频道检索 (全能 / 目录 / 文件)
    tvt / tvb         Television 全文文本检索 / Git 分支检索

[3] Git 极速操作:
    gst               git status
    ga / gaa          git add / git add --all
    gc "信息"         git commit -m
    gco / gcb / gsw   检出 / 新建并检出 / 切换分支
    gpull / gps       git pull / git push
    glog              单行图形化提交历史
    gundo             撤销最近一次提交并保留代码
    lg                启动 lazygit 全键盘控制台

[4] 编辑器与工具:
    v <文件>          Neovim 代码编辑
    c <路径>          VS Code 打开
    shortcuts         查看本帮助卡片
========================================================================
EOF
}
alias help-bash='shortcuts'
