#              _
#      _______| |__  _ __ ___
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__
#   (_)___|___/_| |_|_|  \___|
#
# The Zsh Shell Configuration File


# ------------------ Environment Vars (zsh specific) ----------------

## Shell agonastic variables are in `.config/uwsm/env*`

export AUTO_NOTIFY_EXPIRE_TIME=5000

export AUTO_NOTIFY_IGNORE=("docker" "top" "htop" "btm" "nvim" "vim"
                            "nano" "man" "less" "more" "tig" "watch"
                            "git commit" "ssh" "lazygit" "cat" "bat"
                            "batman" "lf" "yazi"
)


# ------------------------ Pre Commands -----------------------------

fastfetch -c ~/.config/fastfetch/small.jsonc



#_______________________Shell Integrations_____________________________

source $ZDOTDIR/modules/Init.zsh && import-mod --all

eval_fzf

eval "$(zoxide init zsh --cmd cdz)"

handlr set x-scheme-handler/terminal "$(get-desktop-file $TERMINAL)"


#_____________________________Plugins____________________________________
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
command -v notify-send &> /dev/null && zinit light MichaelAquilina/zsh-auto-notify
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
#zinit load atuinsh/atuin


#________________Snippets________________
zinit snippet OMZP::command-not-found
zinit snippet OMZP::archlinux


#______________Plugins Options____________

# Load completions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza --almost-all --group-directories-first --color=always $realpath'
eval "$(register-python-argcomplete pipx)"


#_____________________________key-bindings_________________________________
export KEYTIMEOUT=1
bindkey -v
bindkey -v '^L' autosuggest-accept
bindkey -v '^p' history-search-backward
bindkey -v '^n' history-search-forward
#bindkey -M viins '^j' fzf-history-widget
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj


#_______________________________History____________________________________
HISTSIZE=100000
HISTFILE=${ZDOTDIR}/.history.zsh
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt correct
setopt INTERACTIVE_COMMENTS


#____________________________Aliases_______________________________________
alias :q='exit'
alias open="handlr open"
alias sudo='sudo ' # expand aliases with sudo
alias ls='eza -a --sort=name --group-directories-first --icons=auto --hyperlink'
alias tree='eza --tree -L 4 --group-directories-first --icons=auto  --hyperlink'
alias cp='cp -ri'
alias cd='cd_ls'
alias mkdir='mkdir -p'
alias reload='clear; source $ZDOTDIR/.zshrc'
alias ZZ="exit"
alias CC='clear'
alias rmrf="rm -rf"
alias nv='nvim'
alias snv='sudoedit'
alias chhostname="hostnamectl set-hostname"
alias cat='bat'
alias man='batman'
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias lnr='ln_relative'
alias papirus-folders='pprus_ch_fldr_clr'
alias reboot='echo " reebooting......" && sleep 5 && reboot'
alias sdmp='sudo rm -rf /opt/lampp/htdocs/sdmp && sudo cp ~/Documents/git/SDMP/  /opt/lampp/htdocs/sdmp '
alias xampp='sudo /opt/lampp/lampp '
# alias docker-compose='podman-compose'

alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"

# git
alias ghc="github_clone"
alias gc="git clone"
alias gb="git branch"
alias ga="git add"
alias gm="git merge"
alias gp="git push"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcs="git commit -S -m"
alias gd="git difftool"
alias gpr="gh pr create"
alias gr="git rebase -i"
alias gs="git status -sb"
alias gt="git tag"
