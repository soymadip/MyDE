#!/usr/bin/env bash

#   ___        _      _       _           _
#  / _ \ _   _| |_ __| | __ _| |_ ___  __| |
# | | | | | | | __/ _` |/ _` | __/ _ \/ _` |
# | |_| | |_| | || (_| | (_| | ||  __/ (_| |
#  \___/ \__,_|\__\__,_|\__,_|\__\___|\__,_|
#

install_pkgs() {
  prompt "Do you want to install apps?" confirm_pkgs
  if [ "$confirm_pkgs" == "y" ] || [ "$confirm_pkgs" == "Y" ] || [ -z "$confirm_pkgs" ]; then
    # Repo:
    log.warn "Installing Repo packages"
    sudo pacman -S --noconfirm "${pacman_packages[@]}"
    log.success "Repo packages installed."
    # AURs:
    log.warn "Installing AUR packages,"
    log.warn "Please carefully select options when asked:"
    yay -S "${aur_packages[@]}"
    footer "AUR packages installed."
  else
    echo -e "${RED}Packages' Installation skipped.${NC}"
  fi
}

# \\\\\\\\\\\\\\\\\\ Triggering Functions ///////////////////////
eval "$(kireisakura --init)"

# setup_KireiKit
confirm_start_script
kimport install_additional-repo install_all_packages restore_dotfiles change_papirus-folder_color change_shell enable_sudo_feedback
. packages.sh

# Change shell to zsh
if ! change_shell; then
  log "please reboot system & run this script again..." inform
  log "rebooting in 3 seconds..." inform && sleep 3 && reboot
fi

# Enable sudo password enter feedback
enable_sudo_feedback

# Stow dotfiles
stow_restore

# Installing additional repos & packages
install_additional_repos
install_all_packages core_pckgs rice_pckgs hypr_core_pckgs cli_pckgs user_pckgs
# Change wallpaper, icon theme, cursor theme
# change_wallpaper "$HOME/Pictures/ADMIN/catppuccin-lofi.jpeg"
# change_icon_theme "Papirus-Dark"
change_papirus_folder_color "cat-mocha-lavender" "Papirus-Dark"
# change_cursor_theme "catppuccin-frappe-lavender-cursors" "32"
#
# set sddm theme
# change_sddm_theme breeze

# install neovim chad git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
