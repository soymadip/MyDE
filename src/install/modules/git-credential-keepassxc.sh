# Compile git-credential-keepassxc and configure git to use it
# SHOULD BE IMPORTED IN POST-INSTALL SCRIPT

cargo install --locked cargo-update
cargo install --locked git-credential-keepassxc
# pkg-install git-credential-keepassxc-bin

git-credential-keepassxc caller me
git-credential-keepassxc configure
git config --global --replace-all credential.helper 'keepassxc --git-groups'
