# =============================================================================
# NuShell Main Configuration (config.nu)
# Windows 现代终端美化与极速工作流套件
# =============================================================================

# 1. 基础体验与表格渲染优化
$env.config.show_banner = false
$env.config = ($env.config? | default {} | merge {
    show_banner: false
    table: {
        mode: "rounded"
        index_mode: "auto"
    }
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "plaintext"
    }
    edit_mode: "emacs"
    cursor_shape: {
        emacs: "line"
        vi_insert: "line"
        vi_normal: "block"
    }
})

# 2. 启动横幅 (Fastfetch)
if ($nu.is-interactive? | default false) and (($env.PROFILE_BANNER? | default "1") != "0") and (which fastfetch | is-not-empty) {
    let conf_file = ("~/.config/fastfetch/config.jsonc" | path expand)
    if ($conf_file | path exists) {
        ^fastfetch -c $conf_file
    } else {
        ^fastfetch
    }
}

# 3. 现代化功能就绪指示卡片
if ($nu.is-interactive? | default false) and (($env.PROFILE_TIPS? | default "1") != "0") {
    if (which yazi | is-not-empty) {
        print "  ✓ yazi 文件管理器已集成 (命令: y, yazi)"
    }
    if (which bat | is-not-empty) and (which eza | is-not-empty) {
        print "  ✓ bat + eza 现代化语法与图标集成完成"
    }
    if (which eza | is-not-empty) {
        print "  ✓ eza 现代目录树与列表已启用 (别名: ls, ll, la, lt, lt3)"
    }
    if (which bat | is-not-empty) {
        print "  ✓ bat 代码高亮查看已启用 (别名: cat, catp)"
    }
    if (which tv | is-not-empty) {
        print "  ✓ television 模糊检索已启用 (别名: tv, tvd, tvf, tvt, tvb, tvcd)"
    }
    if (which tre | is-not-empty) {
        print "  ✓ tre 智能树状目录与快速编号已启用 (别名: tre)"
    }
    if (which zoxide | is-not-empty) {
        print "  ✓ zoxide 智能目录跳转已启用 (命令: z, zi)"
    }
    if (which fastfetch | is-not-empty) {
        print "  ✓ fastfetch 终端硬件看板已加载"
    }
    print ""
}

# 4. 现代化命令行常用别名 (Eza, Bat, Git, Television, Tre)
# --- 目录与文件列表 ---
alias ls = ^eza --icons
alias ll = ^eza -l --icons --git --header --group-directories-first
alias la = ^eza -la --icons --git --header --group-directories-first
alias l = ^eza -l --icons
alias lt = ^eza --tree --level=2 --icons --group-directories-first
alias lt3 = ^eza --tree --level=3 --icons --group-directories-first
alias tre = ^tre -e

# --- 代码高亮与文件查看 ---
alias cat = ^bat --paging=never
alias catp = ^bat

# --- Television 交互式检索 ---
alias tv = ^tv
alias tvd = ^tv dirs
alias tvf = ^tv files
alias tvt = ^tv text
alias tvb = ^tv git-branch

# Television 智能目录交互跳转
def --env tvcd [] {
    let dir = (^tv dirs | str trim)
    if ($dir | is-not-empty) and ($dir | path exists) {
        cd $dir
    }
}

# --- Git 极速工作流 ---
alias g = git
alias gst = git status
alias ga = git add
alias gaa = git add --all
alias gc = git commit -m
alias gcm = git commit -m
alias gca = git commit --amend
alias gco = git checkout
alias gcb = git checkout -b
alias gb = git branch
alias gsw = git switch
alias glog = git log --oneline --graph --decorate --all
alias gpull = git pull
alias gps = git push
alias gd = git diff
alias gundo = git reset --soft HEAD~1
alias lg = lazygit
alias lzg = lazygit
alias lzd = lazydocker

# --- 现代开发工具与编辑器 ---
alias v = ^nvim
alias c = ^code
alias y = ^yazi
