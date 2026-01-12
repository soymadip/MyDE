pkgs=(

  #==================== Ricing =====================

  # Fonts
  "ttf-bitstream-vera" "ttf-dejavu" "ttf-liberation" "ttf-meslo-nerd" "ttf-opensans" "aur/ttf-sil-abyssinica"
  "ttf-jetbrains-mono-nerd" "ttf-ubuntu-nerd" "ttf-firacode-nerd" "ttf-noto-nerd" "cantarell-fonts"
  "noto-fonts" "noto-fonts-extra" "noto-fonts-cjk" "noto-fonts-emoji"

  # Icon Themes
  "papirus-icon-theme" "papirus-folders-catppuccin-git" "aur/catppuccin-gtk-theme-macchiato"

  # Cursor Themes
  "catppuccin-cursors-mocha"

  # GTK Theming
  "nwg-look" "colloid-catppuccin-gtk-theme-git"

  # QT Theming
  "qt6ct-kde" "qt5ct" "breeze" "breeze5"

  # Tools
  "fastfetch" #"catnap" # fastfetch with small config
  "font-manager"
  "stow"

  # Bar/drawer
  "waybar" "nwg-drawer" "aur/privacy-dots"

  # Plymouth Themes
  "plymouth" "plymouth-theme-colorful-loop-git" "plymouth-theme-cuts-alt-git"

  #================ Drivers =========================

  # Intel
  "intel-ucode" "libva-intel-driver" "vulkan-intel" "intel-media-driver"
  "lib32-mesa" "lib32-vulkan-intel"

  # Nvidia
  "nvidia-open-dkms" "libva-nvidia-driver" "nvidia-utils" "lib32-nvidia-utils"
  "nvidia-settings" "nvidia-prime"

  # FileSystem
  "ntfs-3g" "ntp"

  # Printing
  "cups" "bluez-cups" "print-manager"

  # Drawing
  "wacomtablet"

  #================== Core Utils ===================

  # Backbone
  "linux" "linux-headers" "linux-firmware"
  "grub" "grub-hook" "os-prober"

  "zsh" "sudo" "neovim" "tar"
  "paru" "pacman-contrib"

  # Display Servers
  "wayland" "egl-wayland" "wev"
  "xorg-xserver" "xorg-xwayland" "xwayland-satellite" "xorg-xhost"
  "xf86-input-libinput" "xorg-xinput" "xsettingsd"

  # systemd launchers
  "aur/app2unit-git"
  "dex" # dex -a -e Hyprland

  # BlueTooth
  "bluez" "bluez-utils" "bluez-libs" "bluez-hid2hci" "blueman"

  # Sound
  "pipewire" "pipewire-pulse" "pamixer" "pipewire-alsa" "wireplumber" "wireless-regdb"
  "alsa-plugins" "alsa-firmware" "alsa-utils"
  "ethtool" "sof-firmware"
  "libnotify" "swaync" "wob"

  # Asus Hardware
  "power-profiles-daemon" "asusctl" "supergfxctl" "rog-control-center"

  # Xdg Desktop Portals
  "xdg-desktop-portal" "aur/nautilus-dummy" "xdg-desktop-portal-gnome" "xdg-desktop-portal-gtk"
  "libportal-gtk4" "libportal-qt6"
  "xdg-user-dirs"

  # Flatpak
  "flatpak" "flatseal"

  # Brightness
  "brightnessctl" "ddcutil" "ddcui"

  # Network
  "dhclient" "dnsmasq"
  "iproute2" "iwd"
  "networkmanager"
  "curl" "wget"
  "openbsd-netcat"
  "nss-mdns"

  # Filesystem
  "e2fsprogs" "dosfstools" "exfatprogs"
  "efibootmgr" "efitools" "gnome-keyring"
  "gvfs" "gvfs-afc" "gvfs-goa" "gvfs-mtp" "gvfs-nfs" "gvfs-onedrive" "gvfs-smb" "gvfs-wsdd"
  "nfs-utils" "nilfs-utils"
  "sshfs" "openssh"
  "libgsf" "trash-cli"

  # Media
  "ffmpeg" "ffmpegthumbnailer" "ffmpegthumbs"
  "gst-plugins-base" "gst-plugins-good" "gst-plugins-bad" "gst-plugins-ugly"
  "gst-libav" "gst-plugin-pipewire"
  "libdvdcss" "libopenraw"

  # QT
  "qt6-wayland" "layer-shell-qt"

  # Policy Kit
  "polkit" "mate-polkit" "rtkit"

  # Power
  "power-profiles-daemon" "asusctl" "rog-control-center"

  # Appindicator
  "libappindicator" "libayatana-appindicator"
  "libdbusmenu-qt5" "libdbusmenu-gtk" "libdbusmenu-glib"

  # Misc
  "base" "base-devel" "bc" "bind" "bridge-utils" "diffutils" "duff"
  "inetutils" "which" "upower"

  # Accessibility
  "orca"

  #================== CLI-TUI Tools ===================

  # Git
  "git" "git-diff" "git-lfs"
  "git-cliff" "lazygit" "github-cli"

  # Development
  "direnv" "neovim" "go-yq" "yt-dlp"
  "shellcheck-bin"

  # Replacements
  "bat" "bat-extras"
  "eza" "wiremix"
  "handlr-regex" "xdg-menu" "xdg-ninja" "archlinux-xdg-menu"

  # System Fetch tools
  "fastfetch" "figlet"

  # FileSystem
  "yazi" "fzf" "ripgrep" "fd" "zoxide"
  "hwdetect" "hwinfo"

  # File Sync
  "rsync" "syncthing"

  # System Monitors
  "btop" "bottom" "nvtop"
  "resources"

  # JavaScript
  "nodejs" "npm" "bun-bin"
  "nodejs-live-server"

  # Python
  "python" "python-pip" "uv"
  "python-argcomplete"

  # Docker
  "distrobox" "docker" "docker-compose"

  #=================== GUI Apps =========================

  # Password Manger
  "keepassxc" "git-credential-keepassxc-bin"

  # Development
  "wezterm-git" "foot"
  "zed" "visual-studio-code-bin"
  "obsidian"

  # launcher
  "wl-clipboard" "vicinae-bin" "rofi"

  # Browsers
  "zen-browser-bin" "brave-bin"

  # Filesystem
  "btrfs-assistant" "btrfs-progs" "snapper"
  "gparted" "jfsutils"
  "baobab" "smartmontools"
  "pcmanfm-qt" "lxqt-sudo"
  "lxqt-archiver"

  # Media
  "obs-studio"
  "grimblast-git" "satty"
  "inkscape" "nomacs-git"
  "pavucontrol-qt"
  "mpv" "mpv-mpris2-bin" "mpd"
  "mkvtoolnix-gui"

  # DE Apps
  "niri"
  "swayidle" "gtklock" "swww"

  "localsend"

  # Backup
  "vorta" "vorta-root"
  "timeshift"

  # Calculator
  "qalculate-qt"
)

extra=(
  "gdu"                            # Disk Usage Analyzer tui
  "calcurse"                       # TUI Calander
  "gimp"                           # Image Editor
  "gnome-boxes" "spice-gtk" "vde2" # Virtual Machine Manager
  "gnome-disk-utility"             # Disk Utility
  "ktorrent"                       # Torrent Client
  "lazydocker"                     # Docker GUI
  "zenity"                         # Dialog Utility
  "vesktop"                        # Discord client
  "suprefile"                      # File Manager tui
  "rpm-tools"                      # RPM tools
)
