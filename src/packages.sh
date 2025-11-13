rice_pckgs=(

  #Fonts
  "ttf-jetbrains-mono-nerd" "ttf-ubuntu-nerd" "ttf-firacode-nerd" "ttf-noto-nerd" "cantarell-fonts"

  #Icon Themes
  "papirus-icon-theme" "papirus-folders-catppuccin-git"

  #Cursor Themes
  "catppuccin-cursors-mocha"

  #GTK Themes
  "nwg-look" "colloid-catppuccin-gtk-theme-git"

  #QT Themes
  "qt6ct-kde" "breeze"

  #Tools
  "fastfetch" "archlinux-tweak-tool-git"
  # "catnap" # fastfetch with small config

  #Plymouth Themes
  "plymouth" "plymouth-theme-colorful-loop-git" "plymouth-theme-cuts-alt-git"
)

nvidia_pckgs=(
  "nvidia-dkms" "libva-nvidia-driver" "nvidia-utils"
  "nvidia-settings"
)

sys_pckgs=(
  "intel-ucode" "libva-intel-driver" "vulkan-intel"
  # "amd-ucode"
)

pre_pckgs=(
  "zsh"
  "xorg-xwayland" "xorg-xhost"
  "uwsm" "app2unit-git"
)

core_pckgs=(

  "qt5-wayland" "qt6-wayland"

  "kconfig"

  "ntfs-3g"

  "gnome-keyring"

  "rate-mirrors" "paru" "pacman-contrib" "pacseek" #tui for pacman

  "handlr-regex" "xdg-utils"

  "wget"
  "upower" "fwupd"
  "ufw"
  "xdg-desktop-portal"
  "gst-plugins-base"
  "gst-plugins-good"
  "gst-plugins-bad"
  "gst-libav"
  "cups"
  "cups-pk-helper"
  "system-config-printer"
  "power-profiles-daemon"
  "npm"
  "icu"
  "gvfs"
  "yt-dlp"
  "rsync"
  "enchant"
  "hunspell-en_US"
  "qt5-tools"
  "gtk4"
  "libdbusmenu-glib"
  "appmenu-gtk-module"
  "libappindicator-gtk3"
  "libayatana-appindicator"
  "trash-cli"
  "rclone"
  "flatpak"
  "flatpak-xdg-utils"
  "flatseal"
  "sshfs"
  "ddcutil"
  "android-file-transfer"
  "archlinux-xdg-menu" # XDG_MENU_PREFIX=arch- kbuildsycoca6   -> fixes dolphin app chosing menu.
  "brightnessctl"
  "fzf"
  "imagemagick"
)

cli_pckgs=(

  # "kitty"
  "wezterm-git"

  "neovim" "luarocks"

  "uv" "ruff"

  "eza"

  "bottom" "btop"
  "fzf"
  "ffmpegthumbnailer"

  "bat" "bat-extras"

  "yazi" "zoxide" "jq" "fd" "ripgrep" "chafa" "ouch"

  # "zathura" "zathura-pdf-poppler" "zathura-cb"

  "syncthing"
  "figlet"
  "rclone"
  "yt-dlp"
  "lazygit"
  "ookla-speedtest-bin"
  "yad" # bash gtk popup

)

plasma_pckgs=(

  "xdg-desktop-portal-kde"
  "flatpak-kcm"
  "kup"
  "kimageformats"
  "kio-admin"
  "packagekit-qt6"
  "kdialog"
  "kdeconnect"
  "kdeplasma-addons"
  "kwin-scripts-krohnkite-git"
  "kwin-effect-rounded-corners-git"
  "plasma-browser-integration"
  "librewolf-extension-plasma-integration"
  "kcalc"
  "spectacle"
)

hypr_pckgs=(

  "hyprland"
  "xdg-desktop-portal"
  "xdg-desktop-portal-gtk"
  "xdg-desktop-portal-hyprland"
  "polkit-gnome"
  "hyprpaper"
  "hyprlock"
  "hypridle"
  "hyprpicker"
  "hyprsunset"
  "grimblast"
  "satty"
  "rofi"
)

user_pckgs=(
  "nmgui"
  "bluez" "bluez-utils" "blueman"
  "vorta" "vorta-root"

  "vicinae-bin" "wl-clipboard"

  # "thunar" "thunar-archive-plugin" "thunar-vcs-plugin" "thunar-volman" "tumbler" "gvfs-mtp"

  "okular" "ebook-tools" "kdegraphics-mobipocket" # PDF viewer

  "visual-studio-code-bin"                                 # IDE (heavy)
  "zed" "hyprls-git" "shellcheck-bin" "direnv" # IDE, Text Editor
  "python" "uv"

  "mpv" "mpv-mpris" "yt-dlp"

  "obsidian"
  "firefox-pwa"
  "brave-bin"
  "64gram-desktop"

  "keepassxc" "git-credential-keepassxc"

  "ark" "unzip" "7zip" "tar" "unrar" "binutils" "arj"

  "kasts" "vlc"
  "ktorrent"

  "gwenview"
  # "nomacs"

  "gnome-disk-utility"
  "rclone-browser"
  "mkvtoolnix-gui"
  "gparted"
  "libreoffice-fresh"
  "ttf-vista-fonts"
  "ttf-vista-fonts"
  "ttf-ms-fonts"
  "appimagelauncher"
  "obs-studio"
  "ventoy-bin"
  "qalculate-gtk"
  "betterbird-bin"
)

opt_pckgs=(
  "junction"            # application chooser
  "flatseal"            # flatpak permission manager
  "xwaylandvideobridge" # Enable video share with xwayland apps
  "webcord"             # Discord client reinpimentation
  "smassh"
  "dust"
  "github-desktop"
)
