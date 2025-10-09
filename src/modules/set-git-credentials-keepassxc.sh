# enable browser integration in KeePassXC settings, then
git-credential-keepassxc caller me

log.warn "Please Unlock KeePassXC Database."
keepassxc

log.warn "please Give Connection name: keepassxc-credientials-helper"
git-credential-keepassxc configure
git-credential-keepassxc caller add --uid "$(id -u)" --gid "$(id -g)" "$(command -v git)"

git config --global --replace-all credential.helper 'keepassxc --git-groups'
