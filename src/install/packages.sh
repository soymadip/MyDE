rice_pckgs=(

  "ttf-hack-nerd"
  "ttf-noto-nerd"
  "ttf-firacode-nerd"
  "ttf-jetbrains-mono-nerd"

  "papirus-icon-theme"
  "papirus-folders-catppuccin-git"
  "catppuccin-cursors-mocha"
  "archlinux-tweak-tool-git"
  "colloid-catppuccin-gtk-theme-git"
  "catppuccin-gtk-theme-macchiato"
  "kvantum-theme-catppuccin-git"

  "fastfetch"
  # "catnap" # fastfetch with small config
  "nwg-look"
  "qt5ct"
  "qt6ct"
  "kvantum"
  "kvantum-qt5"
  "plymouth-theme-catppuccin-mocha-git"
)

nvidia_pckgs=(
  "nvidia-dkms"
  "nvidia-utils"
  "libva-nvidia-driver"
  "nvidia-settings"
)

sys_pckgs=(
  "intel-ucode"

)

pre_pckgs=(
  "zsh"
  "xorg-xwayland"
  "xorg-xhost"
)

core_pckgs=(

  "qt5-wayland"
  "qt6-wayland"

  "gnome-keyring"
  "pacman-contrib"
  "paru"
  "pacseek" # tui for pacman

  "wl-clipboard"

  "handlr-regex"
  "intel-ucode"
  "libva-intel-driver"
  "vulkan-intel"
  "wget"
  "upower"
  "fwupd"
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
  "p7zip"
  "unrar"
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
  "trash-cli"
  "rclone"
  "python-pip"
  "flatpak"
  "flatpak-xdg-utils"
  "flatseal"
  "sshfs"
  "ddcutil"
  "android-file-transfer"
  "archlinux-xdg-menu"
  "brightnessctl"
  "bun-bin"
  "fzf"
  "imagemagick"

)

cli_pckgs=(

  # "kitty"
  "wezterm-git"

  "neovim"
  "luarocks"

  #"lsd"
  "eza"

  "bottom"
  "fzf"
  "ffmpegthumbnailer"

  "bat"
  "bat-extras"

  "yazi"
  "jq"
  "fd"
  "ripgrep"
  "chafa"
  "zoxide"

  "zathura"
  "zathura-pdf-poppler"
  "zathura-cb"

  "syncthing"
  "figlet"
  "rclone"
  "dust"
  "yt-dlp"
  "lazygit"
  "ookla-speedtest-bin"
  "yad" # bash gtk popup

  "ruff"

  "ouch"
)

kde_core_pckgs=(

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

hypr_core_pckgs=(

  "hyprland"
  "xdg-desktop-portal-hyprland"
  "xdg-desktop-portal-gtk" # for file picker
  "polkit-gnome"
  "hyprpaper"
  "hyprlock"
  "hypridle"
  "hyprpicker"
  "hyprsunset"
  "grimblast"
  "copyq"
  "rofi-wayland"
  "network-manager-applet"
  "ags-hyprpanel"
)

user_pckgs=(

  "vorta"
  "vorta-root"

  "thunar"
  "thunar-archive-plugin"
  "thunar-vcs-plugin"
  "thunar-volman"
  "gvfs-mtp"
  "tumbler"

  "okular"

  "visual-studio-code-bin"

  "github-desktop"
  "mpv"
  "vlc"
  "obsidian"
  "firefox-pwa"
  "brave-binvista"
  "64gram-desktop"
  "keepassxc"
  #"kwrite"
  "pluma"

  #"ark"
  "xarchiver"

  "kasts"
  "ktorrent"

  #"gwenview"
  "nomacs"

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
  "flatsea"             # flatpak permission manager
  "xwaylandvideobridge" # Enable video share with xwayland apps
  "webcord"             # Discord client reinpimentation
  "smassh"
)
