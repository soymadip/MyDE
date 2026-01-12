#              _
#      _______| |__  _ __ ___
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__
#   (_)___|___/_| |_|_|  \___|
#
# Variables & Configuration for Interactive shell (eg, Terminal Emulators)
#


#=========================== Configuration =============================

# Zsh Specific
export ZSH_HISTORY_LIMIT=200000
export ZSH_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zinit"

## vi mode
export VI_MODE_ESCAPE_BIND=jj

## "ice-options | plugin-name"
typeset -a ZSH_PLUGINS=(
    "depth=1 | romkatv/powerlevel10k"
    "depth=1 | jeffreytse/zsh-vi-mode"

    "zdharma-continuum/fast-syntax-highlighting"
    "zsh-users/zsh-completions"
    "zsh-users/zsh-autosuggestions"
    "Aloxaf/fzf-tab"
)

typeset -a ZSH_SNIPPETS=(
    "OMZP::command-not-found"
    "OMZP::archlinux"
)

# System summary config
export SYS_FETCH_CONF="${XDG_CONFIG_HOME:-${HOME}/.config}/fastfetch/small.jsonc"

# Starship Config Location
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship/starship.log"

# Auto Notify plugin
export AUTO_NOTIFY_EXPIRE_TIME=3000
export AUTO_NOTIFY_IGNORE=(
                            "docker" "top" "htop" "btm" "nvim" "vim"
                            "nano" "man" "less" "more" "tig" "watch"
                            "git commit" "ssh" "lazygit" "cat" "bat"
                            "batman" "lf" "yazi" "lg"
)

# FZF
export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore --exclude .git'
export FZF_DEFAULT_OPTS='--multi '


#================================================================================


# ---------------------- System summary -----------------------

fastfetch -c "$SYS_FETCH_CONF"
# catnap


#-------------------------- Powerlevel 10k -------------------------

# instant prompt
if [[ -r "${xdg_cache_home:-$home/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${xdg_cache_home:-$home/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source "$ZDOTDIR/.p10k.zsh"


#------------------- CompInit ------------------

[[ ! -d "$ZSH_CACHE" ]] && mkdir -p "$ZSH_CACHE"

autoload -Uz compinit
compinit -d "$ZSH_CACHE/compdump"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza --almost-all --group-directories-first --color=always $realpath'

#-------------------- Source FZF ---------------------------

if command -v fzf &> /dev/null; then

    _fzf_ver=$(fzf --version | cut -d' ' -f1)

    # Check if >= 0.48.0 using sort -V
    if [[ $(echo "$_fzf_ver 0.48.0" | tr " " "\n" | sort -V | head -n1) = "0.48.0" ]]; then
        source <(fzf --zsh)
    else
        # Legacy fallback
        [[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
        [[ -f /usr/share/fzf/shell/completion.zsh ]]   && source /usr/share/fzf/shell/completion.zsh
    fi

    unset _fzf_ver
fi


#------------------ Plugins -----------------------

if [ ! -d "$ZINIT_HOME" ]; then
   echo -e "Installing zinit in ${ZINIT_HOME}" >&2
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
   echo "Done" >&2
fi

source "${ZINIT_HOME}/zinit.zsh"

if command -v notify-send &> /dev/null; then
    ZSH_PLUGINS+=("MichaelAquilina/zsh-auto-notify")
fi

for entry in "${ZSH_PLUGINS[@]}"; do
    if [[ "$entry" == *"|"* ]]; then

        __ice_params="${entry%|*}"
        __repo="${entry#*|}"

        zinit ice "${=__ice_params}"
        zinit light "${__repo## }"
    else
        # Standard load
        zinit light "$entry"
    fi
done

for snippet in "${ZSH_SNIPPETS[@]}"; do
    zinit snippet "$snippet"
done


#-------------------- Intigrations ------------------------

eval "$(zoxide init zsh --cmd cdz)"
eval "$(direnv hook zsh)"
eval "$(register-python-argcomplete pipx)"
eval "$(register-python-argcomplete cz)"
eval "$(niri completions zsh)"


#------------------- key-bindings ------------------------

export KEYTIMEOUT=1
bindkey -v
bindkey -v '^L' autosuggest-accept
bindkey -v '^p' history-search-backward
bindkey -v '^n' history-search-forward
# bindkey -M viins '^j' fzf-history-widget
ZVM_VI_INSERT_ESCAPE_BINDKEY="$VI_MODE_ESCAPE_BIND"


#--------------------- History -------------------------

SAVEHIST=$ZSH_HISTORY_LIMIT
HISTFILE=$ZSH_CACHE/history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt correct
setopt INTERACTIVE_COMMENTS


#--------------------- Modules -------------------------

for mod_file in "$ZDOTDIR/rc.d/modules"/*.zsh; do
    if [ -f "$mod_file" ]; then
        source "$mod_file"
    else
        echo "Failed to source module file: $(basename "$mod_file")" >&2
    fi
done


#--------------------- Aliases -------------------------

for aliasf in "$ZDOTDIR/rc.d/"*; do
    if [ -f "$aliasf" ] && [ -r "$aliasf" ]; then
        source "$aliasf"
    fi
done

# Misc
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
alias lnr='ln_relative'
alias papirus-folders='pprus_ch_fldr_clr'
alias reboot='echo " reebooting......" && sleep 2 && systemctl reboot'
alias nctl='niri msg '
alias sdmp='sudo rm -rf /opt/lampp/htdocs/sdmp && sudo cp ~/Documents/git/SDMP/  /opt/lampp/htdocs/sdmp '
# alias xampp='sudo /opt/lampp/lampp '
# alias docker-compose='podman-compose'
alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
