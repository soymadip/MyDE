# SHOULD BE USED IN USER MODE

pkg-install virtualbox
pkg-install virtualbox-host-modules-arch

log.info "Adding user to 'vboxusers' group"
sudo usermod -aG vboxusers $(whoami)

log.warn "Re-Login then run script again to continue"
