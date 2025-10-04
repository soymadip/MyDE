

# Source Starship
# if command -v starship &>/dev/null; then
#   eval "$(starship init zsh)"
# else
#   curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
# fi



# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# Source zinit
ZINIT_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/zsh/zinit"
if [ ! -d "$ZINIT_HOME" ]; then
   echo -e "Installing zinit in ${ZINIT_HOME}" mkdir -p "$(dirname $ZINIT_HOME)0"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
   echo "done\n Sourcing zinit"
fi
source "${ZINIT_HOME}/zinit.zsh"


# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k


# Source prompt
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh



function import-mod {
  local module_names=("$@")
  local module_dir="$ZDOTDIR/modules"


  if [[ ${module_names[1]} == "--all" ]]; then

    for mod_file in "$module_dir"/*.zsh; do
      if [ -f "$mod_file" ]; then
        source "$mod_file"
      else
        echo "Failed to source module file: $(basename "$mod_file")"
      fi
    done

  else

    for module in "${module_names[@]}"; do
      local mod_file="$module_dir/$module.zsh"
      if [ -f "$mod_file" ]; then
        source "$mod_file"
      else
        echo "Failed to source module file: $(basename "$mod_file")"
      fi
    done

  fi
}
