# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <https://creativecommons.org/publicdomain/zero/1.0/>. 

# ~/.bashrc: executed by bash(1) for interactive shells.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the msys2 mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func

# >>> Windows Terminal Beautification for MSYS2 >>>
# 1. 继承与补充 Windows 本机环境变量（允许直接调用 Windows 原生安装的 starship, fastfetch, eza, git, yazi, tv, tre 等工具）
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

# 2. 强制 UTF-8 与中文语言环境
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. Starship 赛博朋克提示符集成
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# 4. Fastfetch 终端横幅展示
if command -v fastfetch &> /dev/null && [ "${PROFILE_BANNER:-1}" != "0" ] && [ -t 1 ]; then
    FF_CONF="/c/Users/$WIN_USER/.config/fastfetch/config.jsonc"
    if [ -f "$FF_CONF" ]; then
        fastfetch --pipe false -c "$FF_CONF" 2>/dev/null
    else
        fastfetch --pipe false 2>/dev/null
    fi
fi

# 5. 现代化功能就绪卡片
if [ "${PROFILE_TIPS:-1}" != "0" ] && [ "${PROFILE_BANNER:-1}" != "0" ] && [ -t 1 ]; then
    command -v yazi &> /dev/null && echo -e "  \033[32m✓ yazi 文件管理器已集成 (命令: y, yazi)\033[0m"
    command -v bat &> /dev/null && command -v eza &> /dev/null && echo -e "  \033[32m✓ bat + eza 现代化预览集成完成\033[0m"
    command -v eza &> /dev/null && echo -e "  \033[32m✓ eza 现代化 ls 已启用 (别名: ls, ll, la, lt, lt3)\033[0m"
    command -v bat &> /dev/null && echo -e "  \033[32m✓ bat 代码高亮查看已启用 (别名: cat, catp)\033[0m"
    command -v tv &> /dev/null && echo -e "  \033[35m✓ television 模糊检索已启用 (别名: tv, tvd, tvf, tvt, tvb, tvcd)\033[0m"
    command -v tre &> /dev/null && echo -e "  \033[36m✓ tre 智能树状目录与快速编号已启用 (别名: tre)\033[0m"
    command -v git &> /dev/null && echo -e "  \033[36m✓ Git 快捷别名已加载 (g, gst, ga, gc, gco, gb, glog, lg)\033[0m"
    command -v zoxide &> /dev/null && echo -e "  \033[33m✓ zoxide 智能跳转已启用 (命令: z, zi)\033[0m"
    command -v starship &> /dev/null && echo -e "  \033[35m✓ Starship 赛博朋克提示符已加载\033[0m"
    command -v fastfetch &> /dev/null && echo -e "  \033[90m✓ fastfetch 系统信息工具已启动\033[0m"
    echo ""
fi

# 6. 现代化命令行常用别名 (Eza, Bat, Television, Tre, Git)
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
fi

if command -v tre &> /dev/null; then
    tre() {
        local editor="${EDITOR:-}"
        if [ -z "$editor" ] && command -v nvim &>/dev/null; then
            editor="nvim"
        fi
        if [ -n "$editor" ]; then
            command tre -e "$editor" "$@"
        else
            command tre -e "$@"
        fi
        local alias_file="${TEMP:-/tmp}/tre_aliases_${USERNAME:-$USER}.bat"
        if [ -f "$alias_file" ]; then
            while IFS= read -r line; do
                if [[ "$line" =~ ^doskey\ /exename=cmd\.exe\ (e[0-9]+)=(.+)$ ]]; then
                    local a_name="${BASH_REMATCH[1]}"
                    local a_cmd="${BASH_REMATCH[2]}"
                    if [[ "$a_cmd" =~ ^START\ (.*)$ ]]; then
                        alias "$a_name"="${editor:-start} \"${BASH_REMATCH[1]}\""
                    else
                        alias "$a_name"="$a_cmd"
                    fi
                fi
            done < "$alias_file"
        fi
    }
fi

if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v tv &> /dev/null; then
    alias tv='tv'
    alias tvd='tv dirs'
    alias tvf='tv files'
    alias tvt='tv text'
    alias tvb='tv git-branch'

    tvcd() {
        local dir
        dir=$(tv dirs 2>/dev/null)
        if [ -n "$dir" ] && [ -d "$dir" ]; then
            cd "$dir" || return
        fi
    }
fi

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
alias gundo='git reset --soft HEAD~1'
alias lg='lazygit'
alias lzg='lazygit'
alias lzd='lazydocker'

alias v='nvim'
alias c='code'
alias y='yazi'
# <<< Windows Terminal Beautification for MSYS2 <<<

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"
# <<< grok installer <<<
